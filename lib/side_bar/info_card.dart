import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String infoText;
  final VoidCallback onInfoPressed;

  const InfoCard(
      {super.key, required this.infoText, required this.onInfoPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.info),
      ),
      title: const Text("Your Location Info"),
      onTap: onInfoPressed,
    );
  }
}
