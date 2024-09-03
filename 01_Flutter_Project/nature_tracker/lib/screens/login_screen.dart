import 'package:flutter/material.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/user_manager.dart';
import 'package:nature_tracker/screens/forgot_pw.dart';
import 'package:nature_tracker/screens/main_screen.dart';
import 'package:nature_tracker/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Validate credentials using the UserManager singleton
    if (UserManager.instance.validateCredentials(username, password)) {
      // Login successful, proceed to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              MainScreen(true, username), // Navigate to MainScreen
        ),
      );
    } else {
      // Login failed, clear the password and show an error message
      setState(() {
        _passwordController.clear();
        _errorMessage = 'Wrong username or password. Please try again.';
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 80.0, horizontal: 8.0),
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.color3,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Form containing both the Username and Password fields
                                      Form(
                                        key:
                                            _formKey, // Create a GlobalKey<FormState> _formKey to reference the form
                                        child: Column(
                                          children: [
                                            // Username Field
                                            TextFormField(
                                              controller: _usernameController,
                                              decoration: const InputDecoration(
                                                labelText: 'Username',
                                                hintText: 'Enter your username',
                                                hintStyle: TextStyle(
                                                    color: AppColors.color2),
                                                labelStyle: TextStyle(
                                                    color: AppColors.color3),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .color2), // Border color when not focused
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .color3), // Border color when focused
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .red), // Border color when there's an error
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .red), // Border color when focused and there's an error
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: AppColors.color3),
                                              validator: (value) {
                                                final validCharacters =
                                                    RegExp(r'^[a-zA-Z0-9]+$');
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                            // Password Field
                                            TextFormField(
                                              controller: _passwordController,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                labelText: 'Password',
                                                hintText: 'Enter your password',
                                                hintStyle: TextStyle(
                                                    color: AppColors.color2),
                                                labelStyle: TextStyle(
                                                    color: AppColors.color3),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .color2), // Border color when not focused
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .color3), // Border color when focused
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .red), // Border color when there's an error
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .red), // Border color when focused and there's an error
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: AppColors.color3),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Password cannot be empty';
                                                } else if (value.length < 6) {
                                                  return 'Password must be at least 6 characters long';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForgotPWScreen(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                color: AppColors.color3,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_errorMessage != null) ...[
                                        const SizedBox(height: 10),
                                        Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                              color: AppColors.color3),
                                        ),
                                      ],
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _login();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.color1,
                                          foregroundColor: AppColors.color3,
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                              color: AppColors
                                                  .color2, // Border color
                                              width: 1.0, // Border width
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.color3,
                                          foregroundColor: AppColors.color4,
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
                                    ],
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
