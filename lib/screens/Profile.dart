import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/graphql/mutations/user.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:uvbs/models/error.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool edit = false;
  bool loading = false;
  Error error = Error(open: false, msg: "");
  String name = "";
  String email = "";
  String phone = "";
  String password = "";

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserProvider>(context, listen: false).user;
    setState(() {
      name = user?['name'] ?? "";
      email = user?['email'] ?? "";
      phone = user?['phone'] ?? "";
      password = user?['password'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    PersistentBottomSheetController openBottomSheet(String msg) {
      return _scaffoldKey.currentState!.showBottomSheet(
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topLeft,
              color: Color.fromARGB(255, 2, 37, 65),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(60, 246, 251, 255),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color.fromARGB(250, 229, 247, 255),
                      ),
                    ),
                  ),
                  const Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 231, 248, 255)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 100),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 30,
                        color: Color.fromARGB(57, 0, 46, 72),
                        blurStyle: BlurStyle.outer),
                  ],
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(100))),
              child: Column(children: [
                const SizedBox(
                  height: 30,
                ),
                Stack(alignment: Alignment.center, children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(233, 245, 255, 1),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Color.fromRGBO(64, 166, 255, 0.18),
                              blurStyle: BlurStyle.outer),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 188, 229, 255),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Color.fromRGBO(127, 208, 255, 0.565),
                              blurStyle: BlurStyle.outer),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 157, 255),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: Color.fromARGB(181, 1, 161, 254),
                              blurStyle: BlurStyle.outer),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Color.fromARGB(255, 240, 249, 255),
                      size: 40,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  user?['name'] ?? "",
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  user?['email'] ?? "",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 181, 222, 255)),
                ),
                Container(
                  height: 70,
                  width: 2,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color.fromARGB(0, 247, 253, 255),
                        Colors.blue
                      ])),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    edit = true;
                  }),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 157, 255),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: Color.fromARGB(97, 1, 161, 254),
                              blurStyle: BlurStyle.outer),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/shipping"),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 242, 250, 255),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Color.fromARGB(31, 198, 234, 255),
                                blurStyle: BlurStyle.outer),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(252, 220, 243, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: const Icon(
                                Icons.local_shipping_rounded,
                                size: 18,
                                color: Color.fromARGB(248, 4, 175, 249),
                              ),
                            ),
                            const Text(
                              "Shipping Address",
                              style: TextStyle(color: Colors.blue),
                            ),
                            const Expanded(child: SizedBox()),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color.fromARGB(249, 3, 144, 253),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/orders"),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 242, 250, 255),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Color.fromARGB(31, 198, 234, 255),
                                blurStyle: BlurStyle.outer),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(252, 220, 243, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: const Icon(
                                Icons.shopping_cart_rounded,
                                size: 18,
                                color: Color.fromARGB(248, 4, 175, 249),
                              ),
                            ),
                            const Text(
                              "My Orders",
                              style: TextStyle(color: Colors.blue),
                            ),
                            const Expanded(child: SizedBox()),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color.fromARGB(249, 3, 144, 253),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Provider.of<UserProvider>(context, listen: false)
                              .clearUser();
                          Navigator.pushNamed(context, "/home");
                        },
                        child: Container(
                          width: 130,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 242, 242),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Color.fromARGB(31, 198, 234, 255),
                                  blurStyle: BlurStyle.outer),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ]),
            ),
            edit
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 500,
                            padding: const EdgeInsets.all(30),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 249, 252, 255),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 30,
                                      color: Color.fromARGB(138, 177, 226, 255),
                                      blurStyle: BlurStyle.outer),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  color: Color.fromARGB(
                                                      218, 201, 235, 255),
                                                  blurStyle: BlurStyle.outer),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text("Edit Profile"),
                                      ],
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 235, 246, 255),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Color.fromARGB(
                                                    218, 201, 235, 255),
                                                blurStyle: BlurStyle.outer),
                                          ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () => setState(() {
                                            name = user?['name'] ?? "";
                                            email = user?['email'] ?? "";
                                            phone = user?['phone'] ?? "";
                                            password = user?['password'] ?? "";
                                            loading = false;
                                            edit = false;
                                          }),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.blue,
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 55,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 20,
                                            color: Color.fromARGB(
                                                27, 77, 177, 253),
                                            offset: Offset(0, 3)),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextFormField(
                                      initialValue: name,
                                      cursorColor: Colors.black,
                                      cursorRadius: const Radius.circular(10),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "Name",
                                        hintText: "Name",
                                        hintStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      onChanged: (value) => setState(() {
                                        name = value;
                                      }),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 55,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 20,
                                            color: Color.fromARGB(
                                                27, 77, 177, 253),
                                            offset: Offset(0, 3)),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextFormField(
                                      initialValue: phone,
                                      cursorColor: Colors.black,
                                      cursorRadius: const Radius.circular(10),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Phone Number",
                                        labelText: "Phone Number",
                                        hintStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      onChanged: (value) => setState(() {
                                        phone = value;
                                      }),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 55,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 20,
                                            color: Color.fromARGB(
                                                27, 77, 177, 253),
                                            offset: Offset(0, 3)),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextFormField(
                                      initialValue: password,
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
                                                Color.fromARGB(96, 2, 56, 90),
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                        labelText: "Password",
                                        hintText: "Password",
                                        hintStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      onChanged: (value) => setState(() {
                                        password = value;
                                      }),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                error.open
                                    ? Text(
                                        error.msg,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : const SizedBox(
                                        height: 10,
                                      ),
                                !loading
                                    ? GestureDetector(
                                        child: Container(
                                          width: 150,
                                          height: 55,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        102, 33, 149, 243),
                                                    blurRadius: 30,
                                                    blurStyle:
                                                        BlurStyle.normal),
                                              ],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(50))),
                                          child: const Text(
                                            "Submit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            error.open = false;
                                          });

                                          if (name == "" ||
                                              email == "" ||
                                              phone == "" ||
                                              password == "") {
                                            openBottomSheet(
                                                "Fill all the fields!");
                                          } else {
                                            setState(() {
                                              loading = true;
                                            });
                                            updateUserMutation(
                                                    user?['id'],
                                                    name,
                                                    email,
                                                    phone,
                                                    password)
                                                .then((value) {
                                              if (value.hasException) {
                                                setState(() {
                                                  loading = false;
                                                });
                                              }

                                              if (value.data != null) {
                                                setState(() {
                                                  loading = false;
                                                });

                                                var updatedUser =
                                                    value.data?['updateUser'];

                                                setState(() {
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .setUser(updatedUser);
                                                  edit = false;
                                                });
                                              }

                                              if (value.data == null) {
                                                setState(() {
                                                  loading = false;
                                                });
                                              }
                                            });
                                          }
                                        },
                                      )
                                    : const CircularProgressIndicator(),
                              ],
                            )),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
