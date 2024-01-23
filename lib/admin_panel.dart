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
        title: Text("Zarządzanie Użytkownikami"),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView(
            children: snapshot.data!.docs.map((user) {
              return ListTile(
                title: Text(
                    user['email']), // przykład, może być inny identyfikator
                trailing: IconButton(
                  icon: Icon(Icons.delete),
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
