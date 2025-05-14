// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:nearby_connections/nearby_connections.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class EnterNameScreen extends StatefulWidget {
//   const EnterNameScreen({super.key});
//
//   @override
//   State<EnterNameScreen> createState() => _EnterNameScreenState();
// }
//
// class _EnterNameScreenState extends State<EnterNameScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   Future<void> requestPermissions() async {
//     setState(() => _isLoading = true);
//
//     final permissions = [
//       Permission.location,
//       Permission.bluetooth,
//       Permission.bluetoothAdvertise,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.nearbyWifiDevices,
//     ];
//
//     final statuses = await permissions.request();
//
//     if (statuses.values.any((status) => status.isPermanentlyDenied)) {
//       showPermissionDialog();
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   void showPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Permissions Required"),
//           content: const Text(
//               "Some permissions are permanently denied. Please enable them in app settings to use this app."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 openAppSettings();
//               },
//               child: const Text("Open Settings"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Theme.of(context).primaryColor,
//               Theme.of(context).primaryColor.withOpacity(0.7),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.chat_bubble_outline,
//                   size: 60,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 'Nearby Chat',
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Chat with nearby devices without internet',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Create groups and chat privately',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 margin: const EdgeInsets.all(20),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Enter Your Name',
//                       style: Theme.of(context).textTheme.titleLarge,
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Name',
//                         prefixIcon: Icon(Icons.person),
//                         hintText: 'How others will see you',
//                       ),
//                       autofocus: true,
//                       textCapitalization: TextCapitalization.words,
//                       onSubmitted: (_) => _continueToChat(),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _continueToChat,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                       ),
//                       child: const Text('Continue to Chat'),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _continueToChat() {
//     final name = _nameController.text.trim();
//     if (name.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatScreen(userName: name),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a name to continue'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
// }
//
//
//
//
//
//
// class ChatScreen extends StatefulWidget {
//   final String userName;
//
//   const ChatScreen({super.key, required this.userName});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   final String deviceId = Random().nextInt(10000).toString();
//   final Strategy strategy = Strategy.P2P_STAR;
//   Map<String, ConnectionInfo> endpointMap = {};
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   TabController? _tabController;
//   bool _isAdvertising = false;
//   bool _isScanning = false;
//
//   // Conversation management
//   final List<ChatMessage> _allMessages = [];
//   final Map<String, List<ChatMessage>> _privateMessages = {};
//   final Map<String, ChatGroup> _groups = {};
//   String? _selectedChat; // deviceId or groupId
//   ChatType _currentChatType = ChatType.all;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController!.addListener(_handleTabChange);
//   }
//
//   void _handleTabChange() {
//     if (_tabController!.indexIsChanging) {
//       setState(() {
//         switch (_tabController!.index) {
//           case 0:
//             _currentChatType = ChatType.all;
//             _selectedChat = null;
//             break;
//           case 1:
//             _currentChatType = ChatType.private;
//             _selectedChat = _privateMessages.isNotEmpty ? _privateMessages.keys.first : null;
//             break;
//           case 2:
//             _currentChatType = ChatType.group;
//             _selectedChat = _groups.isNotEmpty ? _groups.keys.first : null;
//             break;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Theme.of(context).primaryColor,
//               child: Text(
//                 widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.userName),
//                 Text(
//                   "Device ID: $deviceId",
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           Badge(
//             label: Text(endpointMap.length.toString()),
//             isLabelVisible: endpointMap.isNotEmpty,
//             child: IconButton(
//               icon: const Icon(Icons.people),
//               onPressed: _showConnectedDevices,
//               tooltip: 'Connected Devices',
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _showAddGroupDialog,
//             tooltip: 'Create Group',
//           ),
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: const Text('Connection Status'),
//                 onTap: () {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _showConnectionStatus();
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(icon: Icon(Icons.public), text: "All"),
//             Tab(icon: Icon(Icons.person), text: "Private"),
//             Tab(icon: Icon(Icons.group), text: "Groups"),
//           ],
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           // Connection status indicators
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//             color: Theme.of(context).primaryColor.withOpacity(0.1),
//             child: Row(
//               children: [
//                 StatusIndicator(
//                   isActive: _isAdvertising,
//                   label: 'Broadcasting',
//                   activeColor: Colors.green,
//                 ),
//                 const SizedBox(width: 16),
//                 StatusIndicator(
//                   isActive: _isScanning,
//                   label: 'Scanning',
//                   activeColor: Colors.blue,
//                 ),
//                 const Spacer(),
//                 if (endpointMap.isNotEmpty)
//                   Text(
//                     '${endpointMap.length} device${endpointMap.length > 1 ? 's' : ''} connected',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//               ],
//             ),
//           ),
//
//           // Current chat selection (for private and group chats)
//           if (_currentChatType != ChatType.all)
//             _buildChatSelector(),
//
//           // Chat messages area
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // All messages tab
//                 _buildChatMessagesView(_allMessages),
//
//                 // Private messages tab
//                 _selectedChat != null && _privateMessages.containsKey(_selectedChat)
//                     ? _buildChatMessagesView(_privateMessages[_selectedChat]!)
//                     : _buildEmptyChatView("No private chat selected"),
//
//                 // Group messages tab
//                 _selectedChat != null && _groups.containsKey(_selectedChat)
//                     ? _buildChatMessagesView(_groups[_selectedChat]!.messages)
//                     : _buildEmptyChatView("No group selected"),
//               ],
//             ),
//           ),
//
//           // Message input
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   offset: const Offset(0, -1),
//                   blurRadius: 3,
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: _getMessageHint(),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(24),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Theme.of(context).brightness == Brightness.light
//                             ? Colors.grey[200]
//                             : Colors.grey[800],
//                       ),
//                       minLines: 1,
//                       maxLines: 5,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Material(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(24),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(24),
//                       onTap: () => sendMessage(),
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         child: const Icon(
//                           Icons.send,
//                           color: Colors.white,
//                           size: 22,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Connection buttons
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.broadcast_on_personal),
//                     label: Text(_isAdvertising ? "Stop Broadcasting" : "Broadcast"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _isAdvertising ? Colors.red : Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () => _toggleAdvertising(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.search),
//                     label: Text(_isScanning ? "Stop Scanning" : "Scan"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _isScanning ? Colors.red : Colors.blue,
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () => _toggleDiscovery(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChatSelector() {
//     List<DropdownMenuItem<String>> items = [];
//
//     if (_currentChatType == ChatType.private) {
//       items = _privateMessages.entries
//           .map((entry) => DropdownMenuItem<String>(
//         value: entry.key,
//         child: Text(endpointMap[entry.key]?.endpointName ?? "Unknown"),
//       ))
//           .toList();
//     } else if (_currentChatType == ChatType.group) {
//       items = _groups.entries
//           .map((entry) => DropdownMenuItem<String>(
//         value: entry.key,
//         child: Text(entry.value.name),
//       ))
//           .toList();
//     }
//
//     if (items.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(8),
//         color: Colors.grey[200],
//         child: Row(
//           children: [
//             Icon(
//               _currentChatType == ChatType.private ? Icons.person : Icons.group,
//               size: 16,
//               color: Colors.grey[600],
//             ),
//             const SizedBox(width: 8),
//             Text(
//               _currentChatType == ChatType.private
//                   ? "No private chats yet"
//                   : "No groups yet",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: _currentChatType == ChatType.private
//                   ? _showConnectedDevices
//                   : _showAddGroupDialog,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 textStyle: const TextStyle(fontSize: 12),
//               ),
//               child: Text(_currentChatType == ChatType.private
//                   ? "Start Chat"
//                   : "Create Group"),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.grey[200],
//       child: Row(
//         children: [
//           Icon(
//             _currentChatType == ChatType.private ? Icons.person : Icons.group,
//             size: 18,
//             color: Colors.grey[700],
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: DropdownButton<String>(
//               value: _selectedChat,
//               isExpanded: true,
//               underline: Container(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedChat = newValue;
//                 });
//               },
//               items: items,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChatMessagesView(List<ChatMessage>? messages) {
//     if (messages == null || messages.isEmpty) {
//       return _buildEmptyChatView("No messages yet");
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ListView.builder(
//         controller: _scrollController,
//         itemCount: messages.length,
//         itemBuilder: (context, index) {
//           final message = messages[index];
//           final bool isFromMe = message.isFromMe;
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               mainAxisAlignment: isFromMe
//                   ? MainAxisAlignment.end
//                   : MainAxisAlignment.start,
//               children: [
//                 if (!isFromMe) ...[
//                   CircleAvatar(
//                     radius: 16,
//                     backgroundColor: _getChatColor(message.senderName),
//                     child: Text(
//                       message.senderName.isNotEmpty
//                           ? message.senderName[0].toUpperCase()
//                           : '?',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//                 Flexible(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isFromMe
//                           ? Theme.of(context).primaryColor
//                           : Theme.of(context).cardColor,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: isFromMe
//                           ? CrossAxisAlignment.end
//                           : CrossAxisAlignment.start,
//                       children: [
//                         if (!isFromMe)
//                           Text(
//                             message.senderName,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: isFromMe
//                                   ? Colors.white
//                                   : Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         Text(
//                           message.text,
//                           style: TextStyle(
//                             color: isFromMe
//                                 ? Colors.white
//                                 : Theme.of(context).textTheme.bodyLarge?.color,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               _getChatTypeIcon(message.chatType),
//                               size: 12,
//                               color: isFromMe
//                                   ? Colors.white70
//                                   : Colors.grey,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               message.timestamp,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: isFromMe
//                                     ? Colors.white70
//                                     : Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (isFromMe) const SizedBox(width: 4),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildEmptyChatView(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.chat_bubble_outline,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _getEmptySubtitle(),
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getEmptySubtitle() {
//     switch (_currentChatType) {
//       case ChatType.all:
//         return "Connect with nearby devices first";
//       case ChatType.private:
//         return "Select a device for private messaging";
//       case ChatType.group:
//         return "Create or select a group to start chatting";
//     }
//   }
//
//   IconData _getChatTypeIcon(ChatType type) {
//     switch (type) {
//       case ChatType.all:
//         return Icons.public;
//       case ChatType.private:
//         return Icons.person;
//       case ChatType.group:
//         return Icons.group;
//     }
//   }
//
//   Color _getChatColor(String name) {
//     // Generate a deterministic color based on the sender's name
//     final int hash = name.hashCode;
//     final List<Color> colors = [
//       Colors.blue,
//       Colors.green,
//       Colors.orange,
//       Colors.purple,
//       Colors.teal,
//       Colors.pink,
//       Colors.indigo,
//       Colors.amber,
//     ];
//
//     return colors[hash.abs() % colors.length];
//   }
//
//   String _getMessageHint() {
//     switch (_currentChatType) {
//       case ChatType.all:
//         return "Message all connected devices";
//       case ChatType.private:
//         final name = _selectedChat != null && endpointMap.containsKey(_selectedChat)
//             ? endpointMap[_selectedChat!]?.endpointName
//             : null;
//         return name != null ? "Message $name privately" : "Select a device first";
//       case ChatType.group:
//         final name = _selectedChat != null && _groups.containsKey(_selectedChat)
//             ? _groups[_selectedChat!]?.name
//             : null;
//         return name != null ? "Message group: $name" : "Select a group first";
//     }
//   }
//
//   void _showAddGroupDialog() {
//     if (endpointMap.isEmpty) {
//       showSnackbar("Connect to devices first to create a group");
//       return;
//     }
//
//     final TextEditingController groupNameController = TextEditingController();
//     final Map<String, bool> selectedDevices = {};
//
//     // Initialize with all endpoints selected
//     endpointMap.forEach((key, value) {
//       selectedDevices[key] = true;
//     });
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text("Create New Group"),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: groupNameController,
//                       decoration: const InputDecoration(
//                         labelText: "Group Name",
//                         hintText: "Enter a name for your group",
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Select Group Members",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     ...endpointMap.entries.map((entry) {
//                       return CheckboxListTile(
//                         title: Text(entry.value.endpointName),
//                         value: selectedDevices[entry.key] ?? false,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             selectedDevices[entry.key] = value ?? false;
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final groupName = groupNameController.text.trim();
//                     if (groupName.isEmpty) {
//                       showSnackbar("Please enter a group name");
//                       return;
//                     }
//
//                     final List<String> members = selectedDevices.entries
//                         .where((entry) => entry.value)
//                         .map((entry) => entry.key)
//                         .toList();
//
//                     if (members.isEmpty) {
//                       showSnackbar("Please select at least one member");
//                       return;
//                     }
//
//                     // Create the group
//                     _createGroup(groupName, members);
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Create Group"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _createGroup(String name, List<String> members) {
//     final String groupId = "group_${DateTime.now().millisecondsSinceEpoch}";
//
//     final newGroup = ChatGroup(
//       id: groupId,
//       name: name,
//       members: members,
//       createdBy: deviceId,
//       messages: [],
//     );
//
//     setState(() {
//       _groups[groupId] = newGroup;
//       _currentChatType = ChatType.group;
//       _selectedChat = groupId;
//       _tabController!.animateTo(2); // Switch to groups tab
//     });
//
//     // Notify all members about the new group
//     _broadcastGroupInfo(newGroup);
//     showSnackbar("Group '$name' created with ${members.length} members");
//   }
//
//   void _broadcastGroupInfo(ChatGroup group) {
//     final groupInfo = {
//       'type': 'group_info',
//       'id': group.id,
//       'name': group.name,
//       'members': group.members,
//       'createdBy': group.createdBy,
//     };
//
//     final payload = jsonEncode(groupInfo);
//
//     // Send to all members
//     for (final memberId in group.members) {
//       if (endpointMap.containsKey(memberId)) {
//         Nearby().sendBytesPayload(
//             memberId,
//             Uint8List.fromList(payload.codeUnits)
//         );
//       }
//     }
//   }
//
//   Future<void> _toggleAdvertising() async {
//     try {
//       if (_isAdvertising) {
//         await Nearby().stopAdvertising();
//         setState(() => _isAdvertising = false);
//         showSnackbar("Broadcasting stopped");
//       } else {
//         bool result = await Nearby().startAdvertising(
//           widget.userName,
//           strategy,
//           onConnectionInitiated: onConnectionInit,
//           onConnectionResult: (id, status) {
//             showSnackbar("Connection ${status.name} with $id");
//           },
//           onDisconnected: (id) {
//             setState(() {
//               endpointMap.remove(id);
//               _privateMessages.remove(id);
//
//               // Remove device from groups
//               _groups.forEach((groupId, group) {
//                 group.members.remove(id);
//               });
//             });
//             showSnackbar("Disconnected from $id");
//           },
//         );
//         setState(() => _isAdvertising = result);
//         showSnackbar("Broadcasting ${result ? 'started' : 'failed'}");
//       }
//     } catch (e) {
//       showSnackbar("Error toggling advertising: $e");
//     }
//   }
//
//   Future<void> _toggleDiscovery() async {
//     try {
//       if (_isScanning) {
//         await Nearby().stopDiscovery();
//         setState(() => _isScanning = false);
//         showSnackbar("Scanning stopped");
//       } else {
//         bool result = await Nearby().startDiscovery(
//           widget.userName,
//           strategy,
//           onEndpointFound: (id, name, serviceId) {
//             showSnackbar("Device found: $name ($id)");
//           },
//           onEndpointLost: (id) {
//             showSnackbar("Device lost: $id");
//           },
//           serviceId: "com.yourapp.service",
//         );
//         setState(() => _isScanning = result);
//         showSnackbar("Scanning ${result ? 'started' : 'failed'}");
//       }
//     } catch (e) {
//       showSnackbar("Error toggling discovery: $e");
//     }
//   }
//
//   void onConnectionInit(String id, ConnectionInfo info) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Connection Request"),
//         content: Text("${info.endpointName} wants to connect. Accept?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Nearby().rejectConnection(id);
//             },
//             child: const Text("Reject"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Nearby().acceptConnection(
//                 id,
//                 onPayLoadRecieved: (endpointId, payload) {
//                   _handlePayload(endpointId, payload);
//                 },
//                 onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
//                   // Handle payload transfer updates if needed
//                 },
//               );
//             },
//             child: const Text("Accept"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _handlePayload(String endpointId, Payload payload) {
//     if (payload.type == PayloadType.BYTES) {
//       String data = String.fromCharCodes(payload.bytes!);
//       Map<String, dynamic> json = jsonDecode(data);
//
//       if (json.containsKey('type')) {
//         switch (json['type']) {
//           case 'message':
//             _handleMessagePayload(endpointId, json);
//             break;
//           case 'group_info':
//             _handleGroupInfoPayload(json);
//             break;
//         // Add more payload types as needed
//         }
//       }
//     }
//   }
//
//   void _handleMessagePayload(String endpointId, Map<String, dynamic> messageData) {
//     final message = ChatMessage(
//       text: messageData['text'],
//       senderName: messageData['senderName'],
//       senderId: messageData['senderId'],
//       isFromMe: false,
//       timestamp: messageData['timestamp'] ?? _getCurrentTimestamp(),
//       chatType: _getChatTypeFromString(messageData['chatType']),
//       targetId: messageData['targetId'],
//     );
//
//     setState(() {
//       // Add to appropriate message list based on type
//       switch (message.chatType) {
//         case ChatType.all:
//           _allMessages.add(message);
//           break;
//         case ChatType.private:
//           if (!_privateMessages.containsKey(endpointId)) {
//             _privateMessages[endpointId] = [];
//           }
//           _privateMessages[endpointId]!.add(message);
//           break;
//         case ChatType.group:
//           if (message.targetId != null && _groups.containsKey(message.targetId)) {
//             _groups[message.targetId]!.messages.add(message);
//           }
//           break;
//       }
//     });
//
//     // Auto-scroll to bottom
//     _scrollToBottom();
//   }
//
//   void _handleGroupInfoPayload(Map<String, dynamic> groupData) {
//     final String groupId = groupData['id'];
//
//     if (!_groups.containsKey(groupId)) {
//       // Create new group if it doesn't exist
//       final newGroup = ChatGroup(
//         id: groupId,
//         name: groupData['name'],
//         members: List<String>.from(groupData['members']),
//         createdBy: groupData['createdBy'],
//         messages: [],
//       );
//
//       setState(() {
//         _groups[groupId] = newGroup;
//       });
//
//       showSnackbar("Added to group: ${groupData['name']}");
//     }
//   }
//
//   void sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;
//
//     switch (_currentChatType) {
//       case ChatType.all:
//         _sendBroadcastMessage(text);
//         break;
//       case ChatType.private:
//         if (_selectedChat != null) {
//           _sendPrivateMessage(_selectedChat!, text);
//         } else {
//           showSnackbar("Select a device first");
//           return;
//         }
//         break;
//       case ChatType.group:
//         if (_selectedChat != null && _groups.containsKey(_selectedChat)) {
//           _sendGroupMessage(_selectedChat!, text);
//         } else {
//           showSnackbar("Select a group first");
//           return;
//         }
//         break;
//     }
//
//     // Clear text field
//     _messageController.clear();
//   }
//
//   void _sendBroadcastMessage(String text) {
//     final message = ChatMessage(
//       text: text,
//       senderName: widget.userName,
//       senderId: deviceId,
//       isFromMe: true,
//       timestamp: _getCurrentTimestamp(),
//       chatType: ChatType.all,
//     );
//
//     setState(() {
//       _allMessages.add(message);
//     });
//
//     // Send to all connected devices
//     _broadcastMessageToAll(message);
//     _scrollToBottom();
//   }
//
//   void _sendPrivateMessage(String targetId, String text) {
//     final message = ChatMessage(
//       text: text,
//       senderName: widget.userName,
//       senderId: deviceId,
//       isFromMe: true,
//       timestamp: _getCurrentTimestamp(),
//       chatType: ChatType.private,
//       targetId: targetId,
//     );
//
//     setState(() {
//       if (!_privateMessages.containsKey(targetId)) {
//         _privateMessages[targetId] = [];
//       }
//       _privateMessages[targetId]!.add(message);
//     });
//
//     // Send to specific device
//     _sendMessageToDevice(targetId, message);
//     _scrollToBottom();
//   }
//
//   void _sendGroupMessage(String groupId, String text) {
//     if (!_groups.containsKey(groupId)) return;
//
//     final message = ChatMessage(
//       text: text,
//       senderName: widget.userName,
//       senderId: deviceId,
//       isFromMe: true,
//       timestamp: _getCurrentTimestamp(),
//       chatType: ChatType.group,
//       targetId: groupId,
//     );
//
//     setState(() {
//       _groups[groupId]!.messages.add(message);
//     });
//
//     // Send to all group members
//     for (final memberId in _groups[groupId]!.members) {
//       if (memberId != deviceId && endpointMap.containsKey(memberId)) {
//         _sendMessageToDevice(memberId, message);
//       }
//     }
//
//     _scrollToBottom();
//   }
//
//   void _broadcastMessageToAll(ChatMessage message) {
//     final messageData = {
//       'type': 'message',
//       'text': message.text,
//       'senderName': message.senderName,
//       'senderId': message.senderId,
//       'timestamp': message.timestamp,
//       'chatType': 'all',
//     };
//
//     final payload = jsonEncode(messageData);
//
//     // Send to all connected devices
//     for (final endpointId in endpointMap.keys) {
//       Nearby().sendBytesPayload(
//           endpointId,
//           Uint8List.fromList(payload.codeUnits)
//       );
//     }
//   }
//
//   void _sendMessageToDevice(String targetId, ChatMessage message) {
//     if (!endpointMap.containsKey(targetId)) return;
//
//     final messageData = {
//       'type': 'message',
//       'text': message.text,
//       'senderName': message.senderName,
//       'senderId': message.senderId,
//       'timestamp': message.timestamp,
//       'chatType': _chatTypeToString(message.chatType),
//       'targetId': message.targetId,
//     };
//
//     final payload = jsonEncode(messageData);
//
//     Nearby().sendBytesPayload(
//         targetId,
//         Uint8List.fromList(payload.codeUnits)
//     );
//   }
//
//   String _getCurrentTimestamp() {
//     final now = DateTime.now();
//     return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
//   }
//
//   ChatType _getChatTypeFromString(String? type) {
//     switch (type) {
//       case 'private':
//         return ChatType.private;
//       case 'group':
//         return ChatType.group;
//       default:
//         return ChatType.all;
//     }
//   }
//
//   String _chatTypeToString(ChatType type) {
//     switch (type) {
//       case ChatType.private:
//         return 'private';
//       case ChatType.group:
//         return 'group';
//       default:
//         return 'all';
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _showConnectedDevices() {
//     if (endpointMap.isEmpty) {
//       showSnackbar("No devices connected");
//       return;
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Connected Devices"),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: endpointMap.length,
//             itemBuilder: (context, index) {
//               final entry = endpointMap.entries.elementAt(index);
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: _getChatColor(entry.value.endpointName),
//                   child: Text(
//                     entry.value.endpointName[0].toUpperCase(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 title: Text(entry.value.endpointName),
//                 subtitle: Text("ID: ${entry.key}"),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.message),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     setState(() {
//                       _currentChatType = ChatType.private;
//                       _selectedChat = entry.key;
//                       _tabController!.animateTo(1); // Switch to private tab
//                     });
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showConnectionStatus() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Connection Status"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             StatusRow(
//               isActive: _isAdvertising,
//               label: "Broadcasting",
//               description: "Letting other devices find you",
//             ),
//             const SizedBox(height: 12),
//             StatusRow(
//               isActive: _isScanning,
//               label: "Scanning",
//               description: "Looking for other devices",
//             ),
//             const SizedBox(height: 12),
//             Text(
//               "Connected Devices: ${endpointMap.length}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               endpointMap.isEmpty
//                   ? "No devices connected"
//                   : endpointMap.values.map((e) => e.endpointName).join(", "),
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _tabController?.dispose();
//     Nearby().stopAdvertising();
//     Nearby().stopDiscovery();
//     Nearby().stopAllEndpoints();
//     super.dispose();
//   }
// }
//
// // Helper classes
//
// class ChatMessage {
//   final String text;
//   final String senderName;
//   final String senderId;
//   final bool isFromMe;
//   final String timestamp;
//   final ChatType chatType;
//   final String? targetId; // deviceId for private, groupId for group
//
//   ChatMessage({
//     required this.text,
//     required this.senderName,
//     required this.senderId,
//     required this.isFromMe,
//     required this.timestamp,
//     required this.chatType,
//     this.targetId,
//   });
// }
//
// class ChatGroup {
//   final String id;
//   final String name;
//   final List<String> members;
//   final String createdBy;
//   final List<ChatMessage> messages;
//
//   ChatGroup({
//     required this.id,
//     required this.name,
//     required this.members,
//     required this.createdBy,
//     required this.messages,
//   });
// }
//
// enum ChatType {
//   all,
//   private,
//   group,
// }
//
// class StatusIndicator extends StatelessWidget {
//   final bool isActive;
//   final String label;
//   final Color activeColor;
//
//   const StatusIndicator({
//     super.key,
//     required this.isActive,
//     required this.label,
//     required this.activeColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: isActive ? activeColor : Colors.grey,
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: isActive ? activeColor : Colors.grey,
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class StatusRow extends StatelessWidget {
//   final bool isActive;
//   final String label;
//   final String description;
//
//   const StatusRow({
//     super.key,
//     required this.isActive,
//     required this.label,
//     required this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: isActive ? Colors.green : Colors.grey,
//             borderRadius: BorderRadius.circular(6),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: isActive ? Colors.green : Colors.grey[700],
//               ),
//             ),
//             Text(
//               description,
//               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }