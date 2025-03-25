import 'package:admin_panel/pages/admin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

// ________________________________________
//
//          *  E-mail Text Field
//
// ________________________________________

  Widget mailTextField() {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue[200],
        ),
        controller: mailController,
      ),
    );
  }

// ________________________________________
//
//          *  Password Text Field
//
// ________________________________________

  Widget passwordTextField() {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue[300],
        ),
        controller: passwordController,
        obscureText: true,
      ),
    );
  }

// ________________________________________
//
//          *  Login Button
//
// ________________________________________

  Widget loginButton() {
    return ElevatedButton(
      onPressed: handleLogin,
      child: const Text("Login"),
    );
  }

// ________________________________________
//
//            Show Message
//
// ________________________________________

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

// ________________________________________
//
//            Handle Login Logic
//
// ________________________________________

  Future<void> handleCheckLogin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final role = doc.data()?['role'];
    if (role == 'admin') {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else {
      showMessage("Brak uprawnień");
    }
  }
// ________________________________________
//
//            Handle Logic Errors
//
// ________________________________________

  void handleLoginError(FirebaseAuthException error) {
    if (error.code == 'user-not-found') {
      showMessage("Zła nazwa użytkownika");
    } else if (error.code == "wrong-password") {
      showMessage("Złe hasło");
    } else if (error.code == "channel-error") {
      showMessage("Problem z połączeniem z Firebase Auth");
    }
  }

// ________________________________________
//
//           ! Handle Login
//
// ________________________________________

  Future<void> handleLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailController.text, password: passwordController.text);
      showMessage("Zalogowano");
      handleCheckLogin();
    } on FirebaseAuthException catch (error) {
      handleLoginError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mailTextField(),
            passwordTextField(),
            loginButton(),
          ],
        ),
      ),
    );
  }
}
