import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

var icon = "02d";
var meteolocale = "Clear";
List<String> villes = [];
var OPEN_WEATHER_MAP_APPID = "89ee0c135f537894a7668775dd84ab25";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picsou Météo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageDeBase(),
    );
  }
}

class PageDeBase extends StatefulWidget {
  const PageDeBase({Key? key}) : super(key: key);

  @override
  State<PageDeBase> createState() => _PageDeBaseState();
}

class _PageDeBaseState extends State<PageDeBase> {
  String selectedCity = '';

  @override
  void initState() {
    super.initState();
    chargerVilles();
    MeteoWithLocation();
  }

  void chargerVilles() async {
    final citiesData = await DefaultAssetBundle.of(context)
        .loadString('assets/city.list.json');
    final citiesList = json.decode(citiesData) as List<dynamic>;
    setState(() {
      villes = citiesList
          .where((city) => city['country'] == 'FR')
          .map((city) => city['name'].toString())
          .toList();
    });
  }

  void MeteoWithLocation() async {
    Location location = Location();
    var geoloc = await location.getLocation();
    var lat = geoloc.latitude;
    var lon = geoloc.longitude;
    var url =
        "http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$OPEN_WEATHER_MAP_APPID";
    final response = await http.get(Uri.parse(url));
    MeteoOnTime MeteoNow = MeteoOnTime.fromJson(jsonDecode(response.body));
    setState(() {
      meteolocale = MeteoNow.weatherList!.first.weather!.first.main.toString();
      icon = "${MeteoNow.weatherList!.first.weather?.first.icon}";
    });
  }

  void MeteoWithCity(String city) async {
    var url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$OPEN_WEATHER_MAP_APPID";
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    setState(() {
      selectedCity = city;
      meteolocale = data['weather'][0]['main'];
      icon = data['weather'][0]['icon'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var icontxt = "$icon@2x.png";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picsou Météo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CitySearchDelegate());
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ville sélectionnée : $selectedCity',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Météo : $meteolocale',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              'http://openweathermap.org/img/w/$icontxt',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class MeteoOnTime {
  List<Meteo> weatherList;

  MeteoOnTime({required this.weatherList});

  factory MeteoOnTime.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    List<Meteo> weatherList =
        list.map((weather) => Meteo.fromJson(weather)).toList();
    return MeteoOnTime(weatherList: weatherList);
  }
}

class Meteo {
  List<Weather>? weather;

  Meteo({this.weather});

  factory Meteo.fromJson(Map<String, dynamic> json) {
    var list = json['weather'] as List;
    List<Weather> weatherList =
        list.map((weather) => Weather.fromJson(weather)).toList();
    return Meteo(weather: weatherList);
  }
}

class Weather {
  String? main;
  String? description;
  String? icon;

  Weather({this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = villes
        .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          MeteoWithCity(suggestionList[index]);
          close(context, suggestionList[index]);
        },
        title: Text(suggestionList[index]),
      ),
    );
  }
}
