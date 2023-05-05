import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/order.dart';
import 'package:uvbs/providers/userProvider.dart';

class Shipping extends StatefulWidget {
  const Shipping({super.key});

  @override
  State<Shipping> createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  final _formKey = GlobalKey<FormState>();
  String line1 = '', line2 = '', city = '', state = '', country = '';
  int zip = 0;
  bool loading = false;
  bool error = false;

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
      backgroundColor: AppColor.background,
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 30, top: 70),
            width: MediaQuery.of(context).size.width - 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Shipping Address",
                  style: TextStyle(fontSize: 27),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                      color: Color.fromARGB(27, 77, 177, 253),
                                      offset: Offset(0, 3)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                cursorColor: Colors.black,
                                cursorRadius: const Radius.circular(10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address line 1",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 206, 206, 206),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                onChanged: (value) => setState(() {
                                  line1 = value;
                                }),
                              ),
                            ),
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
                                      color: Color.fromARGB(27, 77, 177, 253),
                                      offset: Offset(0, 3)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                cursorColor: Colors.black,
                                cursorRadius: const Radius.circular(10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address line 2",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 206, 206, 206),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                onChanged: (value) => setState(() {
                                  line2 = value;
                                }),
                              ),
                            ),
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
                                      color: Color.fromARGB(27, 77, 177, 253),
                                      offset: Offset(0, 3)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                cursorColor: Colors.black,
                                cursorRadius: const Radius.circular(10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "City",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 206, 206, 206),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                onChanged: (value) => setState(() {
                                  city = value;
                                }),
                              ),
                            ),
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
                                      color: Color.fromARGB(27, 77, 177, 253),
                                      offset: Offset(0, 3)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                cursorColor: Colors.black,
                                cursorRadius: const Radius.circular(10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "State",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 206, 206, 206),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                onChanged: (value) => setState(() {
                                  state = value;
                                }),
                              ),
                            ),
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
                                      color: Color.fromARGB(27, 77, 177, 253),
                                      offset: Offset(0, 3)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                cursorColor: Colors.black,
                                cursorRadius: const Radius.circular(10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Country",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 206, 206, 206),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                onChanged: (value) => setState(() {
                                  country = value;
                                }),
                              ),
                            ),
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
                                      color: Color.fromARGB(27, 77, 177, 253),
                                      offset: Offset(0, 3)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                cursorColor: Colors.black,
                                cursorRadius: const Radius.circular(10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Zip code",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 206, 206, 206),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(() {
                                  zip = int.parse(value);
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
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
                                                  154, 33, 149, 243),
                                              blurRadius: 30,
                                              blurStyle: BlurStyle.normal),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(50))),
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  onTap: () {
                                    if (line1 == "" ||
                                        line2 == "" ||
                                        city == "" ||
                                        state == "" ||
                                        country == "" ||
                                        zip == 0) {
                                      openBottomSheet("Fill all the fields!");
                                    }
                                    setState(() {
                                      loading = true;
                                    });
                                    upsertShippingMutation(user?['id'], line1,
                                            line2, city, state, country, zip)
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
                                            value.data?['upsertShipping'];

                                        setState(() {
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .setUser(updatedUser);
                                        });

                                        Navigator.pushNamed(
                                            context, '/checkout');
                                      }

                                      if (value.data == null) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    });
                                  },
                                )
                              : CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
