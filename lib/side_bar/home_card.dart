import 'package:be_safe/map.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.home),
      ),
      title: const Text("Home"),
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyMapWidget()),
        );
      },
    );
  }
}
