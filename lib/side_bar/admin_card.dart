import 'package:flutter/material.dart';

import '../admin_panel.dart';

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
        ListTile(
          leading:const SizedBox(
            height: 34,
            width: 34,
            child: Icon(Icons.block),
          ),
          title:const Text("Block Users"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminUserManagementScreen()),
            );
          },
        ),
      ],
    );
  }
}
