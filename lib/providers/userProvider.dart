import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uvbs/prefs.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? user;

  UserProvider() {
    fetchAndSetUser();
  }

  Future<Map<String, dynamic>?> fetchAndSetUser() async {
    String userDetail = prefs.getString('user') ?? '';

    if (userDetail.isNotEmpty) {
      Map<String, dynamic> userMap = jsonDecode(userDetail);
      user = userMap;
    }
    notifyListeners();
    return null;
  }

  void setUser(Map<String, dynamic> data) async {
    prefs.setString('user', jsonEncode(data));
    user = data;
    notifyListeners();
  }

  void clearUser() async {
    prefs.remove('user');
    user = null;
    notifyListeners();
  }
}
