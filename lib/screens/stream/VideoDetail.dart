import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/video.dart';
import 'package:uvbs/providers/favProvider.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:uvbs/components/Error.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flick_video_player/flick_video_player.dart';
import 'package:better_player/better_player.dart';

class VideoDetail extends StatefulWidget {
  dynamic vid;
  VideoDetail({super.key, this.vid});

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  Map<String, dynamic> error = {'open': false, 'msg': ""};
  bool loading = false;
  bool liking = false;
  String comment = "";
  bool play = false;

  // late VideoPlayerController _controller;
  // late FlickManager flickManager;
  late BetterPlayerController _betterPlayerController;

  // void initPlayer() {
  //   setState(() {
  //     loading = true;
  //   });
  //   _controller = VideoPlayerController.network(
  //       Provider.of<AppProvider>(context, listen: false).video?['videoUrl'])
  //     ..initialize().then((_) {
  //       flickManager = FlickManager(videoPlayerController: _controller);
  //       setState(() {
  //         loading = false;
  //       });
  //     });
  // }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();

    // initPlayer();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Provider.of<AppProvider>(context, listen: false).video?['videoUrl'],
      videoFormat: BetterPlayerVideoFormat.other,
      // headers: {
      //   "User-Agent":
      //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0",
      //   "Content-Type": "application/vnd.apple.mpegurl"
      // },
    );

    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
            autoDispose: true,
            showPlaceholderUntilPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                controlBarColor: Color.fromARGB(39, 0, 0, 0))),
        betterPlayerDataSource: betterPlayerDataSource);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    if (_betterPlayerController.hasCurrentDataSourceStarted) {
      // _controller.dispose();
      // flickManager.dispose();
      _betterPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var video = Provider.of<AppProvider>(context, listen: false).video;
    List comments = video?['comments'];
    bool isFav = context
        .watch<FavoriteProvider>()
        .favs!
        .where((f) => f?['id'] == video?['id'])
        .isNotEmpty;
    var user = Provider.of<UserProvider>(context, listen: false).user;
    String userId = user?['id'];

    bool isLiked =
        video['likes'].where((l) => l['user']['id'] == userId).isNotEmpty;

    // flickManager = FlickManager(videoPlayerController: _controller);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 252, 255),
      body: SingleChildScrollView(
        child: !play
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(video['thumbnail'] ?? ""),
                            fit: BoxFit.cover)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        color: const Color.fromARGB(178, 1, 14, 37),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(112, 248, 252, 255),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: IconButton(
                                      onPressed: () {
                                        _betterPlayerController.dispose();
                                        Navigator.pop(context);
                                      },
                                      alignment: Alignment.center,
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 25,
                                        color: Color.fromARGB(255, 1, 53, 73),
                                      )),
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  play = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(83, 246, 251, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(121, 245, 251, 255),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                      "lib/assets/images/home_vid_icon.png",
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  width: MediaQuery.of(context).size.width - 30,
                                  child: Text(
                                    video?['title'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(video['thumbnail'] ?? ""),
                        fit: BoxFit.cover)),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: const Color.fromARGB(218, 241, 249, 255),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(112, 248, 252, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: IconButton(
                                    onPressed: () {
                                      _betterPlayerController.dispose();
                                      Navigator.pop(context);
                                    },
                                    alignment: Alignment.center,
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 25,
                                      color: Color.fromARGB(255, 1, 53, 73),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Material(
                                    elevation: 30,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      // child: FlickVideoPlayer(
                                      //     flickManager: flickManager),
                                      child: BetterPlayer(
                                          controller: _betterPlayerController),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  video?['title'],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  video?['description'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100,
                                      color: Color.fromARGB(108, 0, 0, 0)),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromARGB(
                                                  255, 222, 244, 255),
                                              Color.fromARGB(255, 255, 255, 255)
                                            ]),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(49, 1, 97, 171),
                                            blurRadius: 20,
                                            offset: Offset(3, 8),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      child: liking
                                          ? const CircularProgressIndicator()
                                          : IconButton(
                                              style: const ButtonStyle(
                                                alignment: Alignment.center,
                                              ),
                                              onPressed: isLiked
                                                  ? () {}
                                                  : () {
                                                      setState(() {
                                                        liking = true;
                                                      });

                                                      addLikeMutation(userId,
                                                              video['id'])
                                                          .then((value) {
                                                        setState(() {
                                                          liking = true;
                                                        });

                                                        if (value.data !=
                                                            null) {
                                                          setState(() {
                                                            liking = false;
                                                          });
                                                          List allVideos = value
                                                              .data?['addLike'];

                                                          setState(() {
                                                            Provider.of<AppProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addAllVideo(
                                                                    allVideos);
                                                            video['likes'].add({
                                                              'user': {
                                                                'id':
                                                                    user?['id'],
                                                                'email': user?[
                                                                    'email'],
                                                                'name': user?[
                                                                    'name']
                                                              }
                                                            });
                                                            liking = false;
                                                          });
                                                        }

                                                        if (value
                                                            .hasException) {
                                                          setState(() {
                                                            liking = false;
                                                          });
                                                        }
                                                      });
                                                    },
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                bottom: 35,
                                                top: 20,
                                                left: 20,
                                                right: 30,
                                              ),
                                              icon: Icon(
                                                isLiked
                                                    ? Icons.thumb_up_alt_rounded
                                                    : Icons
                                                        .thumb_up_alt_outlined,
                                                size: 35,
                                                color: AppColor.gradientFirst,
                                                shadows: const [
                                                  Shadow(
                                                      blurRadius: 20,
                                                      color: Color.fromARGB(
                                                          122, 22, 181, 255),
                                                      offset: Offset(1, 2))
                                                ],
                                              )),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromARGB(
                                                  255, 222, 244, 255),
                                              Color.fromARGB(255, 255, 255, 255)
                                            ]),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(48, 1, 97, 171),
                                            blurRadius: 20,
                                            offset: Offset(3, 8),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      child: IconButton(
                                          style: const ButtonStyle(
                                            alignment: Alignment.center,
                                          ),
                                          onPressed: !isFav
                                              ? () {
                                                  Provider.of<FavoriteProvider>(
                                                          context,
                                                          listen: false)
                                                      .addfav(video);
                                                }
                                              : () {
                                                  Provider.of<FavoriteProvider>(
                                                          context,
                                                          listen: false)
                                                      .removeFav(video['id']);
                                                },
                                          alignment: Alignment.center,
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite_rounded
                                                : Icons
                                                    .favorite_border_outlined,
                                            size: 35,
                                            color: AppColor.gradientFirst,
                                            shadows: const [
                                              Shadow(
                                                  blurRadius: 20,
                                                  color: Color.fromARGB(
                                                      122, 22, 181, 255),
                                                  offset: Offset(1, 2))
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(94, 248, 253, 255),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        video?['likes'].length.toString() ?? "",
                                        style: const TextStyle(
                                          fontSize: 29,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Likes",
                                        style: TextStyle(color: Colors.black26),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                      color: Colors.black12),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2 - 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        comments.length.toString(),
                                        style: const TextStyle(fontSize: 29),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Comments",
                                        style: TextStyle(color: Colors.black26),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 20,
                                      color: Color.fromARGB(31, 182, 182, 182))
                                ],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.elliptical(170, 100))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Comments",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      // Text("Your Comment"),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        // height: 75,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  45, 99, 205, 251),
                                              blurRadius: 30,
                                              blurStyle: BlurStyle.outer,
                                            ),
                                          ],
                                          color: Color.fromARGB(
                                              109, 196, 237, 255),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(13),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          // height: 55,
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    17, 0, 69, 99),
                                                blurRadius: 20,
                                                blurStyle: BlurStyle.outer,
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      comment = value;
                                                    });
                                                  },
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Type your comment...",
                                                    hintStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            225,
                                                            225,
                                                            225)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(100),
                                                        ),
                                                        borderSide:
                                                            BorderSide.none),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 212, 236, 255),
                                                        Color.fromARGB(
                                                            255, 17, 164, 255)
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          115, 0, 179, 255),
                                                      blurRadius: 10,
                                                      blurStyle:
                                                          BlurStyle.outer,
                                                    ),
                                                  ],
                                                ),
                                                child: IconButton(
                                                    onPressed: () {
                                                      if (comment == "") {
                                                        setState(() {
                                                          error['open'] = true;
                                                          error['msg'] =
                                                              "Fill the comment field!";
                                                        });
                                                      } else {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        addCommentMutation(
                                                                userId,
                                                                video?['id'],
                                                                comment)
                                                            .then((value) {
                                                          if (value
                                                              .hasException) {
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }

                                                          if (value.data !=
                                                              null) {
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                            List allVideos =
                                                                value.data?[
                                                                    'addComment'];

                                                            Provider.of<AppProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addAllVideo(
                                                                    allVideos);

                                                            setState(() {
                                                              video['comments']
                                                                  .add({
                                                                'msg': comment,
                                                                'user': {
                                                                  'name': user?[
                                                                      'name']
                                                                }
                                                              });
                                                            });
                                                          }
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.send_rounded,
                                                      color:
                                                          AppColor.background,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      loading
                                          ? const Padding(
                                              padding: EdgeInsets.all(20),
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const SizedBox(),
                                      error['open']
                                          ? Error(
                                              onChange: () {
                                                setState(() {
                                                  error['open'] = false;
                                                });
                                              },
                                              message: error['msg'],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(),
                                comments.isNotEmpty
                                    ? Container(
                                        child: Column(
                                          children: comments
                                              .map((c) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      217,
                                                                      109,
                                                                      194,
                                                                      255),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            50),
                                                                  ),
                                                                  border: Border.all(
                                                                      width: 3,
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          226,
                                                                          242,
                                                                          255))),
                                                          child: const Icon(
                                                            Icons.person,
                                                            color:
                                                                Color.fromARGB(
                                                                    234,
                                                                    225,
                                                                    241,
                                                                    252),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              c?['user']
                                                                  ['name'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          243,
                                                                          0,
                                                                          145,
                                                                          236)),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              c?['msg'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w100,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
      ),
    );
  }
}
