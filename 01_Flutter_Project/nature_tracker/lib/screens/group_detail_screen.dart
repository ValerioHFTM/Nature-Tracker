import 'package:flutter/material.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/adventure.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key, required this.group});

  final Adventure group;

  @override
  GroupDetailScreenState createState() => GroupDetailScreenState();
}

class GroupDetailScreenState extends State<GroupDetailScreen> {
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
                  icon: Icon(Icons.arrow_back, color: AppColors.color1),
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
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: widget.group.myBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = widget.group.myBlogs[index];
                    final truncatedGroupName = blog.groupName.length > 15
                        ? blog.groupName.substring(0, 15) + '...'
                        : blog.groupName;

                    return GestureDetector(
                      onTap: () {
                        // Handle tap action
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.color1,
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
                        //Single Block
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
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: AppColors.color3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    truncatedGroupName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.color3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4.0),
                                child: Text(
                                  blog.category,
                                  style: TextStyle(
                                    color: AppColors.color5,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: IconButton(
                                icon: Icon(
                                  blog.liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.color3,
                                ),
                                onPressed: () {
                                  setState(() {
                                    blog.liked = !blog.liked;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: AppColors.color3,
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    widget.group.name,
                    style: TextStyle(
                      color: AppColors.color5,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
