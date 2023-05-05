import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/graphql/mutations/user.dart';
import 'package:uvbs/prefs.dart';
import 'package:uvbs/providers/userProvider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  bool error = false;
  String msg = "";

  @override
  void initState() {
    super.initState();
    var user = prefs.getString('user');
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    } else {
      String email =
          Provider.of<UserProvider>(context, listen: false).user?['email'] ??
              "";
      String password =
          Provider.of<UserProvider>(context, listen: false).user?['password'] ??
              "";
      loginMutation(email, password).then((value) {
        setState(() {
          loading = true;
          error = false;
          msg = "";
        });
        if (value.hasException) {
          setState(() {
            loading = false;
            error = true;
            msg = value.exception!.graphqlErrors[0].message;
          });
        } else if (value.data != null) {
          setState(() {
            loading = false;
          });
          Map<String, dynamic> user = value.data!['login'];

          print(user);

          Provider.of<UserProvider>(context, listen: false).setUser(user);

          var prefUser = prefs.getString('user');
          if (prefUser!.isNotEmpty) {
            Navigator.of(context).pushNamed("/home");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? name =
        Provider.of<UserProvider>(context, listen: false).user?['name'];

    return Scaffold(
      body: loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()),
            )
          : error
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Text(
                    msg,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 12, 166, 226),
                          Color.fromARGB(255, 1, 142, 235)
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Hi",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      name != null ? name : "",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(154, 20, 153, 241),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      border: Border.all(
                                          width: 3, color: Colors.white)),
                                  child: const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(234, 149, 213, 255),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(85, 195, 236, 255),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(190))),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 22),
                              child: Expanded(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 20,
                                            color:
                                                Color.fromARGB(82, 3, 87, 151),
                                            offset: Offset(0, 3)),
                                      ],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(100))),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(22),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 223, 245, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.video_library_rounded,
                                                    color: Color.fromARGB(
                                                        255, 0, 139, 252),
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                "Themes",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            SizedBox(
                                              height: 280,
                                              child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        66,
                                                                        46,
                                                                        182,
                                                                        255),
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    2, 3))
                                                          ]),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    30)),
                                                        child: Image.asset(
                                                          "lib/assets/images/theme.jpg",
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                          height: 250,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              24, 7, 185, 255),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          30))),
                                                      child: SizedBox.fromSize(
                                                        size: const Size(
                                                            200, 250),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Explore",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            7,
                                                                            152,
                                                                            255),
                                                                    fontSize:
                                                                        33),
                                                              ),
                                                              Text(
                                                                "the bible school",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  90,
                                              height: 55,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          53, 4, 163, 255),
                                                      offset: Offset(1, 4),
                                                      blurRadius: 20,
                                                    ),
                                                  ]),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed("/stream"),
                                                child: const BlurryContainer
                                                    .expand(
                                                  blur: 15,
                                                  color: Color.fromARGB(
                                                      19, 25, 159, 255),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                  child: Center(
                                                      child: Text(
                                                    "Watch Now",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(22),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 223, 245, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    color: Color.fromARGB(
                                                        255, 0, 139, 252),
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                "Ecommerce",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            SizedBox(
                                              height: 280,
                                              child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        66,
                                                                        46,
                                                                        182,
                                                                        255),
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    2, 3))
                                                          ]),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    30)),
                                                        child: Image.asset(
                                                          "lib/assets/images/ecom.jpg",
                                                          fit: BoxFit.cover,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                          height: 250,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              24, 7, 185, 255),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          30))),
                                                      child: SizedBox.fromSize(
                                                        size: const Size(
                                                            200, 250),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Explore",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            7,
                                                                            152,
                                                                            255),
                                                                    fontSize:
                                                                        33),
                                                              ),
                                                              Text(
                                                                "the bible school",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  90,
                                              height: 55,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          53, 4, 163, 255),
                                                      offset: Offset(1, 4),
                                                      blurRadius: 20,
                                                    ),
                                                  ]),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed('/ecom'),
                                                child: const BlurryContainer
                                                    .expand(
                                                  blur: 15,
                                                  color: Color.fromARGB(
                                                      19, 25, 159, 255),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                  child: Center(
                                                      child: Text(
                                                    "Shop Now",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 100,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
