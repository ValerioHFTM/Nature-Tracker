import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nature_tracker/backend/blog_service.dart';

import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/adventure.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:nature_tracker/models/user_data.dart';
import 'package:nature_tracker/models/user_manager.dart';

import 'package:nature_tracker/widgets/floating_action_button_widget.dart';

import 'package:nature_tracker/screens/group_detail_screen.dart';
import 'package:nature_tracker/screens/blog_screen.dart';
import 'package:nature_tracker/screens/login_screen.dart';
import 'package:nature_tracker/screens/user_settings_screen.dart';
import 'package:nature_tracker/screens/settings_screen.dart';

import 'package:uuid/uuid.dart';

class MainScreen extends StatefulWidget {
  MainScreen(this.isLoggedIn, this.userName, {Key? key}) : super(key: key);

  final bool isLoggedIn;
  final String userName;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<MyBlog> _myBlogs = [];
  final List<String> _categories = ['Hike', 'Overnighter', 'Nature', 'Travel'];
  late List<Adventure> _adventures;
  late List<UserData> _users;
  late List<MyBlog> _blogs;
  late bool _isLoggedIn;
  late UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeDataFuture();
  }

  // Method to initialize all data
  void _initializeData() {
    _initializeAdventures();
    _initializeUsers();
    _initializeBlogs();
    _checkLoggedInUser();
  }

  Future<void> _initializeDataFuture() async {
    try {
      final adventuresFuture = getAdventures();
      final usersFuture = getUsers();
      final blogsFuture = getBlogs();

      // Await all futures
      final List<Adventure> adventures = await adventuresFuture;
      final List<UserData> users = await usersFuture;
      final List<MyBlog> blogs = await blogsFuture;

      setState(() {
        _adventures = adventures;
        _users = users;
        _blogs = blogs;
      });
    } catch (error) {
      print('Error initializing data: $error');
    }
  }

  // Initialize Adventures
  void _initializeAdventures() {
    _adventures = getInitializedAdventure();
  }

  // Initialize Users
  void _initializeUsers() {
    _users = getInitializeduser();
  }

  // Initialize Blogs
  void _initializeBlogs() {
    _blogs = getInitializedBlogs();
    _myBlogs.addAll(_blogs);
  }

  // Check if the user is logged in based on the initialized users
  void _checkLoggedInUser() {
    try {
      // Attempt to find the user by username
      _currentUser = _users.firstWhere(
        (user) => user.username == widget.userName,
      );
      _isLoggedIn = true; // User found, so set _isLoggedIn to true
    } catch (e) {
      // If no user is found, handle the case
      _currentUser = null; // Set _currentUser to null
      _isLoggedIn = widget.isLoggedIn; // Use the provided isLoggedIn status
    }
  }

/*
  void _initializeAdventures() {
    _blogs = getInitializedBlogs();
    _adventures = getInitializedAdventure();
    final demoGroup = Adventure(name: 'Demo Adventure ', id: "dummyID");

    final demoMyBlog = MyBlog(
      id: const Uuid().v4(),
      groupName: demoGroup.name,
      category: _categories[2],
      title: 'Exploring the Outdoors',
      content: '''
Exploring the depths of the forest, we encountered a myriad of fascinating wildlife. The trees, towering above, created a natural canopy that filtered the sunlight into gentle beams.

After hours of hiking, we reached a serene clearing.

**The view was breathtaking.**

The sounds of nature surrounded us, a symphony of chirping birds and rustling leaves.

We took a moment to catch our breath.

As we continued our journey, we came across a small stream, its water clear and cool to the touch.

**It was the perfect spot to rest.**

With renewed energy, we pressed on, our footsteps steady and our spirits high.

The trail ahead promised more discoveries, and we were eager to see what lay beyond the next bend.
  ''',
      steps: 7500,
      altitude: 1500,
      distance: 5000,
      liked: false,
    );
    saveBlog(demoMyBlog); // Ill only do this once, then i can delete it from here and get it via the backend

    demoGroup.myBlogs.add(demoMyBlog);

    setState(() {
      //_adventures.add(demoGroup);
      _myBlogs.add(demoMyBlog);
    });
  }
*/
  void _logout() {
    setState(() {
      _isLoggedIn = false; // Update login state
    });
  }

  void _goToBlog(MyBlog blog) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BlogScreen(blog: blog)),
    );
  }

  void _goToAdventureBlog(MyBlog blog, Adventure group) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => GroupDetailScreen(group: group, blog: blog)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

/* Main Build Method For The Main Screen
 *
 *
 *
 *
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      drawer: _buildDrawer(context),
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
                iconTheme: const IconThemeData(color: AppColors.color3),
                title: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/Logo_Black_NatureTracker_Long.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: _selectedIndex == 0
                    ? _buildOverview()
                    : _buildAdventure(context),
              ),
              //if (_isLoggedIn)
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
                    icon: Icon(Icons.hiking_rounded),
                    label: 'Adventures',
                  ),
                ],
                backgroundColor: AppColors.color3,
                selectedItemColor: AppColors.color1,
                unselectedItemColor: AppColors.color4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.color4,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150.0,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.color1,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/Logo_Black_NatureTracker_Double.png', // Path to the name image
                  height: 200.0, // Adjust as needed
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.color3,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading:
                        const Icon(Icons.favorite, color: AppColors.color4),
                    title: const Text('Favorites',
                        style: TextStyle(color: AppColors.color1)),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Add action for Favorites
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: AppColors.color4),
                    title: const Text('Profile Settings',
                        style: TextStyle(color: AppColors.color1)),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      if (_isLoggedIn) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                UserSettingsScreen(user: _currentUser),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.settings, color: AppColors.color4),
                    title: const Text('Settings',
                        style: TextStyle(color: AppColors.color1)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  if (_isLoggedIn)
                    ListTile(
                      leading:
                          const Icon(Icons.logout, color: AppColors.color4),
                      title: const Text('Logout',
                          style: TextStyle(color: AppColors.color1)),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the drawer
                        setState(() {
                          _isLoggedIn = false; // Update login state
                        });
                        // Navigate to LoginScreen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    )
                  else
                    ListTile(
                      leading: const Icon(Icons.login, color: AppColors.color4),
                      title: const Text('Login',
                          style: TextStyle(color: AppColors.color1)),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the drawer
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
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

        final truncatedGroupName = blog.groupName.length > 15
            ? blog.groupName.substring(0, 15)
            : blog.groupName;

        return GestureDetector(
          onTap: () => _goToBlog(blog),
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
                          color: AppColors.color3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        truncatedGroupName,
                        style: const TextStyle(
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
                      style: const TextStyle(
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
                      blog.liked ? Icons.favorite : Icons.favorite_border,
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
    );
  }

  void _showAddBlogDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String selectedCategory = _categories.first;
    String selectedGroup = ''; // Default empty string for the initial selection

    // Use the already initialized _adventures directly
    if (_adventures.isNotEmpty) {
      selectedGroup = _adventures.first.name;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.color3,
          title: const Text(
            'Add Blog',
            style: TextStyle(color: AppColors.color1),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Blog Title',
                  hintStyle: TextStyle(color: AppColors.color1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                ),
                style: const TextStyle(color: AppColors.color1),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Blog Content',
                  hintStyle: TextStyle(color: AppColors.color1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                ),
                style: const TextStyle(color: AppColors.color1),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: _categories
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(color: AppColors.color1),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                ),
                dropdownColor: AppColors.color3,
                isExpanded: true,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGroup,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedGroup = newValue;
                    });
                  }
                },
                items: _adventures
                    .map<DropdownMenuItem<String>>((Adventure adventure) {
                  return DropdownMenuItem<String>(
                    value: adventure.name,
                    child: Text(
                      adventure.name,
                      style: const TextStyle(color: AppColors.color1),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                ),
                dropdownColor: AppColors.color3,
                isExpanded: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.color1),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newBlog = MyBlog(
                  id: const Uuid().v4(),
                  groupName: selectedGroup,
                  category: selectedCategory,
                  title: titleController.text,
                  content: contentController.text,
                  steps: 0,
                  altitude: 0,
                  distance: 0,
                  liked: false,
                );

                try {
                  await saveBlog(newBlog); // Ensure blog is saved
                  setState(() {
                    _myBlogs.add(newBlog);
                    // Optionally, update _adventures or other state if necessary
                  });

                  Navigator.of(context).pop();
                } catch (error) {
                  // Handle error if saveBlog fails
                  print('Error saving blog: $error');
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: AppColors.color1),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddGroupDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.color3,
          title: const Text(
            'Add Adventure',
            style: TextStyle(color: AppColors.color1),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Adventure Name',
              hintStyle: TextStyle(color: AppColors.color1),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.color1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.color1),
              ),
            ),
            style: const TextStyle(color: AppColors.color1),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.color1),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newAdventure = Adventure(
                  name: nameController.text,
                  id: "temporaryID", // Ideally, this should be generated by the backend
                );

                // Save the new adventure and wait for it to complete
                await saveAdventure(newAdventure);

                // Fetch and refresh the adventure list
                setState(() {
                  _adventures =
                      getInitializedAdventure(); // Refresh the adventure list
                });

                Navigator.of(context).pop();
              },
              child: const Text(
                'Add',
                style: TextStyle(color: AppColors.color1),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdventure(BuildContext context) {
    // Check if _adventures is empty and show a message if it is
    if (_adventures.isEmpty) {
      return Center(child: Text('No adventures found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _adventures.length,
      itemBuilder: (context, index) {
        final adventure = _adventures[index];

        return GestureDetector(
          onTap: () {
            // Your navigation code
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10.0),
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
            child: Text(
              adventure.name,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.color5,
              ),
            ),
          ),
        );
      },
    );
  }
}
