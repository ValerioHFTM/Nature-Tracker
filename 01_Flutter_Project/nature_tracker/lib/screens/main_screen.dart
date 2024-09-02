import 'package:flutter/material.dart';

import 'package:nature_tracker/models/app_colors.dart';
import 'package:nature_tracker/models/group.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:nature_tracker/models/user_data.dart';
import 'package:nature_tracker/models/user_manager.dart';




import 'package:nature_tracker/widgets/floating_action_button_widget.dart';

import 'package:nature_tracker/screens/group_detail_screen.dart';
import 'package:nature_tracker/screens/blog_screen.dart';
import 'package:nature_tracker/screens/login_screen.dart';
import 'package:nature_tracker/screens/user_settings_screen.dart';


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
  final List<Group> _groups = [];
  late bool _isLoggedIn;
  late UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeGroups();
    _initializeUser();
  }

 void _initializeUser() {
  try {
    // Attempt to find the user by username
    _currentUser = UserManager.instance.registeredUsers
        .firstWhere((user) => user.username == widget.userName);
    _isLoggedIn = true;  // User found, so user is logged in
  } catch (e) {
    // If no user is found, handle the case
    _currentUser = null;  // Set _currentUser to null
    _isLoggedIn = widget.isLoggedIn;  // Use the provided isLoggedIn status
  }
}

  void _initializeGroups() {
    final demoGroup = Group(name: 'Demo Adventure ');

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

    demoGroup.myBlogs.add(demoMyBlog);

    setState(() {
      _groups.add(demoGroup);
      _myBlogs.add(demoMyBlog);
    });
  }

  void _logout() {
  setState(() {
    _isLoggedIn = false; // Update login state
  });
 
}


  void _goToBlog(MyBlog blog) {
    setState(() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BlogScreen(blog: blog)),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background-06.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: AppColors.color3,
                elevation: 6.0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: AppColors.color1),
                title: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/header.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: _selectedIndex == 0
                    ? _buildOverview()
                    : _buildAdventure(context),
              ),
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
    child: Column(
      children: <Widget>[
        const SizedBox(
          height: 150.0,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.color1,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.color3,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                  leading: const Icon(Icons.favorite, color: AppColors.color4),
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
                          builder: (context) => UserSettingsScreen(user: _currentUser),
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
                  leading: const Icon(Icons.settings, color: AppColors.color4),
                  title: const Text('Settings',
                      style: TextStyle(color: AppColors.color1)),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Add action for Settings
                  },
                ),
                if (_isLoggedIn)
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.color4),
                    title: const Text('Logout',
                        style: TextStyle(color: AppColors.color1)),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      setState(() {
                        _isLoggedIn = false; // Update login state
                      });
                      // Navigate to LoginScreen
                      Navigator.of(context).pushReplacement(
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
        final truncatedGroupName = blog.groupName.substring(0, 15);

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
                          color: AppColors.color5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        truncatedGroupName,
                        style: const TextStyle(
                          fontSize: 14,
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
                  bottom: 0,
                  left: 0,
                  child: IconButton(
                    icon: Icon(
                      blog.liked ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.color5,
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

  //save this function for later when i implement this again
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
    TextEditingController titleController =
        TextEditingController(text: blog.title);
        TextEditingController contentController =
        TextEditingController(text: blog.content);
    String updatedCategory = blog.category;

    final focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.color3,
              title: const Text(
                'Edit Blog',
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
                      hintStyle: TextStyle(color: AppColors.color5),
                    ),
                    style: const TextStyle(color: AppColors.color1),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: updatedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        updatedCategory = newValue!;
                      });
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category,
                            style: const TextStyle(color: AppColors.color1)),
                      );
                    }).toList(),
                    dropdownColor: AppColors.color3,
                    focusNode: focusNode,
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
                  onPressed: () {
                    setState(() {
                      blog.title = titleController.text;
                      blog.content = contentController.text;
                      blog.category = updatedCategory;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.color1),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

void _showAddBlogDialog() {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String selectedCategory = _categories.first;
  String selectedGroup = _groups.isNotEmpty ? _groups.first.name : '';

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
              decoration: InputDecoration(
                hintText: 'Blog Title',
                hintStyle: TextStyle(color: AppColors.color1),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1),
                ),
              ),
              style: TextStyle(color: AppColors.color1),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Blog Content',
                hintStyle: TextStyle(color: AppColors.color1),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1),
                ),
              ),
              style: TextStyle(color: AppColors.color1),
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
                    style: TextStyle(color: AppColors.color1),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
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
              items: _groups.map<DropdownMenuItem<String>>((Group group) {
                return DropdownMenuItem<String>(
                  value: group.name,
                  child: Text(
                    group.name,
                    style: TextStyle(color: AppColors.color1),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
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
            onPressed: () {
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
              setState(() {
                _myBlogs.add(newBlog);
                _groups
                    .firstWhere((group) => group.name == selectedGroup)
                    .myBlogs
                    .add(newBlog);
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
            onPressed: () {
              final newGroup = Group(name: nameController.text);
              setState(() {
                _groups.add(newGroup);
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
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GroupDetailScreen(group: group),
              ),
            );
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
              group.name,
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
