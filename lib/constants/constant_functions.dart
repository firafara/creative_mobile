import 'package:shared_preferences/shared_preferences.dart';

class ConstantFunction {
  void removePF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('user_name');
  }

  getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('userId');
  }
}
