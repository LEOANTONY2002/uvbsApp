import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/providers/favProvider.dart';

class FavVideoCard extends StatefulWidget {
  var video;

  FavVideoCard({super.key, required this.video});

  @override
  State<FavVideoCard> createState() => _FavVideoCardState();
}

class _FavVideoCardState extends State<FavVideoCard> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    // var config = Configuration.local([Fav.schema]);
    // var realm = Realm(config);

    return Container(
      width: MediaQuery.of(context).size.width / 2 - 30,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Color.fromARGB(255, 250, 253, 255),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(35, 66, 170, 255),
              blurRadius: 20,
              offset: Offset(3, 6))
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(54, 33, 155, 255),
                          blurRadius: 10,
                          offset: Offset(1, 3))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.network(
                      widget.video['thumbnail'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(54, 33, 155, 255),
                        blurRadius: 10,
                        offset: Offset(1, 3))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color.fromARGB(144, 239, 249, 255),
                ),
                child: IconButton(
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeFav(widget.video?['id']);
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(widget.video['title']),
          ),
        ],
      ),
    );
  }
}
