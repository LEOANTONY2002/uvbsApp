import 'package:flutter/material.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/queries/video.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousVideos extends StatefulWidget {
  const PreviousVideos({super.key});

  @override
  State<PreviousVideos> createState() => _PreviousVideosState();
}

class _PreviousVideosState extends State<PreviousVideos> {
  bool loading = false;
  bool error = false;
  List videos = [];

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
      getAllPreviousVideosMutation().then((value) {
        if (value.hasException) {
          setState(() {
            loading = false;
          });
        }

        if (value.data != null) {
          setState(() {
            loading = false;
          });
          videos = value.data?['allPreviousVideos'];
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

    Future<void> _launchUrl(String url) async {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        openModelBottemSheet("Could not open");
      }
    }

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
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 30,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Icon(
                                                Icons
                                                    .arrow_back_ios_new_rounded,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              "Previous Youtube Videos",
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
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
                                                        (video) =>
                                                            GestureDetector(
                                                          onTap: () =>
                                                              _launchUrl(video?[
                                                                  'url']),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2 -
                                                                20,
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        200),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          40),
                                                                  child:
                                                                      Material(
                                                                    elevation:
                                                                        10,
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            100)),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          35,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: const BoxDecoration(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              23,
                                                                              42),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(100))),
                                                                      child:
                                                                          Text(
                                                                        video['year'].toString() ??
                                                                            "",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              50),
                                                                    ),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          blurRadius:
                                                                              30,
                                                                          color: Color.fromARGB(
                                                                              60,
                                                                              0,
                                                                              48,
                                                                              95))
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              50),
                                                                    ),
                                                                    child: Image
                                                                        .network(
                                                                      video['thumbnail'] ??
                                                                          "",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          150,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                blurRadius: 10,
                                                                                color: Color.fromARGB(21, 0, 48, 95),
                                                                                offset: Offset(4, 8)),
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width /
                                                                                2 -
                                                                            50,
                                                                        child:
                                                                            Text(
                                                                          video['title'] ??
                                                                              '',
                                                                          style:
                                                                              const TextStyle(overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
