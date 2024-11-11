import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_fotograf_chat/Home/Home.dart';
import 'package:my_fotograf_chat/Registratsia/Forget_pas.dart';
import 'package:my_fotograf_chat/Registratsia/Google/Google_sing.dart';
import 'package:my_fotograf_chat/Registratsia/Sing_Up/Sing.dart';
import 'package:my_fotograf_chat/Wrapper/Wrap_register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isUsernameFocused = false;
  bool isPasswordFocused = false;
  String email = "", password = "";

  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "User-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for thet Email",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else if (e.code == "Wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Worning Passwor Provided by User",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),

                  Center(
                    child: Text(
                      "HELLO AGAIN!",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Username TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          setState(() {
                            isUsernameFocused = focus;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: isUsernameFocused
                                    ? Colors.blue.shade800
                                    : Colors.white,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: emailcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Plase Enter E-mail";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              suffixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          setState(() {
                            isPasswordFocused = focus;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: isPasswordFocused
                                    ? Colors.blue.shade800
                                    : Colors.white,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Plase Enter Password";
                              }
                              return null;
                            },
                            controller: passwordcontroller,
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              suffixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      bottom: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => forgetpas(),
                            ));
                      },
                      child: Text(
                        "Forgate password?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 65, vertical: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = emailcontroller.text;
                            password = passwordcontroller.text;
                          });
                        }
                        userLogin();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Center(
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      "Or sign in with",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            // Google orqali tizimga kirish jarayonini boshlash
                            final GoogleSignInAccount? googleUser =
                                await GoogleSignIn().signIn();

                            if (googleUser == null) {
                              // Agar foydalanuvchi Google hisobini tanlamasa yoki tizimga kirishni bekor qilsa
                              print("Google sign-in canceled");
                              return;
                            }

                            // Agar foydalanuvchi hisobini tanlasa, autentifikatsiya jarayonini davom ettiramiz
                            final GoogleSignInAuthentication googleAuth =
                                await googleUser.authentication;

                            final AuthCredential credential =
                                GoogleAuthProvider.credential(
                              accessToken: googleAuth.accessToken,
                              idToken: googleAuth.idToken,
                            );

                            // Firebase orqali tizimga kirish
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);

                            // Tizimga kirganidan so'ng Home sahifasiga o'tish
                            if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
                              );
                            } else {
                              // Agar tizimga kira olmasa
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Failed to sign in with Google")),
                              );
                            }
                          } catch (e) {
                            print("Error during Google sign-in: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Error signing in with Google")),
                            );
                          }
                        },
                        label: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 25,
                              child: Image.asset("images/google.png"),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Google',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Facebook Sign-in'),
                                content: Text(
                                    'Sorry, this registration method is currently not working. We are working on it, please use another method'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Dialogni yopish
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.facebook, color: Colors.white),
                        label: Text(
                          'Facebook',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 45),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an accaunt?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Logup(),
                              ));
                        },
                        child: Text(
                          "Register new",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 107, 107, 252)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
