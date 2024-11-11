import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_fotograf_chat/Home/Home.dart';
import 'package:my_fotograf_chat/Registratsia/Login.dart';

class WrapRegister extends StatefulWidget {
  const WrapRegister({super.key});

  @override
  State<WrapRegister> createState() => _WrapRegisterState();
}

class _WrapRegisterState extends State<WrapRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // Agar foydalanuvchi tizimga kirgan bo'lsa, Home sahifasini ko'rsatadi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Home sahifasiga o'tish va avvalgi sahifani olib tashlash
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            });
            return Container(); // Return an empty container while redirecting
          } else {
            // Agar foydalanuvchi tizimga kirgan bo'lmasa, Login sahifasini ko'rsatadi
            return Login();
          }
        },
      ),
    );
  }
}
