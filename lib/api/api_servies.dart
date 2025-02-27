import 'dart:convert';

import 'package:currency_converter/const.dart';
import 'package:currency_converter/models/placesFrom_Gmap.dart';
import 'package:http/http.dart' as http;

class ApiServies {

  Future<placesFrom_Gmap> placesFromGmap(double lat,double lng) async{

    Uri url=Uri.parse("https://maps.googleapis.com/maps/api/directions/json?latlng=$lat,$lng&key=${Const.Map_key}");
    // latlng
    var response =await http.get(url);

    if(response.statusCode==200)
    {
  return placesFrom_Gmap.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Could not get");
    }
  }
}