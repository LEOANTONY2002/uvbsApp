import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/components/stream/videoCard.dart';
import 'package:uvbs/graphql/queries/audio.dart';
import 'package:uvbs/providers/provider.dart';

class Audios extends StatefulWidget {
  const Audios({super.key});

  @override
  State<Audios> createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  bool loading = false;
  bool error = false;
  int catIndex = 0;
  late Iterable filterAudios;

  @override
  void initState() {
    super.initState();

    setState(() {
      error = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        error = false;
        loading = true;
      });
      getAllAudiosMutation().then((value) {
        if (value.hasException) {
          setState(() {
            loading = false;
          });
        }

        if (value.data != null) {
          setState(() {
            loading = false;
          });
          var allAudios = value.data?['allAudios'];

          Provider.of<AppProvider>(context, listen: false)
              .addAllAudio(allAudios);
        }

        if (value.data == null) {
          setState(() {
            error = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List? audios =
        Provider.of<AppProvider>(context, listen: false).audios ?? [];
    var featuredAudio = audios.isNotEmpty
        ? audios[Random().nextInt(audios.length == 1 ? 1 : audios.length - 1)]
        : "";

    if (catIndex == 0) {
      filterAudios = audios;
    }
    if (catIndex == 1) {
      filterAudios =
          audios.where((a) => a?['language'] == "TAMIL" && a?['song'] == true);
    }
    if (catIndex == 2) {
      filterAudios =
          audios.where((a) => a?['language'] == "HINDI" && a?['song'] == true);
    }

    if (catIndex == 3) {
      filterAudios = audios.where((a) => a?['song'] == false);
    }

    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: !error
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: AppColor.background),
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
                      : audios.isNotEmpty
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Column(
                                children: [
                                  featuredAudio != ""
                                      ? Stack(
                                          children: [
                                            Image.network(
                                              featuredAudio?['thumbnail'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 400,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 400,
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.all(30),
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Color.fromARGB(
                                                        111, 248, 252, 255),
                                                    Color.fromARGB(
                                                        209, 244, 249, 254),
                                                    Color.fromARGB(
                                                        255, 244, 249, 254)
                                                  ],
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    156,
                                                                    33,
                                                                    149,
                                                                    243)),
                                                    child: const Text(
                                                      "Random Pick",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Text(
                                                    featuredAudio['title'],
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    featuredAudio[
                                                        'description'],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        color: Color.fromARGB(
                                                            153, 0, 0, 0)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Provider.of<AppProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .updateAudio(
                                                                  featuredAudio);
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/audio");
                                                        },
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 20,
                                                                      left: 60),
                                                              // width:
                                                              //     MediaQuery.of(context)
                                                              //                 .size
                                                              //                 .width /
                                                              //             2 -
                                                              //         60,
                                                              height: 50,
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        64,
                                                                        123,
                                                                        215,
                                                                        255),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          50),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Color.fromARGB(
                                                                          37,
                                                                          84,
                                                                          192,
                                                                          255),
                                                                      blurRadius:
                                                                          30,
                                                                      blurStyle:
                                                                          BlurStyle
                                                                              .outer)
                                                                ],
                                                              ),
                                                              child: const Text(
                                                                  "Play Now"),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            100),
                                                                      ),
                                                                      boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color.fromARGB(
                                                                          40,
                                                                          28,
                                                                          183,
                                                                          255),
                                                                      blurRadius:
                                                                          30,
                                                                    )
                                                                  ]),
                                                              child: const Icon(
                                                                Icons
                                                                    .play_arrow_rounded,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30,
                                                                shadows: [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          20,
                                                                      color: Color.fromARGB(
                                                                          122,
                                                                          22,
                                                                          181,
                                                                          255),
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              2))
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 30,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            catIndex == 0
                                                ? "All Songs"
                                                : catIndex == 1
                                                    ? "Tamil Songs"
                                                    : "Hindi Songs",
                                            style:
                                                const TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                catIndex = 0;
                                              }),
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15, bottom: 30),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 12),
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 250),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(100),
                                                      color: catIndex == 0
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 1, 58, 87)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              87, 199, 255),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            blurRadius: 20,
                                                            color:
                                                                Color.fromARGB(
                                                                    125,
                                                                    81,
                                                                    185,
                                                                    255),
                                                            offset:
                                                                Offset(2, 4))
                                                      ]),
                                                  child: const Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255)),
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                catIndex = 1;
                                              }),
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15, bottom: 30),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 250),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      color: catIndex == 1
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 1, 58, 87)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              87, 199, 255),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            blurRadius: 20,
                                                            color:
                                                                Color.fromARGB(
                                                                    125,
                                                                    81,
                                                                    185,
                                                                    255),
                                                            offset:
                                                                Offset(2, 4))
                                                      ]),
                                                  child: const Text(
                                                    "Tamil",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255)),
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                catIndex = 2;
                                              }),
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15, bottom: 30),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 250),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      color: catIndex == 2
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 1, 58, 87)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              87, 199, 255),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            blurRadius: 20,
                                                            color:
                                                                Color.fromARGB(
                                                                    125,
                                                                    81,
                                                                    185,
                                                                    255),
                                                            offset:
                                                                Offset(2, 4))
                                                      ]),
                                                  child: const Text(
                                                    "Hindi",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255)),
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                catIndex = 3;
                                              }),
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15, bottom: 30),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 250),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      color: catIndex == 3
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 1, 58, 87)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              87, 199, 255),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            blurRadius: 20,
                                                            color:
                                                                Color.fromARGB(
                                                                    125,
                                                                    81,
                                                                    185,
                                                                    255),
                                                            offset:
                                                                Offset(2, 4))
                                                      ]),
                                                  child: const Text(
                                                    "Karoke",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255)),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Wrap(
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 5,
                                              runSpacing: 20,
                                              children: filterAudios.isEmpty
                                                  ? List.empty()
                                                  : filterAudios
                                                      .map<Widget>(
                                                        (a) => GestureDetector(
                                                          onTap: () {
                                                            Provider.of<AppProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .updateAudio(a);
                                                            Navigator.pushNamed(
                                                                context,
                                                                "/audio");
                                                          },
                                                          child: VideoCard(
                                                            video: a,
                                                          ),
                                                        ),
                                                      )
                                                      .toList()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: const Text("No videos found!"),
                            ))
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const Text(
                    "Something went wrong!",
                    style: TextStyle(color: Color.fromARGB(255, 164, 214, 255)),
                  ),
                )),
    );
  }
}
