import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/components/widgets/input.dart';
import 'package:uvbs/graphql/mutations/order.dart';
import 'package:uvbs/providers/userProvider.dart';

class MyShipping extends StatefulWidget {
  const MyShipping({super.key});

  @override
  State<MyShipping> createState() => _MyShippingState();
}

class _MyShippingState extends State<MyShipping> {
  String line1 = '', line2 = '', city = '', state = '', country = '';
  int zip = 0;
  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserProvider>(context, listen: false).user;
    line1 = user?['shipping']?['line1'] ?? "";
    line2 = user?['shipping']?['line2'] ?? "";
    city = user?['shipping']?['city'] ?? "";
    state = user?['shipping']?['state'] ?? "";
    country = user?['shipping']?['country'] ?? "";
    zip = user?['shipping']?['zip'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;

    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>();

    PersistentBottomSheetController openBottomSheet(String msg) {
      return scaffoldKey.currentState!.showBottomSheet(
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
      backgroundColor: const Color.fromARGB(255, 250, 254, 255),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 30, top: 70),
            width: MediaQuery.of(context).size.width - 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 220, 239, 255),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Color.fromARGB(255, 48, 138, 255),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Shipping Address",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Input(
                              value: line1,
                              placeholder: "Address Line 1",
                              labelText: line1,
                              textInputType: TextInputType.text,
                              onChange: (value) => setState(
                                    () {
                                      line1 = value;
                                    },
                                  )),
                          Input(
                              value: line2,
                              placeholder: "Address Line 2",
                              labelText: line2,
                              textInputType: TextInputType.text,
                              onChange: (value) => setState(
                                    () {
                                      line2 = value;
                                    },
                                  )),
                          Input(
                              value: city,
                              placeholder: "City",
                              labelText: city,
                              textInputType: TextInputType.text,
                              onChange: (value) => setState(
                                    () {
                                      city = value;
                                    },
                                  )),
                          Input(
                              value: state,
                              placeholder: "State",
                              labelText: state,
                              textInputType: TextInputType.text,
                              onChange: (value) => setState(
                                    () {
                                      state = value;
                                    },
                                  )),
                          Input(
                              value: country,
                              placeholder: "Country",
                              labelText: country,
                              textInputType: TextInputType.text,
                              onChange: (value) => setState(
                                    () {
                                      country = value;
                                    },
                                  )),
                          Input(
                              value: zip.toString(),
                              placeholder: "Zip code",
                              labelText: zip.toString(),
                              textInputType: TextInputType.number,
                              onChange: (value) => setState(
                                    () {
                                      zip = int.parse(value);
                                    },
                                  )),
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
                                                  104, 33, 149, 243),
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
                                      openBottomSheet("Fill all the Fields!");
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

                                        Navigator.pop(context);
                                      }

                                      if (value.data == null) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    });
                                  },
                                )
                              : const CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        error
            ? Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 255, 249, 248),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 10,
                              color: Color.fromARGB(182, 255, 227, 227),
                              offset: Offset(2, 4))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "Fill all the fields",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                            onPressed: () => setState(() {
                                  error = false;
                                }),
                            color: Colors.red,
                            iconSize: 30,
                            icon: const Icon(Icons.cancel_rounded))
                      ],
                    )),
              )
            : const SizedBox(),
      ]),
    );
  }
}
