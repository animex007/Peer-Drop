import 'dart:async';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final String userName;
  final VoidCallback onLoadingComplete;

  const LoadingScreen({
    super.key,
    required this.userName,
    required this.onLoadingComplete,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentImageIndex = 0;
  late Timer _imageRotationTimer;
  late Timer _loadingTimer;

  // List of image assets to rotate through
  final List<String> _loadingImages = [
    'assets/loading1.png',
    'assets/loading2.png',
    'assets/loading4.png',
    'assets/loading3.png',
  ];

  @override
  void initState() {
    super.initState();

    // Animation controller for fading images
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Timer to rotate through images
    _imageRotationTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _loadingImages.length;
      });
      _animationController.reset();
      _animationController.forward();
    });

    // Timer to finish loading after 2 seconds
    _loadingTimer = Timer(const Duration(seconds: 3), () {
      widget.onLoadingComplete();
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageRotationTimer.cancel();
    _loadingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Connecting as ${widget.userName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              // Loading images with fade transition
              SizedBox(
                height: 150,
                width: 150,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Image.asset(
                    _loadingImages[_currentImageIndex],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Initializing chat...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}