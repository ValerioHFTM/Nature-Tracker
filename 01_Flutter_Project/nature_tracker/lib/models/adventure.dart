import 'package:nature_tracker/models/my_blog.dart';

class Adventure {
  final String name;
  final String id;
  final List<MyBlog> myBlogs;

  Adventure({
    required this.name,
    required this.id,
  }) : myBlogs = [];
}
