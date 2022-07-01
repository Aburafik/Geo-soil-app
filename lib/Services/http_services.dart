import 'dart:convert';


import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpServices {
  //// PROVIDE YOUR API KEY HERE
  static const apiKey = "";
////get Soil Data or latest data
  Future getSoilData() async {
    final prefs = await SharedPreferences.getInstance();

    double lat = prefs.getDouble("lat")!;
    double lng = prefs.getDouble("lng")!;

    String url =
        "https://api.ambeedata.com/soil/latest/by-lat-lng?lat=$lat&lng=$lng";

    final response = await get(Uri.parse(url), headers: {"x-api-key": apiKey});
      var soilData = json.decode(response.body);

    if (response.statusCode == 200) {

      // print(a["data"]);

      return soilData["data"];
    } else {
      throw Exception('Failed to load post');
    }
  }



  //get Soil Green House Current Data

  Future getSoilGHCData() async {
    final prefs = await SharedPreferences.getInstance();

    double lat = prefs.getDouble("lat")!;
    double lng = prefs.getDouble("lng")!;

    String url =
        "https://api.ambeedata.com/ghg/latest/by-lat-lng?lat=37.785834&lng=72.877655";
        

    final response = await get(Uri.parse(url), headers: {"x-api-key": apiKey});
      var soilGreenHouseCurrrent = json.decode(response.body);

    if (response.statusCode == 200) {

      print(soilGreenHouseCurrrent);

      return soilGreenHouseCurrrent["data"];
    } else {
      throw Exception('Failed to load post');
    }
  }
}
