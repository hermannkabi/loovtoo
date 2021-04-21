import 'package:flutter/material.dart';
import 'package:ilm_loovtoo_harjutusprojekt/weather_service_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  // Sets default location, can be changed inside app

  int currentTemperature = 0;
  String currentDescription = "";
  String currentImage = "https://openweathermap.org/img/w/01d.png";
  String unitPrefix = "°C";


  String activeCity = "Tallinn";
  TemperatureUnit unit = TemperatureUnit.celsius;
  List<String> cities = [
    "Tallinn",
    "Helsinki",
    "Paris",
    "Stockholm",
    "Copenhagen",
    "Riga",
    "Reykjavik",
    "Cairo",
    "New York",
    "San Francisco",
    "North Pole",
  ];


  //Method that gets a list of city names and returns a list of dropdownmenuitems
  List<DropdownMenuItem> getAvailableCities(){
    List<DropdownMenuItem> items = [];
    for(String city in cities){
      items.add(
        DropdownMenuItem(
          child: Text(city, style: TextStyle(color: Color(0xFF4D87F2), fontSize: 18),),
          value: city,
        ),
      );
    }
    return items;
  }


  void updateWeather([TemperatureUnit unit = TemperatureUnit.celsius]){
    Map unitToPrefix = {
      TemperatureUnit.celsius:"°C",
      TemperatureUnit.fahrenheit:"°F",
      TemperatureUnit.kelvin:"K",
    };
    Weather().fetchWeatherDataForLocation(activeCity, unit).then((value) {
      setState(() {
        currentTemperature = value.temperature;
        currentDescription = value.description;
        currentImage = value.icon;
        unitPrefix = unitToPrefix[unit];
      });
    });
  }



  @override
  void initState() {
    super.initState();
    updateWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A4058),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: Text("Celsius", style: TextStyle(color: Color(0xFF4D87F2), fontSize: 18),),
                        value: TemperatureUnit.celsius,
                      ),
                      DropdownMenuItem(
                        child: Text("Fahrenheit", style: TextStyle(color: Color(0xFF4D87F2), fontSize: 18),),
                        value: TemperatureUnit.fahrenheit,
                      ),
                      DropdownMenuItem(
                        child: Text("Kelvin", style: TextStyle(color: Color(0xFF4D87F2), fontSize: 18),),
                        value: TemperatureUnit.kelvin,
                      ),
                    ],
                    value: unit,
                    onChanged: (newValue){
                      setState(() {
                        unit = newValue;
                      });
                      updateWeather(unit);
                    },
                  ),
                  DropdownButton(
                    value: activeCity,
                    items: getAvailableCities(),
                    onChanged: (newValue){
                      setState(() {
                        activeCity = newValue;
                      });
                      updateWeather(unit);
                    },
                  ),
                ],
              ),
              SizedBox(height: 80,),
              Image.network(currentImage, scale: 0.5,),
              Text("$currentTemperature$unitPrefix", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 120, color: Color(0xFF4D87F2)),),
              Text(currentDescription, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 55, color: Color(0xFF4D87F2)),),


            ],
          ),
        ),
      ),
    );
  }
}
