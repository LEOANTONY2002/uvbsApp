import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uvbs/prefs.dart';

class PlaylistProvider extends ChangeNotifier {
  List<dynamic>? playlist = [];

  PlaylistProvider() {
    fetchAndSetPlaylist();
  }

  void fetchAndSetPlaylist() async {
    List<String> listString = prefs.getStringList('playlist') ?? [];
    playlist = listString.map((item) => jsonDecode(item)).toList();
    notifyListeners();
  }

  void updatePlaylistPrefs() async {
    List<String> pl = playlist!.map((item) => jsonEncode(item)).toList();
    prefs.setStringList("playlist", pl);
    // fetchAndSetPlaylist();
    notifyListeners();
  }

  void addPlaylistAudio(audio) {
    playlist!.add(audio);
    updatePlaylistPrefs();
    notifyListeners();
  }

  void removePlaylistAudio(String id) {
    var fav = playlist!.firstWhere((f) => f['id'] == id);
    playlist!.remove(fav);
    updatePlaylistPrefs();
    notifyListeners();
  }

  Future<bool> isPlaylistAudio(video) async {
    if (playlist!.isNotEmpty) {
      bool flag = false;

      playlist!.map((f) => {if (f?['id'] == video?['id']) flag = true});
      return flag;
    } else {
      return true;
    }
  }

  void clearplaylist() async {
    playlist = [];
    updatePlaylistPrefs();
    notifyListeners();
  }
}
