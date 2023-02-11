// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, unused_local_variable, camel_case_types, unnecessary_new, unnecessary_this, prefer_collection_literals, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';
import 'dart:io';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:simple_gradient_text/simple_gradient_text.dart';

var icon = "09d";
var meteolocale = "Clear";
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
//       "https://api.openweathermap.org/data/2.5/weather?q=$cherch&appid=$OPEN_WEATHER_MAP_APPID";
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
      "api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$OPEN_WEATHER_MAP_APPID";
  var response = await http.get(Uri.parse(url));
  getNowMeteo MeteoNow = getNowMeteo.fromJson(jsonDecode(response.body));
  meteolocale = MeteoNow.weather!.first.main.toString();
  icon = "${MeteoNow.weather!.first.icon}";
  url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon';
  response = await http.get(Uri.parse(url));
  var responseBody =
      await response.map((res) => utf8.decode(res.bodyBytes)).join();
  var responseJson = json.decode(responseBody);
  print(responseJson['address']['city']);
}

class _createState extends State<HomePageWidget> {
  PageController? pageViewController;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  PageController? pageViewController;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF00B5FF),
      appBar: AppBar(
        backgroundColor: Color(0xCD4B39EF),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 3, 0),
          child: FlutterFlowIconButton(
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 55,
            fillColor: Colors.white,
            icon: Icon(
              Icons.replay_rounded,
              color: Color(0xCD4B39EF),
              size: 30,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
        ),
        title: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          child: Text(
            'PicsouMétéo',
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Noto Serif',
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        actions: [
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4, 0, 3, 0),
              child: FlutterFlowIconButton(
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 55,
                fillColor: FlutterFlowTheme.of(context).primaryBtnText,
                icon: Icon(
                  Icons.search,
                  color: Color(0xCD4B39EF),
                  size: 27,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                    child: GradientText(
                      'Votre ville',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).title3.override(
                            fontFamily: 'Poppins',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                      colors: [Color(0xFF343434), Color(0xCD4B39EF)],
                      gradientDirection: GradientDirection.ltr,
                      gradientType: GradientType.linear,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 500,
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                              child: PageView(
                                controller: pageViewController ??=
                                    PageController(initialPage: 0),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.network(
                                        'http://openweathermap.org/img/wn/02d@2x.png',
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          dateTimeFormat(
                                              'EEEE', getCurrentTimestamp),
                                          'Demain',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xCD4B39EF),
                                              fontSize: 24,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.network(
                                        'http://openweathermap.org/img/wn/02d@2x.png',
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          dateTimeFormat(
                                              'EEEE', getCurrentTimestamp),
                                          'Demain',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xCD4B39EF),
                                              fontSize: 24,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.network(
                                        'http://openweathermap.org/img/wn/10d@2x.png',
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        dateTimeFormat(
                                            'EEEE', getCurrentTimestamp),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xCD4B39EF),
                                              fontSize: 24,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.network(
                                        'http://openweathermap.org/img/wn/10d@2x.png',
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        dateTimeFormat(
                                            'EEEE', getCurrentTimestamp),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xCD4B39EF),
                                              fontSize: 24,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 1),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child:
                                    smooth_page_indicator.SmoothPageIndicator(
                                  controller: pageViewController ??=
                                      PageController(initialPage: 0),
                                  count: 4,
                                  axisDirection: Axis.horizontal,
                                  onDotClicked: (i) {
                                    pageViewController!.animateToPage(
                                      i,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  effect:
                                      smooth_page_indicator.ExpandingDotsEffect(
                                    expansionFactor: 2,
                                    spacing: 8,
                                    radius: 16,
                                    dotWidth: 16,
                                    dotHeight: 16,
                                    dotColor: Color(0xFF9E9E9E),
                                    activeDotColor: Color(0xFF3F51B5),
                                    paintStyle: PaintingStyle.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
