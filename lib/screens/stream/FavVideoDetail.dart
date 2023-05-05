import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/providers/favProvider.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class FavVideoDetail extends StatefulWidget {
  dynamic vid;
  FavVideoDetail({super.key, this.vid});

  @override
  State<FavVideoDetail> createState() => _FavVideoDetailState();
}

class _FavVideoDetailState extends State<FavVideoDetail> {
  Map<String, dynamic> error = {'open': false, 'msg': ""};
  bool loading = false;
  bool play = false;

  late VideoPlayerController _controller;
  late FlickManager flickManager;

  void initPlayer() {
    _controller = VideoPlayerController.network(
        Provider.of<AppProvider>(context, listen: false).video?['videoUrl'])
      ..initialize().then((_) {
        flickManager = FlickManager(videoPlayerController: _controller);
        setState(() {});
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

    // flickManager = FlickManager(videoPlayerController: _controller);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(255, 222, 243, 255),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(300, 270),
                          bottomRight: Radius.elliptical(300, 270),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: Color.fromARGB(45, 9, 124, 225),
                            blurStyle: BlurStyle.outer,
                          ),
                        ]),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 186, 230, 255),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(300, 290),
                            bottomRight: Radius.elliptical(300, 290),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Color.fromARGB(45, 9, 124, 225),
                              blurStyle: BlurStyle.outer,
                            ),
                          ]),
                      child: Container(
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(255, 186, 230, 255),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(300, 300),
                              bottomRight: Radius.elliptical(300, 300),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                color: Color.fromARGB(105, 9, 124, 225),
                                blurStyle: BlurStyle.outer,
                              ),
                            ]),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.elliptical(300, 300),
                            bottomRight: Radius.elliptical(300, 300),
                          ),
                          child: Image.network(
                            video['thumbnail'] ?? "",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height - 300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 230,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(30),
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: FlickVideoPlayer(
                                                flickManager: flickManager)))
                                    : Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CircularProgressIndicator(),
                                      ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    play = true;
                                  });
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    "lib/assets/images/home_vid_icon.png",
                                    alignment: Alignment.center,
                                    scale: 2,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      video?['title'],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      video?['description'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                          color: Color.fromARGB(108, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
