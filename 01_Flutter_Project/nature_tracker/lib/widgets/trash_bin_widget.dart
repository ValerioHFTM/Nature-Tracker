/*import 'package:flutter/material.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:nature_tracker/models/app_colors.dart';

class BlogWidget extends StatelessWidget {
  final MyBlog blog;
  final VoidCallback onTap;

  const BlogWidget({super.key, required this.blog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final truncatedGroupName = blog.groupName.length > 12
        ? '${blog.groupName.substring(0, 12)}...'
        : blog.groupName;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greenColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.color3.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.color5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'here is the content',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.color5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: _getCategoryIcon(blog.category),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  truncatedGroupName,
                  style: const TextStyle(
                    color: AppColors.color5,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'PET':
        return const Icon(Icons.local_drink, color: Colors.blue, size: 30);
      case 'ALU':
        return const Icon(Icons.category, color: Colors.grey, size: 30);
      case 'MISC':
        return const Icon(Icons.miscellaneous_services,
            color: Colors.orange, size: 30);
      case 'Compost':
        return const Icon(Icons.nature, color: Colors.green, size: 30);
      default:
        return const Icon(Icons.help, color: Colors.red, size: 30);
    }
  }
}

*/