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

  // void _showInfoDialog(BuildContext context, String infoText) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Informacje o Mieście"),
  //         content: Text(infoText),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Zamknij"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
