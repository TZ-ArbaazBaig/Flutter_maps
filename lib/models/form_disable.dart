import 'package:flutter/material.dart';

void main() {
  runApp(Disable());
}

class Disable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Form Validation Example")),
        body: UserForm(),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;

  bool _isButtonEnabled = false;

  void _checkFormValidity() {
    setState(() {
      // Enable the button only if all fields are valid and not null/empty
      _isButtonEnabled = _name?.isNotEmpty == true &&
          _email?.isNotEmpty == true &&
          _password?.isNotEmpty == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                _name = value;
                _checkFormValidity();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            // Email Field
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                _email = value;
                _checkFormValidity();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+").hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            // Password Field
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                _password = value;
                _checkFormValidity();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      if (_formKey.currentState?.validate() == true) {
                        // Form is valid, process the data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form Submitted Successfully!')),
                        );
                      }
                    }
                  : null, // Disabled if _isButtonEnabled is false
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
