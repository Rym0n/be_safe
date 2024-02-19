import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AdminUserManagementScreen extends StatefulWidget {
  @override
  _AdminUserManagementScreenState createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteUser(String userId) async {
    try {
      print(userId);
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteUser');
      final result = await callable.call(<String, dynamic>{
        'userId': userId,
      });
      print("Wynik: ${result.data}");
    } on FirebaseFunctionsException catch (e) {
      print("Błąd: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BLOCK USERS",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 25.0,
            fontFamily: "Oswald",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 226, 222, 205),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return ListView(
            children: snapshot.data!.docs.map((user) {
              return ListTile(
                title: Text(user['email']),
                trailing: IconButton(
                  icon:const Icon(Icons.delete),
                  onPressed: () => _deleteUser(user.id),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
