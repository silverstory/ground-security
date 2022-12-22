// import 'package:http/http.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:groundsecurity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:groundsecurity/interceptor/retry_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorldTime {
  Dio dio;
  String location; // location name for the UI
  String time; // the time in that location
  String flag; // a url to an asset flag icon
  String url; // location url for api endpoint
  bool isDaytime; // true or false if nighttime

  WorldTime({this.location, this.time, this.flag, this.url});
  WorldTime.empty();

  // renamed dec 21 2022
  Future<void> _oldgetTimeByIp() async {
    await _parseData();
  }

  // renamed dec 21 2022
  Future<String> _oldgetTimeByCity() async {
    await _parseData();
    return await time;
  }

  void _parseData() async {

    // datetime.toIso8601String();
    // flag: 'ph.png', url: 'Asia/Manila'
    // {"abbreviation":"PST","client_ip":"175.176.46.143","datetime":"2021-01-20T11:53:14.059717+08:00","day_of_week":3,"day_of_year":20,"dst":false,"dst_from":null,"dst_offset":0,"dst_until":null,"raw_offset":28800,"timezone":"Asia/Manila","unixtime":1611114794,"utc_datetime":"2021-01-20T03:53:14.059717+00:00","utc_offset":"+08:00","week_number":3}

    var _datetime = new DateTime.now();

    // location = 'Manila';
    // location = await _gateRetriever();

    String datetime = _datetime.toIso8601String();
    String manilaUtcOffset = '+08:00';
    int offset = int.parse(manilaUtcOffset.substring(0, 3));

    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: offset));

    isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
    /*
    * this is the original
    * time value
    time = DateFormat.jm().format(now);
    */
    // time = 'Ground Security 🛡️';
    time = 'Juan D.';
  }

  Future<String> _gateRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('location') ?? 'GATE 6';
    return location;
  }

  /*
  * ALL THE OLD
  * CODE BELOW
  */

  Future<void> oldGetTimeByIp() async {
    try {
      // using og http pkg
      // Response response = await get("http://worldtimeapi.org/api/ip");
      dio = Dio();
      dio.interceptors.add(
        RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
            dio: Dio(),
            connectivity: Connectivity(),
          ),
        ),
      );
      Response response = await dio.get('http://worldtimeapi.org/api/ip');
      dio.interceptors.removeLast();
      dio = null;
      _oldParseData(response);
    } catch (error) {
      print('error: $error');
      time = "Service down...";
    }
  }

  Future<String> oldGetTimeByCity() async {
    try {
      // usin og http pkg
      // Response response =
      //     await get('http://worldtimeapi.org/api/timezone/$url');
      dio = Dio();
      dio.interceptors.add(
        RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
            dio: Dio(),
            connectivity: Connectivity(),
          ),
        ),
      );
      Response response =
          await dio.get('http://worldtimeapi.org/api/timezone/$url');
      dio.interceptors.removeLast();
      dio = null;
      _oldParseData(response);
    } catch (error) {
      print('error: $error');
      time = "Service down...";
    }

    return time;
  }

  void _oldParseData(Response response) {
    // using og http pkg
    // Map data = jsonDecode(response.body);

    Map data = response.data;

    // return UserResponse.fromJson(response.data);

    // get field for first rec sample
    // firstPostTitle = response.data[0]['title'] as String;

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
    /*
    * this is the original
    * time value
    time = DateFormat.jm().format(now);
    */
    // time = 'Ground Security 🛡️';
    time = 'Ground Security';
  }
}
