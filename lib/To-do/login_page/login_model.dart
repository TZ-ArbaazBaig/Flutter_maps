class UserModel {
  final String username;
  final String password;

  UserModel({required this.username, required this.password});

  String? validate() {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    if (!username.contains('@')) {
      return 'Please enter a valid email address';
    }
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    return null; 
  }
}
