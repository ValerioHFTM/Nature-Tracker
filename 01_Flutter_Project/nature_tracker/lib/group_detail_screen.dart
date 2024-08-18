import 'package:flutter/material.dart';
import 'package:smart_trash/main_screen.dart';
import 'package:smart_trash/models/app_colors.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;

  GroupDetailScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make background color transparent
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background-06.png', // Update with your background image path
              fit: BoxFit.cover, // Ensure the image covers the entire screen
            ),
          ),
          // Main content
          Column(
            children: [
              AppBar(
                backgroundColor:
                    AppColors.color3, // Use color3 for the AppBar background
                elevation: 6.0, // Light shadow
                centerTitle: true, // Center the title widget
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: AppColors.color1), // Yellow return button
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Navigate back to the previous screen
                  },
                ),
                title: SizedBox(
                  height:
                      40, // Adjust this value to make the logo smaller or larger
                  child: Image.asset(
                    'assets/images/header.png', // Update with your PNG logo path
                    fit: BoxFit.contain, // Ensure the logo scales correctly
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: group.trashBins.length,
                  itemBuilder: (context, index) {
                    final bin = group.trashBins[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle toggle status or other actions here
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bin.isFull
                              ? AppColors.redColor
                              : AppColors
                                  .greenColor, // Use defined colors for full/empty
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bin.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors
                                      .white), // Keep white text for contrast
                            ),
                            SizedBox(height: 10),
                            Text(
                              bin.isFull ? 'Full' : 'Empty',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors
                                      .white), // Keep white text for contrast
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom bar with group name
              Container(
                color: AppColors
                    .color3, // Use color3 for the bottom bar background
                padding:
                    EdgeInsets.all(10.0), // Add some padding around the text
                child: Center(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      color: AppColors.color5, // Use color5 for the text
                      fontSize: 18, // Adjust font size as needed
                      fontWeight: FontWeight.bold, // Bold text for emphasis
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
