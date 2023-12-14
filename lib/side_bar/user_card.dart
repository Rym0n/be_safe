import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.userEmail,
    required this.role,
  });
  final String userEmail, role;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        userEmail,
      ), //zmien na email
      subtitle: Text(
        role,
        style: const TextStyle(color: Colors.grey),
      ), //zmien na admin oraz uzytkownik
    );
  }
}
