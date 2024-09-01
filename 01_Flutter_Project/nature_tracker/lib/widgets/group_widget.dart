import 'package:flutter/material.dart';
import 'package:nature_tracker/models/group.dart';
import 'package:nature_tracker/models/app_colors.dart';

class GroupWidget extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupWidget({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = AppColors.greenColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(
          group.name,
          style: const TextStyle(
            fontSize: 22,
            color: AppColors.color2,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.color2,
        ),
        onTap: onTap,
      ),
    );
  }
}
