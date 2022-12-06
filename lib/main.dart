// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, unused_local_variable, camel_case_types, unnecessary_new, unnecessary_this, prefer_collection_literals, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

var icon = "01d";
var meteolocale = "Clear";
List ville = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picsou Météo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageDeBase(),
    );
  }
}

class getNowMeteo {
  Coord? coord;
  List<Weather>? weather;

  getNowMeteo({this.coord, this.weather});

  getNowMeteo.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? new Coord.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coord != null) {
      data['coord'] = this.coord!.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main'] = this.main;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}

class PageDeBase extends StatefulWidget {
  const PageDeBase({Key? key}) : super(key: key);

  @override
  State<PageDeBase> createState() => _createState();
}

// void MeteoWithbar(BuildContext context) async {
//   var responses = await rootBundle.loadString('assets/city.list.json');
//   Map<String, dynamic> map = json.decode(responses);
//   List<dynamic> ville = map["name"];
//   var cherch = "Nice";
//   print("Meteo bar");
//   var url =
//       "https://api.openweathermap.org/data/2.5/weather?q=$cherch&appid=89ee0c135f537894a7668775dd84ab25";
//   final response = await http.get(Uri.parse(url));
//   getNowMeteo MeteoNow = getNowMeteo.fromJson(jsonDecode(response.body));
//   meteolocale = MeteoNow.weather!.first.main.toString();
//   icon = "${MeteoNow.weather!.first.icon}";
// }

void MeteoWithLocation(BuildContext context) async {
  Location location = Location();
  var geoloc = await location.getLocation();
  var lat = geoloc.latitude;
  var lon = geoloc.longitude;
  print("Meteo Location");
  var url =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=89ee0c135f537894a7668775dd84ab25";
  final response = await http.get(Uri.parse(url));
  getNowMeteo MeteoNow = getNowMeteo.fromJson(jsonDecode(response.body));
  meteolocale = MeteoNow.weather!.first.main.toString();
  icon = "${MeteoNow.weather!.first.icon}";
}

class _createState extends State<PageDeBase> {
  @override
  Widget build(BuildContext context) {
    sleep(Duration(seconds: 2));
    var icontxt = "$icon@2x.png";
    print(icontxt);
    print(meteolocale);
    return Container(
        height: 700,
        color: Colors.blue,
        child: Column(children: [
          SizedBox(
              height: 50,
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  MeteoWithLocation(context);
                },
                child: null,
              )),
          SizedBox(
            height: 50,
            width: 50,
            child: Image.network("http://openweathermap.org/img/wn/$icontxt"),
          )
        ]));
  }
}
