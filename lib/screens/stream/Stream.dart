import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/graphql/mutations/order.dart';
import 'package:uvbs/graphql/mutations/user.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:uvbs/screens/stream/Audios.dart';
import 'package:uvbs/screens/stream/Favs.dart';
import 'package:uvbs/screens/stream/Playlist.dart';
import 'package:uvbs/screens/stream/Videos.dart';

class Stream extends StatefulWidget {
  const Stream({super.key});

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  int index = 0;
  bool loading = false;
  bool isSubscribed = false;
  String tempOrderId = "";

  late List<Widget> screens = [
    const Videos(),
    const Favs(),
    const Audios(),
    const Playlist()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Videos();

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    isSubscribed = user?['isSubscribed'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

    openModelBottemSheet(String msg) {
      showModalBottomSheet(
          context: context,
          backgroundColor: const Color.fromARGB(0, 1, 47, 83),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(248, 0, 37, 50),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      msg,
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.clip),
                    ),
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
            );
          });
    }

    Future<void> checkout() async {
      try {
        var paymentIndent = await generateStripePaymentIndentMutation(200);
        if (paymentIndent.hasException) {
          setState(() {
            loading = false;
            openModelBottemSheet("something went wrong!");
          });
        }
        if (paymentIndent.data != null) {
          String pid =
              paymentIndent.data?['generateStripePaymentIndent']?['id'];
          String clientSecret = paymentIndent
              .data?['generateStripePaymentIndent']?['client_secret'];

          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            applePay: Stripe.instance.isApplePaySupported.value,
            googlePay: true,
            style: ThemeMode.dark,
            testEnv: true,
            currencyCode: "INR",
            merchantCountryCode: "IN",
            customFlow: true,
            billingDetails: BillingDetails(
              email: user?['email'],
              name: user?['name'],
              phone: user?['phone'],
            ),
            merchantDisplayName: 'UVBS',
            paymentIntentClientSecret: clientSecret,
          ));

          await Stripe.instance.presentPaymentSheet();

          updateUserSubscriptionMutation(user?['id']).then((value) {
            if (value.hasException) {
              setState(() {
                loading = false;
              });
              openBottomSheet(value.exception!.graphqlErrors[0].message);
            }
            if (value.data != null) {
              setState(() {
                loading = false;
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(value.data!['updateUserSubscription']);
                isSubscribed = true;
              });
            }
          });
        }
      } catch (e) {
        setState(() {
          loading = false;
        });
        openModelBottemSheet('Payment Failed!');
      }
    }

    return !isSubscribed
        ? Scaffold(
            key: scaffoldKey,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("lib/assets/images/subs.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("You are not subscribed!"),
                  const Text(
                    "Subscribe now with just ₹200",
                    style: TextStyle(color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  loading
                      ? const CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 32, 58),
                        )
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  loading = true;
                                });

                                checkout();
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Material(
                                  elevation: 10,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: Container(
                                    width: 200,
                                    height: 55,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 0, 23, 42),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    child: const Text(
                                      "Subscribe Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  loading = false;
                                });

                                Navigator.pushNamed(context, "/home");
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  width: 200,
                                  height: 55,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(21, 0, 26, 47),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: const Text(
                                    "Go Back",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.of(context).pushNamed("/home"),
                elevation: 0,
                backgroundColor: Colors.transparent,
                splashColor: const Color.fromARGB(255, 7, 226, 255),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 4, 188, 255),
                          Color.fromARGB(255, 39, 140, 255)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 4),
                          blurRadius: 20,
                          color: Color.fromARGB(171, 1, 149, 255),
                        )
                      ]),
                  child: const Icon(
                    Icons.home_rounded,
                    size: 30,
                  ),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 15,
              elevation: 20,
              child: SizedBox(
                height: 70,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MaterialButton(
                        highlightColor: const Color.fromARGB(19, 255, 255, 255),
                        splashColor: const Color.fromARGB(155, 231, 251, 255),
                        minWidth: 10,
                        onPressed: () {
                          setState(() {
                            currentScreen = const Videos();
                            index = 0;
                          });
                        },
                        child: Icon(
                          Icons.video_collection_outlined,
                          color: index == 0 ? Colors.black : Colors.black26,
                        ),
                      ),
                      MaterialButton(
                        highlightColor: const Color.fromARGB(19, 255, 255, 255),
                        splashColor: const Color.fromARGB(155, 231, 251, 255),
                        minWidth: 10,
                        onPressed: () {
                          setState(() {
                            currentScreen = const Favs();
                            index = 1;
                          });
                        },
                        child: Icon(
                          Icons.favorite_outline_rounded,
                          color: index == 1 ? Colors.black : Colors.black26,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 90),
                        child: MaterialButton(
                          highlightColor:
                              const Color.fromARGB(19, 255, 255, 255),
                          splashColor: const Color.fromARGB(155, 231, 251, 255),
                          minWidth: 10,
                          onPressed: () {
                            setState(() {
                              currentScreen = const Audios();
                              index = 2;
                            });
                          },
                          child: Icon(
                            Icons.library_music_outlined,
                            color: index == 2 ? Colors.black : Colors.black26,
                          ),
                        ),
                      ),
                      MaterialButton(
                        highlightColor: const Color.fromARGB(19, 255, 255, 255),
                        splashColor: const Color.fromARGB(155, 231, 251, 255),
                        minWidth: 10,
                        onPressed: () {
                          setState(() {
                            currentScreen = const Playlist();
                            index = 3;
                          });
                        },
                        child: Icon(
                          Icons.playlist_add_check,
                          color: index == 3 ? Colors.black : Colors.black26,
                        ),
                      ),
                    ]),
              ),
            ),
            body: PageStorage(
              bucket: bucket,
              child: currentScreen,
            ),
          );
  }
}
