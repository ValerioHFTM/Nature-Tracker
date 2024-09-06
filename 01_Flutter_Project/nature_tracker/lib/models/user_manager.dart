import 'package:nature_tracker/models/user_data.dart';

class UserManager {
  // Singleton pattern
  UserManager._privateConstructor();
  static final UserManager instance = UserManager._privateConstructor();

  // List to store registered users
  final List<UserData> _registeredUsers = [];

  // Add a new user
  void addUser(UserData user) {
    _registeredUsers.add(user);
  }

  // Validate user credentials
  bool validateCredentials(String username, String password) {
    return _registeredUsers
        .any((user) => user.username == username && user.password == password);
  }

  // Public getter to access the list of registered users
  List<UserData> get registeredUsers => _registeredUsers;
}
