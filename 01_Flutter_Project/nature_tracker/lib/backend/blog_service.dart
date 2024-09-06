import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nature_tracker/models/adventure.dart';
import 'package:nature_tracker/models/my_blog.dart';
import 'package:nature_tracker/models/user_data.dart';

List<UserData> initializedUser = [];
List<Adventure> initializedAdventure = [];
List<MyBlog> initializedBlog = [];

//Post Requests
//##############################################################################
Future<void> saveAdventure(Adventure newAdventure) async {
  final url = Uri.https(
      'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
      'Adventures.json');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': newAdventure.name,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to save adventure');
  }
}

Future<void> saveBlog(MyBlog newBlog) async {
  final url = Uri.https(
      'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
      'blogs.json');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(
      {
        'groupName': newBlog.groupName,
        'category': newBlog.category,
        'title': newBlog.title,
        'content': newBlog.content,
        'steps': newBlog.steps,
        'altitude': newBlog.altitude,
        'distance': newBlog.distance,
      },
    ),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to save blog');
  }
}

//Get Requests
//##############################################################################

Future<List<Adventure>> getAdventures() async {
  final url = Uri.https(
    'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
    'Adventures.json',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> adventureData = json.decode(response.body);
    List<Adventure> adventures = [];

    for (final item in adventureData.entries) {
      adventures.add(
        Adventure(
          id: item.key,
          name: item.value['name'] ?? 'Unnamed Adventure',
        ),
      );
    }
    initializedAdventure = adventures;
    return adventures;
  } else {
    throw Exception('Failed to load adventures');
  }
}

Future<List<UserData>> getUsers() async {
  final url = Uri.https(
      'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
      'users.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> userData = json.decode(response.body);
    List<UserData> users = [];

    for (final item in userData.entries) {
      users.add(
        UserData.fromMap({
          'id': item.key,
          'username': item.value['username'] ?? 'Unnamed User',
          'firstname': item.value['firstname'] ?? '',
          'lastname': item.value['lastname'] ?? '',
          'email': item.value['email'] ?? '',
          'gender': item.value['gender'] ?? 2,
          'age': item.value['age'] ?? DateTime(2000, 1, 1).toIso8601String(),
          'description': item.value['description'] ?? '',
          'imageUrls': item.value['imageUrls'] ?? [],
          'password': item.value['password'] ?? '',
        }),
      );
    }
    print(initializedUser.length);
    initializedUser = users;
    return users;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<List<MyBlog>> getBlogs() async {
  final url = Uri.https(
      'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
      'blogs.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> blogData = json.decode(response.body);
    List<MyBlog> blogs = [];

    for (final item in blogData.entries) {
      blogs.add(
        MyBlog(
          id: item.key,
          groupName: item.value['groupName'] ?? 'No Group Name',
          category: item.value['category'] ?? 'No Category',
          title: item.value['title'] ?? 'No Title',
          content: item.value['content'] ?? 'No Content',
          steps: item.value['steps'] ?? 5000,
          altitude: item.value['altitude'] ?? 0,
          distance: item.value['distance'] ?? 5000,
          liked: item.value['liked'] ?? false,
          isCounting: item.value['isCounting'] ?? false,
          imageUrls: List<String>.from(item.value['imageUrls'] ?? []),
        ),
      );
    }

    initializedBlog = blogs;
    return blogs;
  } else {
    throw Exception('Failed to load blogs');
  }
}

List<MyBlog> getInitializedBlogs() {
  print(initializedBlog.length);
  return initializedBlog;
}

List<UserData> getInitializeduser() {
  return initializedUser;
}

List<Adventure> getInitializedAdventure() {
  return initializedAdventure;
}

//Put Requests
//##############################################################################

Future<void> updateAdventure(Adventure adventure) async {
  final url = Uri.https(
    'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
    'Adventures/${adventure.id}.json',
  );

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': adventure.name,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update adventure');
  }
}

Future<void> updateBlog(MyBlog blog) async {
  final url = Uri.https(
    'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
    'blogs/${blog.id}.json',
  );

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'groupName': blog.groupName,
      'category': blog.category,
      'title': blog.title,
      'content': blog.content,
      'steps': blog.steps,
      'altitude': blog.altitude,
      'distance': blog.distance,
      'liked': blog.liked,
      'isCounting': blog.isCounting,
      'imageUrls': blog.imageUrls,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update blog');
  }
}

Future<void> deleteBlog(MyBlog blog) async {
  final url = Uri.https(
    'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
    'blogs/${blog.id}.json',
  );

  final response = await http.delete(url);
  print(blog.id);
  if (response.statusCode != 200) {
    throw Exception('Failed to delete blog');
  }
}

Future<void> updateUser(UserData user) async {
  final url = Uri.https(
    'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
    'users/${user.id}.json',
  );

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': user.username,
      'firstname': user.firstname,
      'lastname': user.lastname,
      'email': user.email,
      //'gender': user.gender,
      //'age': user.age,
      'description': user.description,
      'imageUrls': user.imageUrls,
      'password': user.password,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update user');
  }
}
