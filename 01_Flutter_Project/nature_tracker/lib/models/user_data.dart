import 'package:uuid/uuid.dart';

// Define the Gender enum
enum Gender { male, female, others }

class UserData {
  final String id;
   String username;
   String firstname;
   String lastname;
   String email;
   Gender gender;
   DateTime age;
   String description;
   List<String> imageUrls; // Profile pictures
   String password;

  UserData({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.gender,
    required this.age,
    required this.description,
    required this.password,
    List<String>? imageUrls, // Allow null to use default
  })  : id = const Uuid().v4(), // Generate a unique ID for each user
        imageUrls = imageUrls ?? []; // Initialize with an empty list if null

  // Factory constructor to create a UserData instance from a map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      gender: Gender.values[map['gender']], // Assumes index mapping
      age: DateTime.parse(map['age']), // Assumes age is stored as an ISO 8601 string
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      password: map['password'],
    );
  }

  // Convert a UserData instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'gender': gender.index, // Store gender as an index
      'age': age.toIso8601String(), // Store age as an ISO 8601 string
      'description': description,
      'imageUrls': imageUrls,
      'password' : password,
    };
  }
}



