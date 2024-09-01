import 'package:nature_tracker/models/my_blog.dart';

class Group {
  final String name;
  final List<MyBlog> myBlogs;

  Group({required this.name}) : myBlogs = [];
}
