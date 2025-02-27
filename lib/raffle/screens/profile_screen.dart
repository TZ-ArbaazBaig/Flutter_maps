import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../components/profile_list_tile.dart';



void main() => runApp(const MaterialApp(home: ProfileScreen()));

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 4;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Text(
                'P',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Priya Aji',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Zudio    Shop Admin',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ProfileListTile(
              title: 'Personal Details',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
              },
            ),
            ProfileListTile(
              title: 'Profile Picture',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
              },
            ),
            ProfileListTile(
              title: 'Change Password',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
              },
            ),
            ProfileListTile(
              title: 'Team Management',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
              },
            ),
            ProfileListTile(
              title: 'Help & Support',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                // Handle tap
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {},
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
