import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import '../Widgets/progress_dialog.dart';
import '../global/global.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  validateForm() {
    if (nametextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters");
    } else if (!emailtextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "email address is not valid");
    } else if (phonetextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "phone number must have 10 members");
    } else if (passwordtextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "passsword must have minimum 6 characters");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(Message: "processing please wait");
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailtextEditingController.text.trim(),
      password: passwordtextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "error" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nametextEditingController.text.trim(),
        "email": emailtextEditingController.text.trim(),
        "phone": phonetextEditingController.text.trim(),
      };
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "account has been created");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "account has not been created");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Image.asset("images/logo.png"),
            ),
            Text(
              "Register As User",
              style: GoogleFonts.patrickHand(
                  fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: nametextEditingController,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            TextField(
              controller: emailtextEditingController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            TextFormField(
              controller: phonetextEditingController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "enter your pone number",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            TextField(
              controller: passwordtextEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              decoration: const InputDecoration(
                  labelText: "password",
                  hintText: "password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                child: Text(
                  "create Account",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: Text("Already have an Account? Login  Here")),
          ],
        ),
      )),
    );
  }
}
