import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/user.dart';
import 'package:uvbs/graphql/queries/asset.dart';
import 'package:uvbs/prefs.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool loading = false;
  bool error = false;
  String msg = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      error = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        loading = true;
      });
      var user = prefs.getString('user');
      if (user == null) {
        Navigator.of(context).pushNamed("/login");
      } else {
        Map<String, dynamic>? user =
            Provider.of<UserProvider>(context, listen: false).user;
        String email = user?['email'] ?? "";
        String password = user?['password'] ?? "";
        setState(() {
          loading = true;
          error = false;
          msg = "";
        });
        loginMutation(email, password).then((value) {
          if (value.hasException) {
            setState(() {
              loading = false;
              error = true;
              msg = "Something went wrong";
            });
          } else if (value.data != null) {
            setState(() {
              loading = false;
            });
            Map<String, dynamic> updatedUser = value.data?['login'];

            Provider.of<UserProvider>(context, listen: false)
                .setUser(updatedUser);

            getAllAssetsMutation().then((value) {
              if (value.hasException) {
                setState(() {
                  loading = false;
                });
              }

              if (value.data != null) {
                var allAssets = value.data?['allAssets'];
                setState(() {
                  Provider.of<AppProvider>(context, listen: false)
                      .addAsset(allAssets[0]);
                });
                setState(() {
                  loading = false;
                });
              }

              if (value.data == null) {
                setState(() {
                  loading = false;
                  error = true;
                });
              }
            });
          }
        });
      }
    });
  }

  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = Provider.of<UserProvider>(context).user;
    dynamic asset = Provider.of<AppProvider>(context).asset;
    String name = user?['name'] ?? '';
    String themeTitle = asset?['themeTitle'] ?? "";
    String themeDescription = asset?['themeDescription'] ?? "";
    String themePhoto = asset?['themePhoto'] ?? "";
    bool isPaymentOnline = asset?['isPaymentOnline'] ?? false;

    List contents = [
      {
        "id": 1,
        "title": themeTitle,
        "description": themeDescription,
        "image": themePhoto,
        "btn_icon": "lib/assets/images/home_vid_icon.png",
        "btn_text": "Watch Now",
        "link": isPaymentOnline ? "/streamStripe" : "/streamUPI"
      },
      {
        "id": 2,
        "title": "Previous Videos",
        "description": "UVBS previous videos",
        "image": "lib/assets/images/home_vid_svg.png",
        "btn_icon": "lib/assets/images/home_vid_icon.png",
        "btn_text": "Watch Now",
        "link": "/previous"
      },
      {
        "id": 3,
        "title": "Shop",
        "description": "UVBS products",
        "image": "lib/assets/images/home_ecom_svg.png",
        "btn_icon": "lib/assets/images/home_cart_icon.png",
        "btn_text": "Shop Now",
        "link": "/ecom"
      }
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 249, 253, 255),
        ),
        child: !error
            ? SingleChildScrollView(
                child: loading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: AppColor.gradientFirst,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(120, 80),
                              bottomRight: Radius.elliptical(120, 80),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 30, 173, 255),
                                Color.fromARGB(255, 1, 127, 210)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(116, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.elliptical(300, 60),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "hi",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            name,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                color: Color.fromARGB(
                                                    255, 1, 50, 68),
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Provider.of<UserProvider>(context,
                                            //         listen: false)
                                            //     .clearUser();
                                            Navigator.pushNamed(
                                                context, "/profile");
                                          });
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  154, 20, 153, 241),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                              border: Border.all(
                                                  width: 3,
                                                  color: Colors.white)),
                                          child: const Icon(
                                            Icons.person,
                                            color: Color.fromARGB(
                                                234, 149, 213, 255),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              CarouselSlider(
                                  items: contents
                                      .map(
                                        (c) => Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(c?['link']),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 0,
                                                    top: 20,
                                                    bottom: 20),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 475,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              32, 2, 83, 141),
                                                          offset: Offset(3, 7),
                                                          blurRadius: 30)
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 40),
                                                        child: SizedBox(
                                                          width: 250,
                                                          height: 250,
                                                          child: c['image']!
                                                                      .toString() ==
                                                                  ""
                                                              ? Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          80),
                                                                  child:
                                                                      const CircularProgressIndicator(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            1,
                                                                            145,
                                                                            255),
                                                                  ),
                                                                )
                                                              : c['image']!
                                                                      .toString()
                                                                      .startsWith(
                                                                          "http")
                                                                  ? Image
                                                                      .network(
                                                                      c['image'],
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      width:
                                                                          250,
                                                                      height:
                                                                          250,
                                                                    )
                                                                  : Image.asset(
                                                                      c['image'],
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      width:
                                                                          250,
                                                                      height:
                                                                          250,
                                                                    ),
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 30),
                                                      child: Text(
                                                        c['title'],
                                                        style: const TextStyle(
                                                            fontSize: 26,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15),
                                                      child: Text(
                                                        c['description'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: Color.fromARGB(
                                                              183,
                                                              158,
                                                              158,
                                                              158),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 25,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed(c?['link']),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            20, 1, 40, 76),
                                                        offset: Offset(0, 0),
                                                        blurRadius: 25,
                                                        blurStyle:
                                                            BlurStyle.outer,
                                                      )
                                                    ],
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                  child: BlurryContainer(
                                                      blur: 5,
                                                      height: 65,
                                                      padding: EdgeInsets.all(
                                                          currentIndex == 0
                                                              ? 5
                                                              : 12),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  50)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            c['btn_icon'],
                                                            width: 50,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          GradientText(
                                                            c['btn_text'] ?? "",
                                                            gradientDirection:
                                                                GradientDirection
                                                                    .btt,
                                                            colors: const [
                                                              Color.fromARGB(
                                                                  255,
                                                                  1,
                                                                  36,
                                                                  56),
                                                              Color.fromARGB(
                                                                  255,
                                                                  0,
                                                                  153,
                                                                  255)
                                                            ],
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                  carouselController: carouselController,
                                  options: CarouselOptions(
                                      height: 550,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      scrollPhysics: const PageScrollPhysics(),
                                      initialPage: currentIndex,
                                      onPageChanged: ((index, reason) {
                                        setState(() {
                                          currentIndex = index;
                                        });
                                      }))),
                              const SizedBox(
                                height: 30,
                              ),
                              SmoothPageIndicator(
                                controller:
                                    PageController(initialPage: currentIndex),
                                effect: const ExpandingDotsEffect(
                                    activeDotColor:
                                        Color.fromARGB(255, 0, 40, 76),
                                    dotColor:
                                        Color.fromARGB(255, 122, 202, 255)),
                                count: contents.length,
                              )
                            ],
                          ),
                        ),
                      ]),
              )
            : SingleChildScrollView(
                child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: const Text(
                  "Something went wrong!",
                  style: TextStyle(color: Color.fromARGB(255, 164, 214, 255)),
                ),
              )),
      ),
    );
  }
}
