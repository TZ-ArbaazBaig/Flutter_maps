import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text('My Profile'),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Center(
            child: Text(
              'AED',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
