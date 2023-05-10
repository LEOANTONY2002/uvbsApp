import 'package:flutter/material.dart';
import 'package:uvbs/screens/stream/Audios.dart';
import 'package:uvbs/screens/stream/Favs.dart';
import 'package:uvbs/screens/stream/Playlist.dart';
import 'package:uvbs/screens/stream/Videos.dart';

class Stream extends StatefulWidget {
  const Stream({super.key});

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  int index = 0;

  late List<Widget> screens = [const Videos(), const Favs(), const Audios(), const Playlist()];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Videos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    highlightColor: const Color.fromARGB(19, 255, 255, 255),
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
