import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final IconData trailingIcon;
  final VoidCallback onTap;

  const ProfileListTile({
    Key? key,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(trailingIcon),
      onTap: onTap,
    );
  }
}
