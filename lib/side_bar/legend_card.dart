import 'package:flutter/material.dart';

class LegendCard extends StatelessWidget {
  const LegendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        height: 34,
        width: 34,
        child: Icon(Icons.legend_toggle),
      ),
      title: const Text("Legend"),
      onTap: () {
        _showLegendDialog(context);
      },
    );
  }

  void _showLegendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Legend"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildLegendItem(
                    'Accident', 'assets/images/car_accident.png', Colors.blue),
                _buildLegendItem('Dangerous person',
                    'assets/images/dangerous_person.png', Colors.purple),
                _buildLegendItem(
                    'Fighting', 'assets/images/fight.png', Colors.orange),
                _buildLegendItem(
                    'Theft', 'assets/images/theft.png', Colors.red),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(
      String eventType, String imagePath, Color markerColor) {
    return Row(
      children: <Widget>[
        Icon(Icons.location_on, color: markerColor),
        const SizedBox(width: 8),
        Image.asset(imagePath, width: 24, height: 24),
        const SizedBox(width: 8),
        Text(eventType),
      ],
    );
  }
}
