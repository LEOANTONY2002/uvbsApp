import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uvbs/prefs.dart';

// class Favorite {
//   late String id;
//   late String title;
//   late String description;
//   late String thumbnail;
//   late String videoUrl;

//   Favorite(
//       this.id, this.description, this.title, this.thumbnail, this.videoUrl);

//   Favorite.fromMap(Map map)
//       : id = map['id'],
//         title = map['title'],
//         description = map['description'],
//         thumbnail = map['thumbnail'],
//         videoUrl = map['videoUrl'];

//   Map toMap() => {
//         'id': id,
//         'title': title,
//         'description': description,
//         'thumbnail': thumbnail,
//         'videoUrl': videoUrl,
//       };
// }

class FavoriteProvider extends ChangeNotifier {
  List<dynamic>? favs = [];

  FavoriteProvider() {
    fetchAndSetFavs();
  }

  void fetchAndSetFavs() async {
    List<String> listString = prefs.getStringList('favs') ?? [];
    favs = listString.map((item) => jsonDecode(item)).toList();
    notifyListeners();
  }

  void addfav(fav) {
    favs!.add(fav);
    updatefavPrefs();
    notifyListeners();
  }

  void updatefavPrefs() async {
    List<String> favList = favs!.map((item) => jsonEncode(item)).toList();
    prefs.setStringList("favs", favList);
    // fetchAndSetFavs();
    notifyListeners();
  }

  void removeFav(String id) {
    var fav = favs!.firstWhere((f) => f['id'] == id);
    favs!.remove(fav);
    updatefavPrefs();
    notifyListeners();
  }

  Future<bool> isFav(video) async {
    if (favs!.isNotEmpty) {
      bool flag = false;

      favs!.map((f) => {if (f?['id'] == video?['id']) flag = true});

      return flag;

      // if (favs!
      //     .firstWhere((f) => f?['id'] == video?['id'], orElse: () => false)) {
      //   return false;
      // } else {
      //   return true;
      // }
    } else {
      return true;
    }
  }

  void clearFavs() async {
    favs = [];
    updatefavPrefs();
    notifyListeners();
  }
}
