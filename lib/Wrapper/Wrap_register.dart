import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_fotograf_chat/Home/Home.dart';
import 'package:my_fotograf_chat/Registratsia/Login.dart';
import 'package:intl/intl.dart';

class WrapRegister extends StatefulWidget {
  const WrapRegister({super.key});

  @override
  State<WrapRegister> createState() => _WrapRegisterState();
}

class _WrapRegisterState extends State<WrapRegister> {
  String? _logoutMessage; // Chiqish sababini saqlash uchun o‘zgaruvchi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // Foydalanuvchi autentifikatsiyadan o‘tgan, akkaunt holatini tekshiramiz.
            User? user = snapshot.data;

            if (user != null) {
              // Foydalanuvchi akkauntining bloklanmagan yoki o‘chirilmaganligini tekshirish
              return FutureBuilder<void>(
                future: _checkUserStatus(user),
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (futureSnapshot.hasError) {
                    // Xatolik bo‘lsa, foydalanuvchini Login sahifasiga o‘tkazamiz va sababni saqlaymiz
                    _logoutMessage = futureSnapshot.error.toString();
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await _showDialogWithTimer(_logoutMessage!); // Dialogni 5 soniyaga ko‘rsatadi
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    });
                    return Container();
                  } else {
                    return Home(); // Agar muammo yo‘q bo‘lsa, Home sahifasiga o‘tkazamiz
                  }
                },
              );
            } else {
              // Foydalanuvchi chiqib ketgan yoki akkaunt noto‘g‘ri bo‘lsa
              return Login();
            }
          } else {
            // Agar foydalanuvchi chiqib ketgan bo‘lsa, Login sahifasida sababni ko‘rsatamiz
            if (_logoutMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _showDialogWithTimer(_logoutMessage!);
                _logoutMessage = null; // Xabarni bir marta ko‘rsatish uchun tozalaymiz
              });
            }
            return Login();
          }
        },
      ),
    );
  }

  // Foydalanuvchi holatini tekshirish funksiyasi (bloklangan yoki o‘chirilgan)
  Future<void> _checkUserStatus(User user) async {
    try {
      await user.reload(); // Akkaunt holatini yangilash
      if (!user.emailVerified) {
        String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        throw FirebaseAuthException(
          code: 'user-blocked',
          message: 'Sizning akkauntingiz $currentTime da admin tomonidan bloklandi.',
        );
      }
    } catch (e) {
      String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      throw FirebaseAuthException(
        code: 'user-deleted',
        message: 'Sizning akkauntingiz $currentTime da admin tomonidan o‘chirildi.',
      );
    }
  }

  // Xabar dialogini ko‘rsatish funksiyasi (5 soniya davomida ochiq qoladi)
  Future<void> _showDialogWithTimer(String message) async {
    int secondsLeft = 5; // 5 soniya hisoblagich
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Har soniya yangilanadigan taymer
            Future.delayed(Duration(seconds: 1), () {
              if (secondsLeft > 1) {
                setState(() {
                  secondsLeft--;
                });
              } else {
                Navigator.of(context).pop(); // 5 soniya o‘tgandan keyin dialog yopiladi
              }
            });

            // Dialog dizayni
            return AlertDialog(
              title: Text('Akkaunt holati'),
              content: Text('$message\n\n$secondsLeft soniyadan so‘ng Login sahifasiga o‘tasiz.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dialogni qo'lda yopish
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
    // Dialogdan chiqishdan keyin Login sahifasiga o‘tkazish
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
