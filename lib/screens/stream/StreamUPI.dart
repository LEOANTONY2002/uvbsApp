import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/user.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:uvbs/screens/stream/Audios.dart';
import 'package:uvbs/screens/stream/Favs.dart';
import 'package:uvbs/screens/stream/Playlist.dart';
import 'package:uvbs/screens/stream/Videos.dart';

class StreamUPI extends StatefulWidget {
  const StreamUPI({super.key});

  @override
  State<StreamUPI> createState() => _StreamUPIState();
}

class _StreamUPIState extends State<StreamUPI> {
  int index = 0;
  bool loading = false;
  bool isSubscribed = false;
  bool isPaid = false;
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
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    isSubscribed = user?['isSubscribed'];
    isPaid = user?['isPaid'] ?? false;

    var asset = Provider.of<AppProvider>(context).asset;
    String upi = asset?['upi'] ?? "";
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    Future<void> updatePayment() async {
      setState(() {
        loading = true;
      });
      await updateUserPaymentConfirmationMutation(user?['id']).then((value) {
        if (value.hasException) {
          setState(() {
            loading = false;
          });

          // openBottomSheet(value.exception!.graphqlErrors[0].message);
        }
        if (value.data != null) {
          setState(() {
            loading = false;
            Provider.of<UserProvider>(context, listen: false)
                .setUser(value.data!['updateUserPaymentConfirmation']);
            Navigator.pop(context);
          });
        }
      });
    }

    openModelBottemSheet() {
      showModalBottomSheet(
          context: context,
          backgroundColor: const Color.fromARGB(0, 1, 47, 83),
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(248, 0, 37, 50),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: const Text(
                              "Payment",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.clip),
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
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Make your payment to the below UPI and confirm your payment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(248, 201, 241, 255)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(38, 252, 254, 255),
                        ),
                        child: Text(
                          upi,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(248, 255, 255, 255),
                          ),
                        ),
                      ),
                      loading
                          ? const Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 202, 231, 255),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  loading = true;
                                });
                                updatePayment().then((value) => {
                                      setState(() {
                                        loading = false;
                                      }),
                                    });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(30),
                                child: Material(
                                  elevation: 10,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(150)),
                                  child: Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 1, 191, 255),
                                              Color.fromARGB(255, 0, 145, 236)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              color:
                                                  Color.fromARGB(53, 0, 0, 0),
                                              offset: Offset(2, 4))
                                        ]),
                                    child: const Text(
                                      "Payment Completed",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 246, 252, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const Text(
                        "Your subscription will start after the Admin's approval",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(248, 201, 241, 255)),
                      ),
                    ],
                  ));
            });
          });
    }

    return !isSubscribed
        ? !isPaid
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
                                    openModelBottemSheet();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: Container(
                                        width: 200,
                                        height: 55,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 0, 23, 42),
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
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40),
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
                backgroundColor: AppColor.background,
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(200)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(1, 79, 147, 1),
                              Color.fromRGBO(0, 22, 41, 1),
                            ]),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              image: AssetImage(
                                  "lib/assets/images/thank_you.png")),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Payment verification in progress",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Please come again later",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(118, 4, 142, 240)),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 2,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(0, 1, 41, 54),
                            Color.fromARGB(255, 0, 27, 49)
                          ])),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/home"),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 64, 104),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  color: Color.fromARGB(102, 3, 51, 80),
                                  blurStyle: BlurStyle.outer),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
