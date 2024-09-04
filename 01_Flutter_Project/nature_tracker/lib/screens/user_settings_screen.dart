import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nature_tracker/backend/blog_service.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/user_data.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key, required this.user});

  final UserData? user;

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _usernameController;
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  late DateTime _age;
  late Gender _gender;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username);
    _firstnameController = TextEditingController(text: widget.user?.firstname);
    _lastnameController = TextEditingController(text: widget.user?.lastname);
    _emailController = TextEditingController(text: widget.user?.email);
    _descriptionController =
        TextEditingController(text: widget.user?.description);
    _age = widget.user!.age;
    _gender = widget.user?.gender as Gender;
    _imageUrls = List.from(widget.user!.imageUrls);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditing() async {
    setState(() {
      _isEditing = !_isEditing;

      if (!_isEditing) {
        final user = widget.user;

        if (user != null) {
          // Update the user details
          user.username = _usernameController.text;
          user.firstname = _firstnameController.text;
          user.lastname = _lastnameController.text;
          user.email = _emailController.text;
          user.description = _descriptionController.text;
          user.age = _age;
          user.gender = _gender as Gender;
          user.imageUrls = _imageUrls;

          // Show a SnackBar indicating that the changes are being saved
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saving changes...'),
            ),
          );

          // Call the updateUser function to save changes to the backend
          updateUser(user);
        }
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrls.add(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _age,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _age) {
      setState(() {
        _age = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          if (_imageUrls.isNotEmpty)
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(
                                  File(_imageUrls.first),
                                ),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _pickImage,
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'assets/images/default_avatar.png'),
                              ),
                            ),
                          const SizedBox(height: 20),
                          if (_isEditing)
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                            )
                          else
                            Text(
                              'Username: ${widget.user?.username}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            TextFormField(
                              controller: _firstnameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                              ),
                            )
                          else
                            Text(
                              'First Name: ${widget.user?.firstname}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            TextFormField(
                              controller: _lastnameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                              ),
                            )
                          else
                            Text(
                              'Last Name: ${widget.user?.lastname}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            )
                          else
                            Text(
                              'Email: ${widget.user?.email}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            DropdownButtonFormField<Gender>(
                              value: _gender,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(),
                              ),
                              items: Gender.values.map((Gender gender) {
                                return DropdownMenuItem<Gender>(
                                  value: gender,
                                  child: Text(
                                    gender.toString().split('.').last,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Gender? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _gender = newValue;
                                  });
                                }
                              },
                            )
                          else
                            Text(
                              'Gender: ${widget.user?.gender.toString().split('.').last}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_age.toLocal()}'.split(' ')[0],
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                            )
                          else
                            Text(
                              'Date of Birth: ${widget.user?.age.toLocal()}'
                                  .split(' ')[0],
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 4,
                            )
                          else
                            Text(
                              'Description: ${widget.user?.description}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          const SizedBox(height: 20),
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
                    widget.user!.username,
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
            bottom: 60.0,
            right: 15.0,
            child: FloatingActionButton(
              onPressed: _toggleEditing,
              child: Icon(_isEditing ? Icons.save : Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
