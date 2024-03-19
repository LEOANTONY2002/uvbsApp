import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  List? videos;
  dynamic video;
  List? audios;
  dynamic audio;
  List? products;
  dynamic product;
  dynamic order;
  dynamic asset;

  AppProvider({this.videos, this.video});

  void addAllVideo(dynamic vids) {
    videos = vids;
    notifyListeners();
  }

  void updateVideo(String id) {
    video = videos!.firstWhere((f) => f['id'] == id);
  }

  void updateVideoFromFav(dynamic vid) {
    video = vid;
  }

  void clearVideo() {
    video = null;
  }

  void addAllAudio(dynamic auds) {
    audios = auds;
    notifyListeners();
  }

  void updateAudio(aud) {
    audio = aud;
    notifyListeners();
  }

  void updateAudioFromFav(dynamic aud) {
    audio = aud;
  }

  void clearAudio() {
    audio = null;
  }

  void addAllProduct(dynamic prds) {
    products = prds;
    notifyListeners();
  }

  void updateProduct(prd) {
    product = prd;
    notifyListeners();
  }

  void updateProductFromFav(dynamic prd) {
    product = prd;
  }

  void clearProduct() {
    product = null;
  }

  void updateOrder(ord) {
    order = ord;
    notifyListeners();
  }

  void clearOrder() {
    order = null;
  }

  void addAsset(dynamic payload) {
    asset = payload;
    notifyListeners();
  }
}
