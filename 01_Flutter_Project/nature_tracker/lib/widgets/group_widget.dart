import 'package:flutter/material.dart';
import 'package:smart_trash/models/group.dart';
import 'package:smart_trash/models/app_colors.dart';

class GroupWidget extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  GroupWidget({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasFullBin = group.isAnyBinFull();
    final Color backgroundColor =
        hasFullBin ? AppColors.redColor : AppColors.greenColor;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(
          group.name,
          style: TextStyle(
            fontSize: 22,
            color: AppColors.color2,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.color2,
        ),
        onTap: onTap,
      ),
    );
  }
}
