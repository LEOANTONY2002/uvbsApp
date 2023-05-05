import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/video.dart';
import 'package:uvbs/providers/favProvider.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:uvbs/components/Error.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

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

  late VideoPlayerController _controller;
  late FlickManager flickManager;

  void initPlayer() {
    setState(() {
      loading = true;
    });
    _controller = VideoPlayerController.network(
        Provider.of<AppProvider>(context, listen: false).video?['videoUrl'])
      ..initialize().then((_) {
        flickManager = FlickManager(videoPlayerController: _controller);
        setState(() {
          loading = false;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    flickManager.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 200),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(video['thumbnail'] ?? ""),
                          fit: BoxFit.cover)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(134, 248, 252, 255),
                        Color.fromARGB(255, 244, 250, 255)
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 80,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(112, 248, 252, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: IconButton(
                            onPressed: () {
                              _controller.dispose();
                              flickManager.dispose();
                              Navigator.pop(context);
                            },
                            alignment: Alignment.center,
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 35,
                              color: Color.fromARGB(255, 0, 87, 121),
                            )),
                      ),
                      play
                          ? Container(
                              child: _controller.value.isInitialized
                                  ? Material(
                                      elevation: 30,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: FlickVideoPlayer(
                                              flickManager: flickManager)))
                                  : CircularProgressIndicator(),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  play = true;
                                });
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Image.asset(
                                  "lib/assets/images/home_vid_icon.png",
                                  alignment: Alignment.center,
                                  scale: 2,
                                ),
                              ),
                            ),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video?['title'],
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(249, 255, 255, 255),
                                shadows: [
                                  Shadow(
                                      blurRadius: 20,
                                      color: Color.fromARGB(70, 0, 0, 0),
                                      offset: Offset(2, 4))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              video?['description'],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromARGB(108, 0, 0, 0)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(206, 245, 252, 255),
                                          Colors.white
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(16, 32, 157, 253),
                                        blurRadius: 20,
                                        offset: Offset(3, 8),
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
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

                                                  addLikeMutation(
                                                          userId, video['id'])
                                                      .then((value) {
                                                    setState(() {
                                                      liking = true;
                                                    });

                                                    if (value.data != null) {
                                                      setState(() {
                                                        liking = false;
                                                      });
                                                      List allVideos = value
                                                          .data?['addLike'];

                                                      setState(() {
                                                        Provider.of<AppProvider>(
                                                                context,
                                                                listen: false)
                                                            .addAllVideo(
                                                                allVideos);
                                                        video['likes'].add({
                                                          'user': {
                                                            'id': user?['id'],
                                                            'email':
                                                                user?['email'],
                                                            'name':
                                                                user?['name']
                                                          }
                                                        });
                                                        liking = false;
                                                      });
                                                    }

                                                    if (value.hasException) {
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
                                            left: 25,
                                            right: 30,
                                          ),
                                          icon: Icon(
                                            isLiked
                                                ? Icons.thumb_up_alt_rounded
                                                : Icons.thumb_up_alt_outlined,
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
                                          Color.fromARGB(206, 245, 252, 255),
                                          Colors.white
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(16, 32, 157, 253),
                                        blurRadius: 20,
                                        offset: Offset(3, 8),
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
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
                                            : Icons.favorite_border_outlined,
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(24, 0, 128, 255),
                          blurRadius: 20,
                          offset: Offset(3, 6))
                    ]),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50,
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
                      decoration: const BoxDecoration(color: Colors.black12),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50,
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      fontSize: 25,
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
                          width: MediaQuery.of(context).size.width - 40,
                          // height: 75,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(45, 99, 205, 251),
                                blurRadius: 30,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            color: Color.fromARGB(109, 196, 237, 255),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(13),
                            width: MediaQuery.of(context).size.width - 60,
                            // height: 55,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(17, 0, 69, 99),
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
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
                                    decoration: const InputDecoration(
                                      hintText: "Type your comment...",
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 225, 225, 225)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromARGB(255, 212, 236, 255),
                                      Color.fromARGB(255, 17, 164, 255)
                                    ]),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(115, 0, 179, 255),
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        if (comment == "") {
                                          print("empty");
                                          setState(() {
                                            error['open'] = true;
                                            error['msg'] =
                                                "Fill the comment field!";
                                          });
                                          print(error);
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });
                                          addCommentMutation(
                                                  userId, video?['id'], comment)
                                              .then((value) {
                                            if (value.hasException) {
                                              print(value.exception);
                                              print(userId);
                                              setState(() {
                                                loading = false;
                                              });
                                            }

                                            if (value.data != null) {
                                              print(value.data);
                                              setState(() {
                                                loading = false;
                                              });
                                              List allVideos =
                                                  value.data?['addComment'];

                                              Provider.of<AppProvider>(context,
                                                      listen: false)
                                                  .addAllVideo(allVideos);

                                              setState(() {
                                                video['comments'].add({
                                                  'msg': comment,
                                                  'user': {
                                                    'name': user?['name']
                                                  }
                                                });
                                              });
                                            }
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.send_rounded,
                                        color: AppColor.background,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        loading
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
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
                          padding: const EdgeInsets.only(
                              top: 30, left: 20, right: 20, bottom: 20),
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
                            children: comments
                                .map((c) => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    217, 109, 194, 255),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(50),
                                                ),
                                                border: Border.all(
                                                    width: 3,
                                                    color: const Color.fromARGB(
                                                        255, 226, 242, 255))),
                                            child: const Icon(
                                              Icons.person,
                                              color: Color.fromARGB(
                                                  234, 225, 241, 252),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c?['user']['name'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        243, 0, 145, 236)),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                c?['msg'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w100,
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
      ),
    );
  }
}
