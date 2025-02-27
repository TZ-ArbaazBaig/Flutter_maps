import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(Secure());
}

class Secure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Token Login Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

// A secure storage instance for storing the token
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if a token exists in secure storage
  Future<void> _checkLoginStatus() async {
    token = await secureStorage.read(key: 'access_token');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  // Simulated login function
  Future<void> login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // Mock validation: Replace this with an actual API call
    if (username == 'user' && password == 'password') {
      token = 'mock_token_12345'; // Simulated token
      await secureStorage.write(key: 'access_token', value: token);
      setState(() {
        isLoggedIn = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  // Logout function
  Future<void> logout() async {
    await secureStorage.delete(key: 'access_token');
    setState(() {
      isLoggedIn = false;
      token = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Login Example'),
      ),
      body: isLoggedIn ? _buildLoggedInView() : _buildLoginForm(),
    );
  }

  // Login Form UI
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: login,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  // Logged In View UI
  Widget _buildLoggedInView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome! You are logged in.'),
          const SizedBox(height: 16),
          Text('Token: $token'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
