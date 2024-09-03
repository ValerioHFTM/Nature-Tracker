import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nature_tracker/models/adventure.dart';
import 'package:nature_tracker/models/my_blog.dart';

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

void saveBlog(MyBlog newBlog) async {
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

    return adventures;
  } else {
    throw Exception('Failed to load adventures');
  }
}

void getUsers() async {
  final url = Uri.https(
      'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
      'users.json');
  final response = await http.get(url);
  //print(response.body);
}

void getBlogs() async {
  final url = Uri.https(
      'nature-tracker-vbot-default-rtdb.europe-west1.firebasedatabase.app',
      'blogs.json');
  final response = await http.get(url);

  //print(response.body);
}
