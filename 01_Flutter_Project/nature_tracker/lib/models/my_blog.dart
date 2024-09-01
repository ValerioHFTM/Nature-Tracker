class MyBlog {
  String id;
  String groupName;
  String category;
  String title;
  String content;
  int steps;
  int altitude;
  int distance;
  bool liked;
  bool isCounting;
  List<String>? imageUrls; // Add this line to hold image URLs

  MyBlog({
    required this.id,
    required this.groupName,
    required this.category,
    required this.title,
    required this.content,
    this.steps = 5000,
    this.altitude = 0,
    this.distance = 5000,
    this.liked = false,
    this.isCounting = false,
    List<String>? imageUrls, // Allow null to use default
  }) : imageUrls = imageUrls ?? []; // Initialize with an empty list if null
}
