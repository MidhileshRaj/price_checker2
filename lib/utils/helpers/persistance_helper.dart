import 'package:shared_preferences/shared_preferences.dart';

class HelperServices {
  static saveServerData(key,value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String> getServerData(key)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value =preferences.getString(key)??"";
    return value;
  }
  static setConfiguration(value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isConfigured",value );
  }

  static Future<bool> checkConfiguration()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value =preferences.getBool("isConfigured")??false;
    return value;
  }
  static setFtpConfiguration(value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isFtpConfigured",value );
  }

  static Future<bool> checkFtpConfiguration()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value =preferences.getBool("isFtpConfigured")??false;
    return value;
  }

  static saveListOfItem(key,value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, value);
  }
  static Future<List<String>> getListOfItems(key)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> list=preferences.getStringList(key)??[];
    return list;
  }
}
