import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 30),
                  _logout(context),
                ],
              ),
            )
        )
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff0D6EFD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          ),
          minimumSize: const Size(double.infinity,60),
          elevation: 0,
        ),
        onPressed: () async {
          await AuthService().signout(context: context);
        },
        child: Text("Sign Out")
    );
  }
}