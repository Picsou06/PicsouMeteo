class MeteoOnTime{
  int? cnt;
  List<List>? list;

  MeteoOnTime({this.cnt, this.list});

  MeteoOnTime.fromJson(Map<String, dynamic> json) {
    cnt = json['cnt'];
    if (json['list'] != null) {
      list = <List>[];
      json['list'].forEach((v) {
        list!.add(new List.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class List {
  int? dt;
  List<Weather>? weather;

  List(
      {this.dt,
      this.weather,});

  List.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
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


// https://openweathermap.org/forecast5
// api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$OPEN_WEATHER_MAP_APPID
//  meteolocale = MeteoOnTime.list!.first.weather!.first.main.toString();
//  icon = ${MeteoOnTime.list!.first.weather!.first.icon};