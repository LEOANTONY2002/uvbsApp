import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}

setPrefEmail(String email) async {
  await prefs.setString('email', email);
}

var prefEmail = prefs.getString('email');
