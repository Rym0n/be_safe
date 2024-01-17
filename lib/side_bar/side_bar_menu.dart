import 'package:be_safe/side_bar/user_card.dart';
import 'package:flutter/material.dart';

import 'admin_card.dart';
import 'home_card.dart';
import 'info_card.dart';
import 'logout_card.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key});

  //final bool isActive;
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 226, 222, 205),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildMenu(context),
          ],
          // child: Scaffold(
          //   body: SafeArea(
          //     child: Container(
          //       width: 288,
          //       height: double.infinity,
          //       color: const Color.fromARGB(255, 226, 222, 205),
          //       child: const Column(
          //         children: [
          //           UserCard(
          //             userEmail: 'user1@gmail.com',
          //             role: 'admin',
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(left: 24),
          //             child: Divider(
          //               color: Colors.grey,
          //               height: 1,
          //             ),
          //           ),
          //           HomeCard(),
          //           Padding(
          //             padding: EdgeInsets.only(left: 24),
          //             child: Divider(
          //               color: Colors.grey,
          //               height: 1,
          //             ),
          //           ),
          //           InfoCard(),
          //           Padding(
          //             padding: EdgeInsets.only(left: 24),
          //             child: Divider(
          //               color: Colors.grey,
          //               height: 1,
          //             ),
          //           ),
          //           SizedBox(
          //             height: 96,
          //           ),
          //           AdminCard(),
          //           Padding(
          //             padding: EdgeInsets.only(left: 24),
          //             child: Divider(
          //               color: Colors.grey,
          //               height: 1,
          //             ),
          //           ),
          //           SizedBox(
          //             height: 300,
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(left: 24),
          //             child: Divider(
          //               color: Colors.grey,
          //               height: 1,
          //             ),
          //           ),
          //           LogoutCard(),
          //           Padding(
          //             padding: EdgeInsets.only(left: 24),
          //             child: Divider(
          //               color: Colors.grey,
          //               height: 1,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

Widget buildMenu(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: const Column(
        children: [
          UserCard(
            userEmail: 'user1@gmail.com',
            role: 'admin',
          ),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          HomeCard(),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          InfoCard(),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          SizedBox(
            height: 96,
          ),
          AdminCard(),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          SizedBox(
            height: 300,
          ),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          LogoutCard(),
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
        ],
      ),
    );
//const Color.fromRGBO(0, 86, 91, 1), zielony kolor
