import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:be_safe/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:be_safe/map.dart';
import 'package:be_safe/admin_panel.dart';

final _firebase = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      print(_enteredEmail);
      print(_enteredPassword);
    }
    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .get();
      final isAdmin = userDoc.data()?['isAdmin'] ?? false;

      if (isAdmin) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminUserManagementScreen()));
        print(userCredentials);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyMapWidget()));
        print(userCredentials);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(50.0),
              ),
              const Text(
                "Log in to\n Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: "Oswald",
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(100.0),
              ),
              //username textfield
              SizedBox(
                width: 300,
                height: 70,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                  ),
                  obscureText: false,
                  showCursor: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  //controller: emailController,
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    if (email == null ||
                        email.trim().isEmpty ||
                        !email.contains('@')) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _enteredEmail = email!;
                  },
                ),
              ),
              //password textbox
              SizedBox(
                width: 300,
                height: 70,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  showCursor: false,
                  //controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) =>
                      password != null && password.length < 6
                          ? 'Enter min. 6 characters'
                          : null,

                  onSaved: (password) {
                    _enteredPassword = password!;
                  },
                ),
              ),
              //signin button #00565Bcolor
              //Color.fromRGBO(0, 86, 91,1)
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: _submit, //_logInWithEmail,

                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 86, 91, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                width: 100,
                height: 20,
              ),
              
              TextButton(
                child: const Text("Create an account"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SignUp()), // MyMapWidget()) //
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
