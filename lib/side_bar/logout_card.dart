import 'package:flutter/material.dart';

class LogoutCard extends StatelessWidget {
  const LogoutCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.logout),
      ),
      title: Text("Logout"),
    );
  }
}
