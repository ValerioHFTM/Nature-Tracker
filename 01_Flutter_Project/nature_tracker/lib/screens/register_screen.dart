import 'package:flutter/material.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/user_data.dart';
import 'package:nature_tracker/models/user_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _register() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      final newUser = UserData(
        username: username,
        email: email,
        firstname: "Firstname",
        lastname: "Lastname",
        gender: Gender.others,
        age: DateTime(2000, 1, 1),
        description: "Description goes here",
        imageUrls: [],
        password: password,
      );

      UserManager.instance.addUser(newUser);
      Navigator.of(context).pop();
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
                Color.fromARGB(24, 116, 142, 85),
                BlendMode.srcIn,
              ),
              child: Image.asset(
                'assets/images/Icon_White.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Card(
                          elevation: 8.0,
                          color: AppColors.color1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 40),
                                  const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.color3,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Username',
                                      hintText: 'Enter your username',
                                      hintStyle:
                                          TextStyle(color: AppColors.color2),
                                      labelStyle:
                                          TextStyle(color: AppColors.color3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color3),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        color: AppColors.color3),
                                    validator: (value) {
                                      final validCharacters =
                                          RegExp(r'^[a-zA-Z0-9]+$');
                                      if (value == null || value.isEmpty) {
                                        return 'Username cannot be empty';
                                      } else if (value.length > 10) {
                                        return 'Username must be 10 characters or less';
                                      } else if (!validCharacters
                                          .hasMatch(value)) {
                                        return 'Username can only contain letters and numbers';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'Enter your email',
                                      hintStyle:
                                          TextStyle(color: AppColors.color2),
                                      labelStyle:
                                          TextStyle(color: AppColors.color3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color3),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        color: AppColors.color3),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email cannot be empty';
                                      } else if (!RegExp(
                                              r'^[^@]+@[^@]+\.[^@]+$')
                                          .hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Enter your password',
                                      hintStyle:
                                          TextStyle(color: AppColors.color2),
                                      labelStyle:
                                          TextStyle(color: AppColors.color3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color3),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        color: AppColors.color3),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password cannot be empty';
                                      } else if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Confirm Password',
                                      hintText: 'Confirm your password',
                                      hintStyle:
                                          TextStyle(color: AppColors.color2),
                                      labelStyle:
                                          TextStyle(color: AppColors.color3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.color3),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        color: AppColors.color3),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (value !=
                                          _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  ElevatedButton(
                                    onPressed: _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.color1,
                                      foregroundColor: AppColors.color5,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      side: const BorderSide(
                                          color: AppColors.color1),
                                      foregroundColor: AppColors.color1,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      "Back to Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
