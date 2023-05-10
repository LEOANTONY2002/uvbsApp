import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/providers/playlistProvider.dart';
import 'package:uvbs/providers/provider.dart';

class AudioDetail extends StatefulWidget {
  dynamic aud;
  AudioDetail({super.key, this.aud});

  @override
  State<AudioDetail> createState() => _AudioDetailState();
}

class _AudioDetailState extends State<AudioDetail> {
  final player = AudioPlayer();

  Duration? duration = const Duration(seconds: 0);
  double value = 0;
  var isPlaying = false;

  void initPlayer() async {
    // print(Provider.of<AppProvider>(context, listen: false).audio['audioUrl']);
    var audio = Provider.of<AppProvider>(context, listen: false).audio;
    await player.setSourceUrl(audio['audioUrl']);
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    widget.aud = Provider.of<AppProvider>(context, listen: false).audio;
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var audio = Provider.of<AppProvider>(context, listen: false).audio;
    bool isFav = context
        .watch<PlaylistProvider>()
        .playlist!
        .where((f) => f?['id'] == audio?['id'])
        .isNotEmpty;

    initPlayer();

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(audio['thumbnail']),
                fit: BoxFit.cover,
              ),
              color: const Color.fromARGB(182, 255, 255, 255)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: const Color.fromARGB(214, 249, 253, 255),
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(112, 248, 252, 255),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: IconButton(
                        onPressed: () {
                          player.dispose();
                          Navigator.pop(context);
                        },
                        alignment: Alignment.center,
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 25,
                          color: Color.fromARGB(204, 0, 43, 60),
                          shadows: [
                            Shadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(1, 3))
                          ],
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 30,
                          shadowColor: const Color.fromARGB(245, 1, 59, 107),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    audio['thumbnail'],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(audio['title'],
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 22,
                                        )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      child: Text(audio['description'],
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            overflow: TextOverflow.clip,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                  onTap: !isFav
                                      ? () {
                                          Provider.of<PlaylistProvider>(context,
                                                  listen: false)
                                              .addPlaylistAudio(audio);
                                        }
                                      : () {
                                          Provider.of<PlaylistProvider>(context,
                                                  listen: false)
                                              .removePlaylistAudio(audio['id']);
                                        },
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_outlined,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${(value / 60).floor()} : ${(value % 60).floor()}"),
                            Slider.adaptive(
                              onChanged: (v) {
                                setState(() {
                                  value = v;
                                });
                              },
                              onChangeEnd: (newValue) async {
                                setState(() {
                                  value = newValue;
                                });
                                player.pause();
                                await player
                                    .seek(Duration(seconds: newValue.toInt()));
                                await player.resume();
                              },
                              min: 0.0,
                              max: duration!.inSeconds.toDouble(),
                              value: value,
                            ),
                            Text(
                                "${duration!.inMinutes} : ${duration!.inSeconds % 60}"),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () async {
                              if (isPlaying) {
                                await player.pause();
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                              } else {
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                                await player.resume();
                              }

                              player.onPositionChanged.listen((position) {
                                setState(() {
                                  value = position.inSeconds.toDouble();
                                });
                              });
                            },
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 50,
                            ))
                      ],
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () {},
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width - 40,
                  //       height: 50,
                  //       alignment: Alignment.center,
                  //       decoration: const BoxDecoration(
                  //         color: Colors.black12,
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(50),
                  //         ),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Color.fromARGB(48, 0, 0, 0),
                  //             blurRadius: 20,
                  //             blurStyle: BlurStyle.outer,
                  //           )
                  //         ],
                  //       ),
                  //       child: const Text(
                  //         "Add to Playlist",
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 16),
                  //       ),
                  //     ))
                  const SizedBox()
                ],
              ),
            ),
          )),
    );
  }
}
