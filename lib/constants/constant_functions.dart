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

  getAPIToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('apiToken');
  }

  setSPKValue(customer_id, customer_name, unit_site, assignment_province,
      unit_sn, unit_brand, unit_model, unit_status_before_service) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('customer_id', customer_id);
    pref.setString('customer_name', customer_name);
    pref.setString('unit_site', unit_site);
    pref.setString('assignment_province', assignment_province);
    pref.setString('unit_sn', unit_sn);
    pref.setString('unit_brand', unit_brand);
    pref.setString('unit_model', unit_model);
    pref.setString('unit_status_before_service', unit_status_before_service);
  }

  getSPKCustomerName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('customer_name');
  }
}
