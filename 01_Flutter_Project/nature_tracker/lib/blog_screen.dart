import 'dart:async';
import 'dart:io'; // Import to handle File

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key, required this.blog});
  final MyBlog blog;

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  bool _isMenuOpen = false;
  bool _isCountingSteps = false;
  int _steps = 0;
  List<String> _imageUrls = [];

  final ImagePicker _picker = ImagePicker();
  late StreamSubscription<StepCount> _stepCountSubscription;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      // Handle permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activity recognition permission is required.'),
        ),
      );
    }
  }

  void _toggleStepCounter() {
    setState(() {
      _isCountingSteps = !_isCountingSteps;
      if (_isCountingSteps) {
        _requestPermissions().then((_) => _startCountingSteps());
      } else {
        _stopCountingSteps();
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageUrls.add(pickedFile.path);
      });
    }
  }

  void _startCountingSteps() {
    try {
      final pedometerStream = Pedometer.stepCountStream;
      _stepCountSubscription = pedometerStream.listen(
        (StepCount event) {
          setState(() {
            _steps = event.steps;
          });
        },
        onError: (error) {
          // Handle any errors from the stream
          print('Error in step count stream: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error accessing step count data.'),
            ),
          );
        },
        onDone: () {
          // Handle stream completion
          print('Step count stream closed');
        },
      );
    } catch (e) {
      print('Exception caught: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to start step count tracking.'),
        ),
      );
    }
  }

  void _stopCountingSteps() {
    _stepCountSubscription.cancel();
  }

  @override
  void dispose() {
    _stepCountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background-06.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: AppColors.color3,
                elevation: 6.0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.color1),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/header.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.blog.title,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Category: ${widget.blog.category}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.blog.content,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_imageUrls.isNotEmpty)
                            ..._imageUrls.map((url) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Image.file(
                                    File(url),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          const SizedBox(height: 10),
                          Text(
                            'Steps: $_steps',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Altitude: ${widget.blog.altitude} meters',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Distance: ${widget.blog.distance} meters',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Field: ${widget.blog.liked}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColors.color3,
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    widget.blog.title,
                    style: const TextStyle(
                      color: AppColors.color5,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isMenuOpen) ...[
                  FloatingActionButton(
                    backgroundColor: AppColors.color1,
                    child: const Icon(Icons.camera_alt),
                    onPressed: _pickImage,
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: _isCountingSteps
                        ? AppColors.greenColor
                        : AppColors.redColor,
                    child: const Icon(Icons.directions_walk),
                    onPressed: _toggleStepCounter,
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: AppColors.color1,
                    child: const Icon(Icons.location_on),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add Location button pressed!'),
                        ),
                      );
                    },
                  ),
                ],
                FloatingActionButton(
                  backgroundColor: AppColors.color1,
                  child: Icon(_isMenuOpen ? Icons.close : Icons.add),
                  onPressed: _toggleMenu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
