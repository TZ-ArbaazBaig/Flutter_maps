import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const Main());
}


class Main extends StatelessWidget {
const Main({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hidePassword = true;
  String _errorMessage = '';
  String token = "";

  bool _validateInputs() {
    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username cannot be empty';
      });
      return false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Password cannot be empty';
      });
      return false;
    }

    if (!_usernameController.text.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    // Wheretogo();
  }

  Future<void> _login() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://dev-api-v2.s3-app.com/api/v1/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
          'skip_otp': true
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        List<dynamic> data = result['data'];
        String token = data[0]["token"];
        if(kDebugMode)
        {
        print('Token: $token');

        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.pushReplacementNamed(context, '/nextPage');
      } else {
        setState(() {
          Map<String, dynamic> result = jsonDecode(response.body);
          _errorMessage = result['message'] ?? 'Login failed';
        });
      }
    if(kDebugMode)
    {

      print(response.body);
    }
    } catch (e) {
      if(kDebugMode)
      {
      print(e);

      }
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ?
                // Text(token)
                const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
            // SizedBox(height: 20,),

            if (_errorMessage.isNotEmpty)
              SizedBox(
                height: 50,
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // void Wheretogo() async {
  //  var shared_preferences=await SharedPreferences.getInstance();
  //   var log= shared_preferences.getBool("login");
  // }
}
