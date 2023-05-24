import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/user.dart';
import 'package:uvbs/models/error.dart';
import 'package:uvbs/prefs.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:uvbs/providers/userProvider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int screen = 0;
  bool loading = false;
  String tc = "";
  String pp = "";

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _passwordVisible = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKeyLogin = GlobalKey<ScaffoldState>();

  PersistentBottomSheetController openBottomSheet(key, String msg) {
    return key.currentState!.showBottomSheet(
        (context) => Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    msg,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                      splashRadius: 25,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 247, 252, 255),
                        size: 20,
                      ))
                ],
              ),
            ),
        backgroundColor: const Color.fromARGB(255, 1, 47, 83));
  }

  void termsAndConditions() async {
    final data =
        await rootBundle.loadString('lib/assets/text/terms-conditions.txt');
    setState(() {
      tc = data;
    });
  }

  void privacyPolicy() async {
    final data =
        await rootBundle.loadString('lib/assets/text/privacy-policy.txt');
    setState(() {
      pp = data;
    });
  }

  @override
  void initState() {
    super.initState();
    termsAndConditions();
    privacyPolicy();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isValidEmail(e) {
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(e);
    }

    return screen == 0
        ? Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromARGB(255, 0, 26, 48),
                    Color.fromARGB(255, 1, 46, 83)
                  ])),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 38, 168, 254),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(200),
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(200)),
                      ),
                      child: Image.asset("lib/assets/images/home_svg.png"),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome",
                              style:
                                  TextStyle(fontSize: 34, color: Colors.white),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 7, bottom: 10),
                              child: Text(
                                "Let's start with UVBS",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      screen = 1;
                                    }),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          50,
                                      height: 55,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text(
                                        "Signup",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      screen = 2;
                                    }),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          50,
                                      height: 55,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text(
                                        "Signin",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 2, 41, 72),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width - 60,
                        child: const Text(
                          "Powered by Galilee Solutions",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 11),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : screen == 1
            ? Scaffold(
                key: _scaffoldKey,
                // resizeToAvoidBottomInset: false,
                body: Stack(children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 251, 253, 255)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/assets/images/signup.png",
                              width: 200,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              margin: const EdgeInsets.only(top: 40),
                              height: 55,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: Color.fromARGB(27, 77, 177, 253),
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: name,
                                  cursorColor: Colors.black,
                                  cursorRadius: const Radius.circular(10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              margin: const EdgeInsets.only(top: 24),
                              height: 55,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: Color.fromARGB(41, 77, 177, 253),
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: email,
                                  cursorColor: Colors.black,
                                  cursorRadius: const Radius.circular(10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              margin: const EdgeInsets.only(top: 24),
                              height: 55,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: Color.fromARGB(41, 77, 177, 253),
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: phone,
                                  cursorColor: Colors.black,
                                  cursorRadius: const Radius.circular(10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone Number",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              margin: const EdgeInsets.only(top: 24),
                              height: 55,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: Color.fromARGB(27, 77, 177, 253),
                                        offset: Offset(0, 3)),
                                  ]),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 5),
                                child: TextField(
                                  controller: password,
                                  cursorColor: Colors.black,
                                  cursorRadius: const Radius.circular(10),
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      splashRadius: 15,
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color:
                                            const Color.fromARGB(96, 2, 56, 90),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    hintText: "Password for UVBS",
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  "By signing up you agree to our ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  tc,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Terms & Conditions ",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                  ),
                                ),
                                const Text(
                                  "and ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  pp,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                if (name.text == "" ||
                                    email.text == "" ||
                                    password.text == "") {
                                  openBottomSheet(
                                      _scaffoldKey, "Fill all the fields!");
                                } else if (!isValidEmail(email.text)) {
                                  openBottomSheet(_scaffoldKey,
                                      "Enter a valid email address!");
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                                  signupMutation(name.text, email.text,
                                          phone.text, password.text)
                                      .then((value) {
                                    if (value.hasException) {
                                      setState(() {
                                        loading = false;
                                      });
                                      print(value
                                          .exception!.graphqlErrors[0].message);
                                      openBottomSheet(
                                          _scaffoldKey,
                                          value.exception!.graphqlErrors[0]
                                              .message);
                                    }
                                    if (value.data != null) {
                                      setState(() {
                                        loading = false;
                                      });
                                      var user = value.data?['signup'];

                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .setUser(user);
                                      Navigator.of(context).pushNamed("/home");
                                    } else if (value.data == null) {
                                      openBottomSheet(
                                          _scaffoldKeyLogin,
                                          value.exception!.graphqlErrors[0]
                                              .message);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                width: 200,
                                height: 50,
                                margin: const EdgeInsets.only(top: 30),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 6, 151, 248),
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 30,
                                        color: Color.fromARGB(108, 6, 147, 255),
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? "),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        screen = 2;
                                      });
                                    },
                                    child: const Text(
                                      "Log In ",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 46, 175, 255)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  loading
                      ? Center(
                          child: SizedBox.expand(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: const Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ]),
              )
            : Scaffold(
                key: _scaffoldKeyLogin,
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.only(bottom: 100),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 251, 253, 255)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "lib/assets/images/login.png",
                                    width: 200,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    margin: const EdgeInsets.only(top: 40),
                                    height: 55,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 20,
                                              color: Color.fromARGB(
                                                  27, 77, 177, 253),
                                              offset: Offset(0, 3)),
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: TextField(
                                        controller: email,
                                        cursorColor: Colors.black,
                                        cursorRadius: const Radius.circular(10),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 206, 206, 206),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    margin: const EdgeInsets.only(top: 24),
                                    height: 55,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 20,
                                              color: Color.fromARGB(
                                                  27, 77, 177, 253),
                                              offset: Offset(0, 3)),
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 5),
                                      child: TextField(
                                        controller: password,
                                        cursorColor: Colors.black,
                                        cursorRadius: const Radius.circular(10),
                                        obscureText: !_passwordVisible,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            splashRadius: 15,
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: const Color.fromARGB(
                                                  96, 2, 56, 90),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          ),
                                          hintText: "Password",
                                          hintStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 206, 206, 206),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (email.text == "" ||
                                          password.text == "") {
                                        openBottomSheet(_scaffoldKeyLogin,
                                            "Fill all the fields!");
                                      } else if (!isValidEmail(email.text)) {
                                        openBottomSheet(_scaffoldKeyLogin,
                                            "Enter a valid email address!");
                                      } else {
                                        setState(() {
                                          loading = true;
                                        });
                                        loginMutation(email.text, password.text)
                                            .then((value) {
                                          if (value.hasException) {
                                            setState(() {
                                              loading = false;
                                            });
                                            openBottomSheet(
                                                _scaffoldKeyLogin,
                                                value.exception!
                                                    .graphqlErrors[0].message);
                                          } else if (value.data != null) {
                                            setState(() {
                                              loading = false;
                                            });
                                            Map<String, dynamic> user =
                                                value.data!['login'];

                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .setUser(user);

                                            var prefUser =
                                                prefs.getString('user');
                                            if (prefUser!.isNotEmpty) {
                                              Navigator.of(context)
                                                  .pushNamed("/home");
                                            }
                                          } else if (value.data == null) {
                                            openBottomSheet(
                                                _scaffoldKeyLogin,
                                                value.exception!
                                                    .graphqlErrors[0].message);
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      margin: const EdgeInsets.only(top: 30),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 6, 163, 248),
                                        borderRadius: BorderRadius.circular(60),
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 30,
                                              color: Color.fromARGB(
                                                  108, 6, 147, 255),
                                              offset: Offset(0, 3)),
                                        ],
                                      ),
                                      child: const Text(
                                        "Log In",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Create an account? "),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              screen = 1;
                                            });
                                          },
                                          child: const Text(
                                            "Sign Up ",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 7, 160, 255)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading
                        ? Center(
                            child: SizedBox.expand(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: const Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              );
  }
}
