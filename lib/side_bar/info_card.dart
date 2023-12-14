import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.info),
      ),
      title: Text("Info"),
    );
  }
}
