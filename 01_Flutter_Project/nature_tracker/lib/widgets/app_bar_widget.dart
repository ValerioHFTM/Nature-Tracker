import 'package:flutter/material.dart';
import 'package:nature_tracker/models/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body; // This will be the content that differs between screens
  final bool showDrawer;
  final bool showBackButton;

  const CustomScaffold({
    super.key,
    required this.body,
    this.showDrawer = false,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      drawer: showDrawer
          ? _buildDrawer(context)
          : null, // Conditionally show the drawer
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
                backgroundColor: AppColors.color1,
                elevation: 6.0,
                centerTitle: true,
                leading: showBackButton
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.color3),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : null, // Show back button if required
                iconTheme: const IconThemeData(color: AppColors.color3),
                title: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/Logo_Black_NatureTracker_Long.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(child: body), // Display the custom content
            ],
          ),
        ],
      ),
    );
  }

  // Placeholder method to build a drawer if required
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.color1,
            ),
            child: const Text(
              'Drawer Header',
              style: TextStyle(
                color: AppColors.color3,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigate to home
            },
          ),
          // Add more drawer items here
        ],
      ),
    );
  }
}
