import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create a curved animation for the zoom effect
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Add animation listener to navigate when complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to EnterNameScreen after animation completes
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EnterNameScreen()),
        );
      }
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF).withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 2.8,
              end: 1.2,
            ).animate(_animation),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0.0,
                end: 1.8,
              ).animate(_animation),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo from assets
                  Container(
                    width: 150,
                    height: 150,
                    // decoration: const BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: Colors.white,
                    // ),
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // App name text
                  const Text(
                    'Peer Drop',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter to draw the logo (globe with cursor)
class GlobeAndCursorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw globe (circle)
    canvas.drawCircle(center, radius, paint);

    // Draw longitude lines
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi / 2,
      pi,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3 * pi / 2,
      pi / 2,
      false,
      paint,
    );

    // Draw latitude lines
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );

    // Draw cursor/arrow
    final Path cursorPath = Path();
    final double arrowSize = radius * 0.6;
    final Offset arrowStart = Offset(center.dx + radius * 0.3, center.dy + radius * 0.3);

    cursorPath.moveTo(arrowStart.dx, arrowStart.dy);
    cursorPath.lineTo(arrowStart.dx + arrowSize, arrowStart.dy);
    cursorPath.lineTo(arrowStart.dx, arrowStart.dy + arrowSize);
    cursorPath.close();

    final Paint cursorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(cursorPath, cursorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class EnterNameScreen extends StatefulWidget {
  const EnterNameScreen({super.key});

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    setState(() => _isLoading = true);

    final permissions = [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.nearbyWifiDevices,
    ];

    final statuses = await permissions.request();

    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      showPermissionDialog();
    }

    setState(() => _isLoading = false);
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Permissions Required"),
          content: const Text(
              "Some permissions are permanently denied. Please enable them in app settings to use this app."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF).withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logo1.png',
                  width: 70,
                  height: 70,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Peer Drop',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Chat with nearby devices without internet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter Your Name',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        hintText: 'How others will see you',
                      ),
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _continueToChat(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _continueToChat,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Continue to Chat'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToChat() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(userName: name),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name to continue'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

// The rest of your code (ChatScreen and other classes) remains unchanged

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({super.key, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String randomID = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAdvertising = false;
  bool _isScanning = false;

  // New property for personal messaging
  String? _selectedRecipient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
        actions: [
          Badge(
            label: Text(endpointMap.length.toString()),
            isLabelVisible: endpointMap.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.people),
              onPressed: _showConnectedDevices,
              tooltip: 'Connected Devices',
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Connection Status'),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showConnectionStatus();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Connection status indicators
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                StatusIndicator(
                  isActive: _isAdvertising,
                  label: 'Broadcasting',
                  activeColor: Colors.green,
                ),
                const SizedBox(width: 16),
                StatusIndicator(
                  isActive: _isScanning,
                  label: 'Scanning',
                  activeColor: Colors.blue,
                ),
                const Spacer(),
                if (endpointMap.isNotEmpty)
                  Text(
                    '${endpointMap.length} device${endpointMap.length > 1 ? 's' : ''} connected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation or connect with nearby devices',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),
          ),

          // Message input - replaced with new version
          _buildMessageInputArea(),

          // Connection buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.broadcast_on_personal),
                    label: Text(_isAdvertising ? "Stop Broadcasting" : "Broadcast"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAdvertising ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _toggleAdvertising(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: Text(_isScanning ? "Stop Scanning" : "Scan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isScanning ? Colors.red : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _toggleDiscovery(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // New method to build message input area with recipient selection
  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show selected recipient indicator if in personal chat mode
            if (_selectedRecipient != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "To: ${endpointMap[_selectedRecipient]?.endpointName ?? 'Unknown'}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRecipient = null;
                        });
                        showSnackbar("Now chatting with everyone");
                      },
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: _showRecipientSelectionDialog,
                  tooltip: 'Select Recipient',
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _selectedRecipient != null
                          ? "Type a personal message"
                          : "Type a message",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[200]
                          : Colors.grey[800],
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(width: 6),
                Material(
                  color: _selectedRecipient != null
                      ? Colors.purple
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => sendMessage(public: false),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        _selectedRecipient != null ? Icons.person : Icons.send,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                if (_selectedRecipient == null) ...[
                  const SizedBox(width: 6),
                  Material(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => sendMessage(public: true),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.public,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // New method to show recipient selection dialog
  void _showRecipientSelectionDialog() {
    if (endpointMap.isEmpty) {
      showSnackbar("No devices connected");
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Recipient",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...endpointMap.entries.map((entry) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        entry.value.endpointName.isNotEmpty
                            ? entry.value.endpointName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(entry.value.endpointName),
                    onTap: () {
                      setState(() {
                        _selectedRecipient = entry.key;
                      });
                      Navigator.pop(context);
                      showSnackbar("Now chatting with ${entry.value.endpointName}");
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),
                if (_selectedRecipient != null)
                  ListTile(
                    leading: const Icon(Icons.public),
                    title: const Text("Everyone (Public)"),
                    onTap: () {
                      setState(() {
                        _selectedRecipient = null;
                      });
                      Navigator.pop(context);
                      showSnackbar("Now chatting with everyone");
                    },
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // New method to build message items in the chat
  Widget _buildMessageItem(ChatMessage message) {
    final bool isFromMe = message.isFromMe;
    final bool isPersonal = message.isPersonal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isFromMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isFromMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: isPersonal ? Colors.purple : Colors.grey,
              child: Text(
                message.senderName.isNotEmpty
                    ? message.senderName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isFromMe
                    ? (isPersonal ? Colors.purple : Theme.of(context).primaryColor)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isFromMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isFromMe && (message.public || isPersonal))
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isFromMe
                            ? Colors.white
                            : (isPersonal ? Colors.purple : Theme.of(context).primaryColor),
                      ),
                    ),
                  if (isPersonal && message.recipient != null) ...[
                    Text(
                      isFromMe ? "To: ${message.recipient}" : "To: You",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        color: isFromMe ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isFromMe
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message.public && isFromMe)
                        Icon(
                          Icons.public,
                          size: 12,
                          color: isFromMe ? Colors.white70 : Colors.grey,
                        ),
                      if (isPersonal)
                        Icon(
                          Icons.person,
                          size: 12,
                          color: isFromMe ? Colors.white70 : Colors.grey,
                        ),
                      if ((message.public && isFromMe) || isPersonal)
                        const SizedBox(width: 4),
                      Text(
                        message.timestamp,
                        style: TextStyle(
                          fontSize: 10,
                          color: isFromMe ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFromMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  // Updated method to handle both public and personal messages
  void sendMessage({required bool public}) {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final String formattedTime = _getFormattedTime();

    if (_selectedRecipient != null) {
      // Personal message to specific recipient
      final recipientId = _selectedRecipient!;
      final recipientName = endpointMap[recipientId]?.endpointName ?? "Unknown";

      // Create a message object that includes metadata
      final Map<String, dynamic> messageData = {
        'text': message,
        'sender': widget.userName,
        'timestamp': formattedTime,
        'public': false,
        'type': 'personal'
      };

      // Convert to JSON and then to bytes
      final String jsonMessage = jsonEncode(messageData);
      Nearby().sendBytesPayload(recipientId, Uint8List.fromList(jsonMessage.codeUnits));

      // Add message to local chat
      setState(() {
        _messages.add(
          ChatMessage(
            text: message,
            isFromMe: true,
            senderName: widget.userName,
            timestamp: formattedTime,
            public: false,
            isPersonal: true,
            recipient: recipientName,
          ),
        );
      });

      _scrollToBottom();
    } else if (endpointMap.isNotEmpty) {
      // Broadcast to all connected endpoints
      endpointMap.forEach((key, value) {
        // Create a message object that includes metadata
        final Map<String, dynamic> messageData = {
          'text': message,
          'sender': widget.userName,
          'timestamp': formattedTime,
          'public': public,
          'type': 'broadcast'
        };

        // Convert to JSON and then to bytes
        final String jsonMessage = jsonEncode(messageData);
        Nearby().sendBytesPayload(key, Uint8List.fromList(jsonMessage.codeUnits));
      });

      // Add message to local chat
      setState(() {
        _messages.add(
          ChatMessage(
            text: message,
            isFromMe: true,
            senderName: widget.userName,
            timestamp: formattedTime,
            public: public,
          ),
        );
      });

      _scrollToBottom();
    } else {
      showSnackbar("No connected devices. Connect first.");
    }

    _messageController.clear();
  }

  Future<void> _toggleAdvertising() async {
    try {
      if (_isAdvertising) {
        await Nearby().stopAdvertising();
        setState(() => _isAdvertising = false);
        showSnackbar("Broadcasting stopped");
      } else {
        bool result = await Nearby().startAdvertising(
          widget.userName,
          strategy,
          onConnectionInitiated: onConnectionInit,
          onConnectionResult: (id, status) {
            showSnackbar("Connection ${status.name} with $id");
          },
          onDisconnected: (id) {
            setState(() {
              endpointMap.remove(id);
            });
            showSnackbar("Disconnected from $id");
          },
        );
        setState(() => _isAdvertising = result);
        showSnackbar("Broadcasting ${result ? 'started' : 'failed'}");
      }
    } catch (exception) {
      showSnackbar("Error: ${exception.toString()}");
      setState(() => _isAdvertising = false);
    }
  }

  Future<void> _toggleDiscovery() async {
    try {
      if (_isScanning) {
        await Nearby().stopDiscovery();
        setState(() => _isScanning = false);
        showSnackbar("Scanning stopped");
      } else {
        bool result = await Nearby().startDiscovery(
          widget.userName,
          strategy,
          onEndpointFound: (id, name, serviceId) {
            _showDiscoveredEndpoint(id, name, serviceId);
          },
          onEndpointLost: (id) {
            showSnackbar("Lost discovered endpoint: $id");
          },
        );
        setState(() => _isScanning = result);
        showSnackbar("Scanning ${result ? 'started' : 'failed'}");
      }
    } catch (exception) {
      showSnackbar("Error: ${exception.toString()}");
      setState(() => _isScanning = false);
    }
  }

  void _showDiscoveredEndpoint(String id, String name, String serviceId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 24,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Device ID: $id",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Connect with this device?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Nearby().requestConnection(
                            widget.userName,
                            id,
                            onConnectionInitiated: onConnectionInit,
                            onConnectionResult: (id, status) {
                              showSnackbar("Connection ${status.name} with $id");
                            },
                            onDisconnected: (id) {
                              setState(() {
                                endpointMap.remove(id);
                              });
                              showSnackbar("Disconnected from $id");
                            },
                          );
                        },
                        child: const Text('Connect'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 24,
                      child: Text(
                        info.endpointName.isNotEmpty
                            ? info.endpointName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.endpointName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ID: $id",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Connection request",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Nearby().rejectConnection(id);
                        },
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            endpointMap[id] = info;
                          });
                          Nearby().acceptConnection(
                            id,
                            onPayLoadRecieved: (endid, payload) async {
                              if (payload.type == PayloadType.BYTES) {
                                String message = String.fromCharCodes(payload.bytes!);
                                _processReceivedMessage(message, endid);
                              }
                            },
                            onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                              // Optional: Handle transfer updates if needed
                            },
                          );
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Process received messages with JSON format
  void _processReceivedMessage(String jsonMessage, String senderId) {
    try {
      // Parse the JSON message
      Map<String, dynamic> messageData = jsonDecode(jsonMessage);

      // Extract message components
      String messageText = messageData['text'] ?? '';
      String senderName = messageData['sender'] ?? 'Unknown';
      String timestamp = messageData['timestamp'] ?? _getFormattedTime();
      bool isPublic = messageData['public'] ?? true;
      String messageType = messageData['type'] ?? 'broadcast';

      // Add the message to chat
      setState(() {
        _messages.add(
          ChatMessage(
            text: messageText,
            isFromMe: false,
            senderName: senderName,
            timestamp: timestamp,
            public: isPublic,
            isPersonal: messageType == 'personal',
          ),
        );
      });

      _scrollToBottom();
    } catch (e) {
      print("Error processing message: $e");
      // Fallback for non-JSON messages from older versions
      setState(() {
        _messages.add(
          ChatMessage(
            text: jsonMessage,
            isFromMe: false,
            senderName: endpointMap[senderId]?.endpointName ?? 'Unknown',
            timestamp: _getFormattedTime(),
            public: true,
          ),
        );
      });

      _scrollToBottom();
    }
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showConnectedDevices() {
    if (endpointMap.isEmpty) {
      showSnackbar("No devices connected");
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Connected Devices",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: endpointMap.length,
                  itemBuilder: (context, index) {
                    final entry = endpointMap.entries.elementAt(index);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          entry.value.endpointName.isNotEmpty
                              ? entry.value.endpointName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(entry.value.endpointName),
                      subtitle: Text("ID: ${entry.key}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.person_pin),
                        onPressed: () {
                          setState(() {
                            _selectedRecipient = entry.key;
                          });
                          Navigator.pop(context);
                          showSnackbar("Now chatting with ${entry.value.endpointName}");
                        },
                      ),
                      onTap: () {
                        // Show device details or options
                        _showDeviceOptions(entry.key, entry.value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeviceOptions(String deviceId, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 24,
                      child: Text(
                        info.endpointName.isNotEmpty
                            ? info.endpointName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.endpointName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ID: $deviceId",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Send Private Message'),
                  onTap: () {
                    setState(() {
                      _selectedRecipient = deviceId;
                    });
                    Navigator.pop(context);
                    showSnackbar("Now chatting with ${info.endpointName}");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.link_off),
                  title: const Text('Disconnect'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDisconnectConfirmation(deviceId, info);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDisconnectConfirmation(String deviceId, ConnectionInfo info) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Disconnect Device"),
          content: Text("Are you sure you want to disconnect from ${info.endpointName}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Nearby().disconnectFromEndpoint(deviceId);
                setState(() {
                  endpointMap.remove(deviceId);
                  if (_selectedRecipient == deviceId) {
                    _selectedRecipient = null;
                  }
                });
                showSnackbar("Disconnected from ${info.endpointName}");
              },
              child: const Text("Disconnect"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConnectionStatus() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Connection Status",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    StatusIndicator(
                      isActive: _isAdvertising,
                      label: 'Broadcasting',
                      activeColor: Colors.green,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _isAdvertising
                          ? "Broadcasting as ${widget.userName}"
                          : "Not broadcasting",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StatusIndicator(
                      isActive: _isScanning,
                      label: 'Scanning',
                      activeColor: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _isScanning ? "Scanning for devices" : "Not scanning",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StatusIndicator(
                      isActive: endpointMap.isNotEmpty,
                      label: 'Connections',
                      activeColor: Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${endpointMap.length} device${endpointMap.length != 1 ? 's' : ''} connected",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    Nearby().stopAllEndpoints();
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromMe;
  final String senderName;
  final String timestamp;
  final bool public;
  final bool isPersonal;
  final String? recipient;

  ChatMessage({
    required this.text,
    required this.isFromMe,
    required this.senderName,
    required this.timestamp,
    this.public = true,
    this.isPersonal = false,
    this.recipient,
  });
}

class StatusIndicator extends StatelessWidget {
  final bool isActive;
  final String label;
  final Color activeColor;

  const StatusIndicator({
    super.key,
    required this.isActive,
    required this.label,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
          BoxShadow(
            color: activeColor.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ]
            : null,
      ),
    );
  }
}
