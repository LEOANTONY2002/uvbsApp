import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/providers/playlistProvider.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool loading = false;
  final player = AudioPlayer();

  Duration? duration = const Duration(seconds: 0);
  double value = 0;
  var isPlaying = false;
  List playlist = [];
  var currentAudio;
  int currentIndex = 0;

  void initPlayer() async {
    if (Provider.of<PlaylistProvider>(context, listen: false)
        .playlist!
        .isNotEmpty) {
      playlist =
          Provider.of<PlaylistProvider>(context, listen: false).playlist!;
      currentAudio = Provider.of<PlaylistProvider>(context, listen: false)
              .playlist?[currentIndex] ??
          '';
      await player.setSourceUrl(currentAudio?['audioUrl'] ?? '');
      duration = await player.getDuration();
    }
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    // Provider.of<PlaylistProvider>(context).clearplaylist();
    currentAudio = playlist.isNotEmpty ? playlist[currentIndex] : "";

    return Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 70,
          color: AppColor.background,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              loading
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
                  : playlist.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(
                            bottom: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 0, bottom: 20, left: 0, right: 20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 237, 247, 255),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.elliptical(180, 120)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(116, 132, 194, 255),
                                      blurRadius: 30,
                                    )
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 50, bottom: 25, left: 70, right: 90),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.elliptical(180, 120)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(215, 53, 150, 247),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    "Playlist",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: AppColor.background),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Wrap(
                                  alignment: WrapAlignment.spaceEvenly,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 20,
                                  spacing: 20,
                                  children: playlist
                                      .map<Widget>((p) => GestureDetector(
                                            onTap: () async {
                                              await player
                                                  .setSourceUrl(p['audioUrl']);
                                              setState(() {
                                                currentAudio = p;
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              height: 80,
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          27, 131, 193, 254),
                                                      blurRadius: 30,
                                                    )
                                                  ],
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Material(
                                                      elevation: 10,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: Container(
                                                        width: 60,
                                                        height: 60,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    p['thumbnail'],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              220,
                                                          child: Text(
                                                            p?['title'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              220,
                                                          child: Text(
                                                            p?['description'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                color: Color
                                                                    .fromARGB(
                                                                        137,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              233,
                                                              247,
                                                              255),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50))),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Provider.of<PlaylistProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .removePlaylistAudio(
                                                                    p?['id']);
                                                          });
                                                        },
                                                        child: const Icon(
                                                            Icons
                                                                .delete_forever_rounded,
                                                            shadows: [
                                                              Shadow(
                                                                  blurRadius:
                                                                      10,
                                                                  offset:
                                                                      Offset(
                                                                          2, 4),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          156,
                                                                          81,
                                                                          191,
                                                                          255))
                                                            ],
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    33,
                                                                    184,
                                                                    243)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("lib/assets/images/no_fav.png"),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("No Audios found!"),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Add your favorite videos",
                                style: TextStyle(
                                    color: Color.fromARGB(110, 33, 149, 243)),
                              ),
                            ],
                          )),
            ]),
          ),
        ),
        playlist.isNotEmpty
            ? Positioned(
                bottom: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 80,
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(45, 53, 150, 247),
                          blurRadius: 30,
                        )
                      ],
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(80))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Material(
                              elevation: 10,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        currentAudio['thumbnail'],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                width: MediaQuery.of(context).size.width - 220,
                                child: Text(
                                  currentAudio?['title'],
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Slider(
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
                                  await player.seek(
                                      Duration(seconds: newValue.toInt()));
                                  await player.resume();
                                },
                                min: 0.0,
                                max: duration!.inSeconds.toDouble(),
                                value: value,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          currentIndex > 0
                              ? GestureDetector(
                                  onTap: () async => setState(() async {
                                    currentIndex = currentIndex - 1;
                                    await player.setSourceUrl(
                                        playlist[currentIndex]?['audioUrl']);
                                  }),
                                  child: const Icon(
                                    Icons.fast_rewind_rounded,
                                    size: 25,
                                  ),
                                )
                              : const SizedBox(),
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
                              child: Row(
                                children: [
                                  Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 45,
                                  ),
                                ],
                              )),
                          currentIndex < playlist.length - 1
                              ? GestureDetector(
                                  onTap: () => setState(() async {
                                    currentIndex = currentIndex + 1;
                                    await player.setSourceUrl(
                                        playlist[currentIndex]?['audioUrl']);
                                  }),
                                  child: const Icon(
                                    Icons.fast_forward_rounded,
                                    size: 25,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      )
                    ],
                  ),
                ))
            : const SizedBox()
      ]),
    );
  }
}
