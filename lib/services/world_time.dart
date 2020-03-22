import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the UI
  String time; // the time in that location
  String flag; // a url to an asset flag icon
  String url; // location url for api endpoint
  bool isDaytime; // true or false if nighttime

  WorldTime({this.location, this.flag, this.url});
  WorldTime.empty();

  Future<void> getTimeByIp() async {
    try {
      Response response = await get("http://worldtimeapi.org/api/ip");
      _parseData(response);
    } catch (error) {
      print('error: $error');
      time = "Service down...";
    }
  }

  Future<String> getTimeByCity() async {
    try {
      Response response =
          await get('http://worldtimeapi.org/api/timezone/$url');
      _parseData(response);
    } catch (error) {
      print('error: $error');
      time = "Service down...";
    }

    return time;
  }

  void _parseData(Response response) {
    Map data = jsonDecode(response.body);

    // find the location for initial loading
    if (location == null) {
      String timezone = data['timezone'];
      location = timezone.substring(timezone.lastIndexOf('/') + 1);
    }

    String datetime = data['utc_datetime'];
    int offset = int.parse(data['utc_offset'].substring(0, 3));

    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: offset));

    isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
    time = DateFormat.jm().format(now);
  }
}
