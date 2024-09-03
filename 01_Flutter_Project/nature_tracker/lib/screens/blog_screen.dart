import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key, required this.blog});
  final MyBlog blog;

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  bool _isMenuOpen = false;
  late bool _isCountingSteps;
  bool _isEditing = false;
  int _steps = 0;
  List<String> _imageUrls = [];
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();
  StreamSubscription<StepCount>? _stepCountSubscription;
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog.title);
    _categoryController = TextEditingController(text: widget.blog.category);
    String content = widget.blog.content.isNotEmpty == true
        ? widget.blog.content
        : "No Content";
    _contentController = TextEditingController(text: content);

    _isCountingSteps = widget.blog.isCounting;

    if (_isCountingSteps) {
      _startCountingSteps();
    }
  }

  @override
  void dispose() {
    _stopCountingSteps();
    _titleController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Future<void> _requestLocationPermissions() async {
    final permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required.'),
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
      widget.blog.isCounting = _isCountingSteps;
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
          print('Error in step count stream: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error accessing step count data.'),
            ),
          );
        },
        onDone: () {
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
    if (_stepCountSubscription != null) {
      _stepCountSubscription!.cancel();
      _stepCountSubscription = null; // Ensure subscription is reset
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        widget.blog.title = _titleController.text;
        widget.blog.category = _categoryController.text;
        widget.blog.content = _contentController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved!'),
          ),
        );
      }
    });
  }

  // Function to show the enlarged image in a dialog
  void _showImageDialog(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.color2, // Set the background color
          child: Stack(
            children: [
              Center(
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.95,
                ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled.'),
        ),
      );
      return;
    }

    await _requestLocationPermissions(); // Ensure permissions are requested
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });
  }

  void _showMapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.color2, // Set the background color
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.9,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      builder: (ctx) => Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
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

  @override
  Widget build(BuildContext context) {
    List<String> _splitContent(String content, int maxSentences) {
      final sentences = content.split(RegExp(r'(?<=[.!?])\s+'));
      final chunks = <String>[];
      for (var i = 0; i < sentences.length; i += maxSentences) {
        final chunk = sentences
            .sublist(
                i,
                i + maxSentences > sentences.length
                    ? sentences.length
                    : i + maxSentences)
            .join(' ');
        chunks.add(chunk);
      }
      return chunks;
    }

    final contentChunks = _splitContent(widget.blog.content, 4);
    final firstImage = _imageUrls.isNotEmpty ? File(_imageUrls.first) : null;
    final lastImage = _imageUrls.length > 1 ? File(_imageUrls.last) : null;
    final middleImages = _imageUrls.length > 2
        ? _imageUrls.sublist(1, _imageUrls.length - 1)
        : [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(24, 116, 142, 85), // Desired color
                BlendMode.srcIn, // Blend mode to apply color
              ),
              child: Image.asset(
                'assets/images/Icon_White.png',
                fit: BoxFit.cover,
              ),
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
                    'assets/images/Logo_Black_NatureTracker_Long.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 200.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.color1,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isEditing)
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            )
                          else
                            Text(
                              widget.blog.title,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[700],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a category';
                                }
                                return null;
                              },
                            )
                          else
                            Text(
                              'Category: ${widget.blog.category}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (firstImage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Image.file(
                                firstImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          for (int i = 0; i < contentChunks.length; i++) ...[
                            Text(
                              contentChunks[i],
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (i == 0 && middleImages.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: middleImages.length,
                                    itemBuilder: (context, index) {
                                      final imageFile =
                                          File(middleImages[index]);
                                      return GestureDetector(
                                        onTap: () => _showImageDialog(
                                            context, imageFile),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Image.file(
                                            imageFile,
                                            fit: BoxFit.cover,
                                            width: 200,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            if (i < contentChunks.length - 1)
                              const SizedBox(height: 10),
                          ],
                          if (lastImage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Image.file(
                                lastImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
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

                          // Place the FlutterMap here
                          if (_currentPosition != null)
                            Container(
                              height: 200, // Fixed height for the map
                              width: double.infinity,
                              child: FlutterMap(
                                options: MapOptions(
                                  center: LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude),
                                  zoom: 15.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    subdomains: ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: LatLng(
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude),
                                        builder: (ctx) => Container(
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 40.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                      color: AppColors.color1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Buttons for editing
          Positioned(
            bottom: _isMenuOpen && _currentPosition != null ? 0 : 60.0,
            right: 15.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isMenuOpen) ...[
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    backgroundColor: AppColors.color4,
                    onPressed: _pickImage,
                    child: const Icon(Icons.camera_alt),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    backgroundColor: _isCountingSteps
                        ? AppColors.greenColor
                        : AppColors.redColor,
                    onPressed: _toggleStepCounter,
                    child: const Icon(Icons.directions_walk),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    backgroundColor: _currentPosition == null
                        ? AppColors.redColor
                        : AppColors.greenColor,
                    child: const Icon(Icons.location_on),
                    onPressed: () {
                      if (_currentPosition == null) {
                        _getLocation();
                      } else {
                        _showMapDialog(context);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isMenuOpen) ...[
                      FloatingActionButton(
                        backgroundColor: AppColors.color4,
                        onPressed: _toggleEditing,
                        child: Icon(
                          _isEditing ? Icons.save : Icons.edit,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    FloatingActionButton(
                      backgroundColor: AppColors.color4,
                      onPressed: _toggleMenu,
                      child: Icon(_isMenuOpen ? Icons.close : Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
