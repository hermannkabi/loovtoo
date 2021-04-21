import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ilm_loovtoo_harjutusprojekt/api_key.dart';

class Weather {

  //Gets apiKey from class ApiKey.
  final String apiKey = ApiKey.apiKey;


  Future<WeatherData> fetchWeatherDataForLocation(String location, [TemperatureUnit unit = TemperatureUnit.celsius])async{

    //Makes the request to OpenWeatherMap API
    http.Response response = await http.get(
        Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric"),
    );

    //Checks statusCode, continues if everything went well
    if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      String cityName = data["name"];
      int temperature = double.parse(data["main"]["temp"].toString()).toInt();
      String description = data["weather"][0]["description"];
      String icon = "https://openweathermap.org/img/w/${data["weather"][0]["icon"]}.png";
      switch(unit){
        case TemperatureUnit.celsius:
          temperature *= 1;
          break;
        case TemperatureUnit.fahrenheit:
          temperature = ((temperature * 9/5) + 32).toInt();
          break;
        case TemperatureUnit.kelvin:
          temperature += 273;
          break;
        default:
          temperature *= 1;
          break;
      }
      return WeatherData(cityName: cityName, temperature: temperature, description: description, icon: icon);
    }

    //Returns a WeatherData with error set true so that we can show error on screen
    return WeatherData(error: true);
  }

}


class WeatherData {
  final String cityName;
  final int temperature;
  final String description;
  final bool error;
  final String icon;

  WeatherData({this.cityName,this.description,this.temperature, this.icon, this.error = false});
}

enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin,
}