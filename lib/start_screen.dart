import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/startscreen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0),
            ),
            const Text(
              "BESAFE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 100.0,
                fontFamily: "Oswald",
                fontWeight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(60.0),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 60.0, right: 20),
              child: Text(
                "We can safe your life",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0, right: 200.0),
              // ignore: unnecessary_const
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 86, 91, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Login()),
                  //     );
                },
                child: const Text(
                  'Get started',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Oswald",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
