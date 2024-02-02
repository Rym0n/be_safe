import 'package:be_safe/side_bar/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_card.dart';
import 'home_card.dart';
import 'info_card.dart';
import 'logout_card.dart';

class SideBarMenu extends StatefulWidget {
  final String cityText;
  final VoidCallback onInfoPressed;
  const SideBarMenu(
      {super.key, required this.cityText, required this.onInfoPressed});

  //final bool isActive;
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  User? currentUser;
  String userRole = 'user';

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
    getUserRole();
  }

  Future<void> getUserRole() async {
    if (currentUser != null) {
      var userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      bool isAdmin = userDocument.data()?['isAdmin'] ?? false;
      setState(() {
        userRole = isAdmin ? 'admin' : 'user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 226, 222, 205),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildMenu(context, currentUser, userRole, widget.cityText, widget.onInfoPressed),
          ],
        ),
      ),
    );
  }
}

Widget buildMenu(
    BuildContext context, User? user, String role, String cityText, VoidCallback onInfoPressed) {
  return Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    child: Column(
      children: [
        UserCard(
          userEmail: user?.email ?? 'user1@gmail.com',
          role: role,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
        const HomeCard(),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
        InfoCard(
          infoText: cityText,
          onInfoPressed: onInfoPressed,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
        const SizedBox(
          height: 96,
        ),
        if (role == 'admin') const AdminCard(),
        if (role == 'admin')
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
        const SizedBox(
          height: 300,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
        const LogoutCard(),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ],
    ),
  );
}
//const Color.fromRGBO(0, 86, 91, 1), zielony kolor
