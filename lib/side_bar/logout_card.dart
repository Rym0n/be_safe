import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../login.dart';

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class LogoutCard extends StatelessWidget {
  const LogoutCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.logout),
      ),
      title: const Text("Logout"),
      onTap: () {
        _signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      },
    );
  }
}
