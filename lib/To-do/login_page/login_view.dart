import 'package:currency_converter/To-do/login_page/login_controller.dart';
import 'package:currency_converter/To-do/login_page/login_model.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = LoginController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    UserModel user = UserModel(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    String? validationError = user.validate();
    if (validationError != null) {
      setState(() {
        _isLoading = false;
        _errorMessage = validationError;
      });
      return;
    }

    String? loginError = await _loginController.login(user.username, user.password);
    if (loginError != null) {
      setState(() {
        _isLoading = false;
        _errorMessage = loginError;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/nextPage');
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
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ),
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
}
