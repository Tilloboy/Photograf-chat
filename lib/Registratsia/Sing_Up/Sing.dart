import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_fotograf_chat/Home/Home.dart';

class Logup extends StatefulWidget {
  const Logup({super.key});

  @override
  State<Logup> createState() => _LogupState();
}

class _LogupState extends State<Logup> {
  bool isUsernameFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  String name = "", email = "", password = "";
  bool isPasswordValid = false;
  bool isEmailValid = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  // Parolni tekshirish
  bool validatePassword(String password) {
    // Kichik harflar va 6 ta belgidan iborat bo'lishini tekshiradi
    return password.length >= 6 && password == password.toLowerCase();
  }

  // Emailni tekshirish
  bool validateEmail(String email) {
    // Email formatini tekshiradi
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  registration() async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(), // Home sahifasini o'zgartiring
            ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password is too weak",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account already exists",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    } else {
      // Formani tekshirishda xato
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out the form correctly")),
      );
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      "YOW AGAIN!",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Name";
                              }
                              return null;
                            },
                            controller: namecontroller,
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
                              hintText: "Enter your Name",
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
                  // Email TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          setState(() {
                            isEmailFocused = focus;
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
                                color: isEmailFocused
                                    ? Colors.blue.shade800
                                    : Colors.white,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              email = value!;
                              if (value.isEmpty) {
                                return "Please enter an email";
                              } else if (!validateEmail(value)) {
                                return "Invalid email format";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                isEmailValid = validateEmail(value);
                              });
                            },
                            controller: emailcontroller,
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
                                Icons.email,
                                color: Colors.white,
                              ),
                              hintText: "Enter your Email",
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
                  // Email validation hint
                  if (email.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          "Valid email format",
                          style: TextStyle(color: isEmailValid ? Colors.green : Colors.red),
                        ),
                        if (isEmailValid)
                          Icon(Icons.check, color: Colors.green),
                      ],
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
                              password = value!;
                              if (value.isEmpty) {
                                return "Please enter a password";
                              } else if (!validatePassword(value)) {
                                return "Password must be at least 6 characters and contain only lowercase letters";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                isPasswordValid = validatePassword(value);
                              });
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
                              hintText: "Enter your Password",
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
                  // Password validation hint
                  if (password.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          "Password is valid",
                          style: TextStyle(color: isPasswordValid ? Colors.green : Colors.red),
                        ),
                        if (isPasswordValid)
                          Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  SizedBox(height: 25),
                  // Register Button
                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 65, vertical: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = emailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                          });
                        }
                        registration();
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
                              "Next",
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
                  Text(
                    "Or Register in with",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Implement Google sign-in functionality here
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
                          // Implement Facebook sign-in functionality here
                        },
                        icon: Icon(Icons.facebook, color: Colors.white),
                        label: Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          " Log in",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 107, 107, 252)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
