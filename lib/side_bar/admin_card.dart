import 'package:flutter/material.dart';

class AdminCard extends StatelessWidget {
  const AdminCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Admin settings'.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
        const ListTile(
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Icon(Icons.block),
          ),
          title: Text("Block Users"),
        ),
      ],
    );
  }
}
