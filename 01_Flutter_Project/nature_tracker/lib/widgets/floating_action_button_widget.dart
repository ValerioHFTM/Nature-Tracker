import 'package:flutter/material.dart';
import 'package:nature_tracker/models/app_colors.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback showAddBlogDialog;
  final VoidCallback showAddGroupDialog;

  const FloatingActionButtonWidget({
    Key? key,
    required this.selectedIndex,
    required this.showAddBlogDialog,
    required this.showAddGroupDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Adjust padding for bottom
      child: SizedBox(
        width: 240, // Fixed width for uniform button size
        child: ElevatedButton.icon(
          onPressed:
              selectedIndex == 0 ? showAddBlogDialog : showAddGroupDialog,
          icon: const Icon(
            Icons.add,
            color: AppColors.color4, // Set icon color to color1
          ),
          label: Text(
            selectedIndex == 0 ? "Add New Blog" : "Add New Adventure",
            textAlign: TextAlign.left, // Align text to the left
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.color1, // Set text color to color5
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.color3, // Use color3 for the button background
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );
  }
}
