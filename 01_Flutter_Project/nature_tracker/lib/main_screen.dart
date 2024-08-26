import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs
import 'package:nature_tracker/group_detail_screen.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/widgets/floating_action_button_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<MyBlog> _myBlogs = [];
  final List<String> _categories = ['PET', 'ALU', 'MISC', 'Compost'];
  final List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _initializeGroups();
  }

  void _initializeGroups() {
    final demoGroup = Group(name: 'Demo Group ');

    final demoMyBlog = MyBlog(
      name: 'Demo Blog',
      id: const Uuid().v4(),
      groupName: demoGroup.name,
      category: 'MISC', // Set a default category
    );

    demoGroup.myBlogs.add(demoMyBlog);

    setState(() {
      _groups.add(demoGroup);
      _myBlogs.add(demoMyBlog);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleBlogStatus(MyBlog blog) {
    setState(() {
      blog.isFull = !blog.isFull;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make background color transparent
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background-06.png',
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
                child: _selectedIndex == 0
                    ? _buildOverview()
                    : _buildNetwork(context),
              ),
              //use of the floating_action_button_widget.dart
              FloatingActionButtonWidget(
                selectedIndex: _selectedIndex,
                showAddBlogDialog: _showAddBlogDialog,
                showAddGroupDialog: _showAddGroupDialog,
              ),
              BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Overview',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.network_check),
                    label: 'Network',
                  ),
                ],
                backgroundColor:
                    AppColors.color3, // Use color3 for the BottomNavigationBar
                selectedItemColor:
                    AppColors.color1, // Use color1 for selected item text
                unselectedItemColor:
                    AppColors.color4, // Use color4 for unselected item text
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _myBlogs.length,
      itemBuilder: (context, index) {
        final blog = _myBlogs[index];
        final truncatedGroupName = blog.groupName.length > 12
            ? '${blog.groupName.substring(0, 12)}...'
            : blog.groupName;

        return GestureDetector(
          onTap: () => _toggleBlogStatus(blog),
          onLongPress: () =>
              _showEditBlogDialog(blog), // Long press for editing
          child: Container(
            decoration: BoxDecoration(
              color: blog.isFull ? AppColors.redColor : AppColors.greenColor,
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
                        blog.name,
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.color5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        blog.isFull ? 'Full' : 'Empty',
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 4.0),
                    child: Text(
                      blog.category,
                      style: const TextStyle(
                        color: AppColors.color5,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
      },
    );
  }

  void _deleteBlog(MyBlog blog) {
    setState(() {
      _myBlogs.removeWhere((b) => b.id == blog.id);
      _groups
          .firstWhere((group) => group.name == blog.groupName)
          .myBlogs
          .remove(blog);
    });
  }

  void _showEditBlogDialog(MyBlog blog) {
    TextEditingController nameController =
        TextEditingController(text: blog.name);
    String updatedCategory = blog.category;
    String updatedGroup = blog.groupName;

    final focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor:
                  AppColors.color3, // Background color set to color3
              title: const Text(
                'Edit Blog',
                style: TextStyle(
                    color: AppColors.color1), // Title color set to color1
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    cursorColor: AppColors.color1, // Set cursor color
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Blog Name',
                      labelStyle:
                          TextStyle(color: AppColors.color1), // Label color
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.color1), // Line color
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.color1), // Focused line color
                      ),
                      // Remove the border that shows when focused
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style:
                        const TextStyle(color: AppColors.color4), // Text color
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: updatedCategory,
                    onChanged: (value) {
                      setState(() {
                        updatedCategory = value!;
                      });
                    },
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(
                              color:
                                  AppColors.color4), // Dropdown item text color
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle:
                          TextStyle(color: AppColors.color1), // Label color
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.color1), // Line color
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.color1), // Focused line color
                      ),
                    ),
                    dropdownColor:
                        AppColors.color3, // Dropdown background color
                    iconEnabledColor: AppColors.color1, // Dropdown arrow color
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: updatedGroup,
                    onChanged: (value) {
                      setState(() {
                        updatedGroup = value!;
                      });
                    },
                    items: _groups.map((group) {
                      return DropdownMenuItem(
                        value: group.name,
                        child: Text(
                          group.name,
                          style: const TextStyle(
                              color:
                                  AppColors.color4), // Dropdown item text color
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Group',
                      labelStyle:
                          TextStyle(color: AppColors.color1), // Label color
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.color1), // Line color
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.color1), // Focused line color
                      ),
                    ),
                    dropdownColor:
                        AppColors.color3, // Dropdown background color
                    iconEnabledColor: AppColors.color1, // Dropdown arrow color
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: AppColors.color2), // Cancel button text color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      blog.name = nameController.text;
                      blog.category = updatedCategory;
                      blog.groupName = updatedGroup;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.greenColor, // Save button background color
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: AppColors.color2), // Save button text color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteBlog(blog);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Delete button background color
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        color: AppColors.color2), // Delete button text color
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNetwork(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: _groups.length,
            itemBuilder: (context, index) {
              final group = _groups[index];
              final bool hasFullBlog = group.isAnyBlogFull();
              final Color backgroundColor =
                  hasFullBlog ? AppColors.redColor : AppColors.greenColor;

              return Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 5.0), // Space between items
                decoration: BoxDecoration(
                  color: backgroundColor, // Apply the background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Padding inside the tile
                  title: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 22,
                      color: AppColors.color2,
                    ), // Use color2 for group text
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.color2,
                  ), // Use color2 for trailing icon
                  onTap: () => _navigateToGroupDetails(context, group),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToGroupDetails(BuildContext context, Group group) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(group: group),
      ),
    );
  }

  void _showAddGroupDialog() {
    String groupName = '';
    final focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.color3, // Set background color to color3
          title: const Text(
            'Add New Group',
            style: TextStyle(
              color: AppColors.color1, // Set title color to color1
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: AppColors.color1, // Set cursor color to color1
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  labelStyle: TextStyle(
                    color: AppColors.color1, // Set label color to color1
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.color1, // Set line color to color1
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 247, 240, 186), // Set focused line color
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: AppColors.color4, // Set input text color to color4
                ),
                onChanged: (value) {
                  groupName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors
                      .color2, // Set cancel button text color to color2
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (groupName.isNotEmpty) {
                  final newGroup = Group(name: groupName);
                  setState(() {
                    _groups.add(newGroup);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color:
                      AppColors.color1, // Set add button text color to color1
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddBlogDialog() {
    String blogName = '';
    String selectedGroup = _groups.isNotEmpty ? _groups[0].name : '';
    String selectedCategory = 'MISC'; // Default category

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.color3, // Background color set to color3
          title: const Text(
            'Add New Blog',
            style: TextStyle(
              color: AppColors.color1, // Title color set to color1
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: AppColors.color1, // Set cursor color to color1
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: AppColors.color1, // Label color set to color1
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.color1), // Line color set to color1
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .color1), // Line color when focused set to color1
                  ),
                ),
                style: const TextStyle(
                  color: AppColors.color4, // Input text color set to color4
                ),
                onChanged: (value) {
                  blogName = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Group',
                  labelStyle: TextStyle(
                    color: AppColors.color1, // Label color set to color1
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.color1), // Line color set to color1
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .color1), // Line color when focused set to color1
                  ),
                ),
                dropdownColor:
                    AppColors.color2, // Dropdown background color set to color3
                value: selectedGroup,
                items: _groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group.name,
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        color: AppColors
                            .color4, // Dropdown item text color set to color4
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedGroup = value ?? '';
                },
                iconEnabledColor: AppColors.color1, // Arrow color set to color1
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(
                    color: AppColors.color1, // Label color set to color1
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.color1), // Line color set to color1
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .color1), // Line color when focused set to color1
                  ),
                ),
                dropdownColor:
                    AppColors.color3, // Dropdown background color set to color3
                value: selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: AppColors
                            .color4, // Dropdown item text color set to color4
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value ?? 'MISC';
                },
                iconEnabledColor: AppColors.color1, // Arrow color set to color1
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors
                      .color2, // Cancel button text color set to color2
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (blogName.isNotEmpty && selectedGroup.isNotEmpty) {
                  final newBlog = MyBlog(
                    name: blogName,
                    id: const Uuid().v4(),
                    groupName: selectedGroup,
                    category: selectedCategory,
                  );

                  setState(() {
                    _myBlogs.add(newBlog);
                    _groups
                        .firstWhere((group) => group.name == selectedGroup)
                        .myBlogs
                        .add(newBlog);
                  });

                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color:
                      AppColors.color1, // Add button text color set to color1
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyBlog {
  final String id;
  String name;
  String groupName;
  String category; // Add this field
  bool isFull;

  MyBlog({
    required this.id,
    required this.name,
    required this.groupName,
    required this.category, // Update constructor
    this.isFull = false,
  });
}

class Group {
  final String name;
  final List<MyBlog> myBlogs;

  Group({required this.name}) : myBlogs = [];

  bool isAnyBlogFull() {
    return myBlogs.any((blog) => blog.isFull);
  }
}
