import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/components/stream/favVideoCard.dart';
import 'package:uvbs/providers/favProvider.dart';
import 'package:uvbs/providers/provider.dart';

class Favs extends StatefulWidget {
  const Favs({super.key});

  @override
  State<Favs> createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    var favs = Provider.of<FavoriteProvider>(context).favs;
    // Provider.of<FavoriteProvider>(context).clearFavs();

    return Scaffold(
      body: Container(
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
                : favs!.isNotEmpty
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
                                      bottomRight: Radius.elliptical(180, 120)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(215, 53, 150, 247),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "Favorite Videos",
                                  style: TextStyle(
                                      fontSize: 22, color: AppColor.background),
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
                                spacing: 0,
                                children: favs
                                    .map<Widget>((f) => GestureDetector(
                                          onTap: () {
                                            Provider.of<AppProvider>(context,
                                                    listen: false)
                                                .updateVideoFromFav(f);

                                            Navigator.pushNamed(
                                                context, "/favVideo");
                                          },
                                          child: FavVideoCard(
                                            video: f,
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
                            const Text("No videos found!"),
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
    );
  }
}
