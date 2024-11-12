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
  String? _logoutMessage; // Variable to store logout reason

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // User is authenticated, check account status
            User? user = snapshot.data;

            if (user != null) {
              // Check if the user's account is blocked or deleted
              return FutureBuilder<void>(
                future: _checkUserStatus(user),
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (futureSnapshot.hasError) {
                    // If there's an error, navigate to the Login page with the error message
                    _logoutMessage = futureSnapshot.error.toString();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    });
                    return Container();
                  } else {
                    return Home(); // Proceed to Home screen if no issue is found
                  }
                },
              );
            } else {
              return Login();
            }
          } else {
            return Login();
          }
        },
      ),
    );
  }

  // Function to check the user account status (blocked or deleted)
  Future<void> _checkUserStatus(User user) async {
    try {
      await user.reload(); // Refresh account status
      // Additional checks for account status can be added here
    } catch (e) {
      // Throw an error if the account is deleted or blocked by admin
      throw FirebaseAuthException(
        code: 'user-deleted',
        message: 'Your account has been deleted by an admin.',
      );
    }
  }
}
