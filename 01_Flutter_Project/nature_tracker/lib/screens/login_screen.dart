import 'package:flutter/material.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/user_data.dart';
import 'package:nature_tracker/models/user_manager.dart';
import 'package:nature_tracker/screens/main_screen.dart';
import 'package:nature_tracker/screens/register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          builder: (context) =>  MainScreen(true,username), // Navigate to MainScreen
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8.0,
                color: AppColors.color2,
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
                          color: AppColors.color1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(color: AppColors.color5),
                          labelStyle: TextStyle(color: AppColors.color1),
                        ),
                        style: TextStyle(color: AppColors.color1),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: AppColors.color5),
                          labelStyle: TextStyle(color: AppColors.color1),
                        ),
                        style: TextStyle(color: AppColors.color1),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.color1,
                          foregroundColor: AppColors.color5,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
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
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: AppColors.color1),
                          foregroundColor: AppColors.color1,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
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
        ],
      ),
    );
  }
}
