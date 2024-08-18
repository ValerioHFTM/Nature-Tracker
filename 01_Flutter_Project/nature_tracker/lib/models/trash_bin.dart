class TrashBin {
  final String id;
  final String name;
  final String groupName;
  final String category;
  bool isFull;

  TrashBin({
    required this.id,
    required this.name,
    required this.groupName,
    required this.category,
    this.isFull = false,
  });
}
