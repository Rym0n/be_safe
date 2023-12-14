import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.home),
      ),
      title: Text("Home"),
    );
  }
}
