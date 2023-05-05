import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/components/stream/videoCard.dart';
import 'package:uvbs/graphql/queries/video.dart';
import 'package:uvbs/providers/provider.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  bool loading = false;
  bool error = false;

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
      getAllVideosMutation().then((value) {
        if (value.hasException) {
          setState(() {
            loading = false;
          });
        }

        if (value.data != null) {
          setState(() {
            loading = false;
          });
          var allVideos = value.data?['allVideos'];

          Provider.of<AppProvider>(context, listen: false)
              .addAllVideo(allVideos);
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
    List? videos =
        Provider.of<AppProvider>(context, listen: false).videos ?? [];
    videos.isNotEmpty
        ? videos
            .sort((a, b) => b?['likes']?.length?.compareTo(a?['likes'].length))
        : "";
    var featuredVideo = videos.isNotEmpty ? videos[0] : "";

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
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
              : !error
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: AppColor.background),
                      child: videos.isNotEmpty
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Column(
                                children: [
                                  featuredVideo != ""
                                      ? Stack(
                                          children: [
                                            Image.network(
                                              featuredVideo?['thumbnail'],
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
                                                      "Most Liked",
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
                                                    featuredVideo['title'],
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    featuredVideo[
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
                                                              .updateVideo(
                                                                  featuredVideo?[
                                                                      'id']);
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/video");
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
                                                                  "Watch Now"),
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
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 30,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "Videos",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                              children: videos.isEmpty
                                                  ? List.empty()
                                                  : videos
                                                      .map<Widget>(
                                                        (v) => GestureDetector(
                                                          onTap: () {
                                                            Provider.of<AppProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .updateVideo(
                                                                    v?['id']);
                                                            Navigator.pushNamed(
                                                                context,
                                                                "/video");
                                                          },
                                                          child: VideoCard(
                                                            video: v,
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
                              alignment: Alignment.center,
                              child: const Text("No videos found!"),
                            ))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: const Text(
                        "Something went wrong!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 164, 214, 255)),
                      ),
                    )),
    );
  }
}
