import 'package:be_safe/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:be_safe/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  final repeatPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    repeatPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));

    if (isValid) {
      _formKey.currentState!.save();
      print(_enteredEmail);
      print(_enteredPassword);
      try {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _enteredEmail,
          'isAdmin': false, 
        });
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
      }
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
            image: AssetImage("assets/images/signup.jpg"),
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
                "Create\n Account",
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
                height: 100,
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
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
              //email textfield
              SizedBox(
                width: 300,
                height: 100,
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
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) =>
                      password != null && password.length < 6
                          ? 'Enter min. 6 characters'
                          : null,
                ),
              ),
              //password textbox
              SizedBox(
                width: 300,
                height: 100,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Repeat Password',
                  ),
                  obscureText: true,
                  showCursor: false,
                  controller: repeatPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) => password != null &&
                          password.length < 6 &&
                          password != passwordController.text
                      ? 'Password must be the same'
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
                  onPressed: _submit, //signUp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 86, 91, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Sign up'),
                ),
              ),
              TextButton(
                child: const Text('I already have an account'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyMapWidget()) //const Login()),
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
