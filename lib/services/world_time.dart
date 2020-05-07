// import 'package:http/http.dart';
// import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:groundsecurity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:groundsecurity/interceptor/retry_interceptor.dart';

class WorldTime {
  Dio dio;
  String location; // location name for the UI
  String time; // the time in that location
  String flag; // a url to an asset flag icon
  String url; // location url for api endpoint
  bool isDaytime; // true or false if nighttime

  WorldTime({this.location, this.flag, this.url});
  WorldTime.empty();

  Future<void> getTimeByIp() async {
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
      _parseData(response);
    } catch (error) {
      print('error: $error');
      time = "Service down...";
    }
  }

  Future<String> getTimeByCity() async {
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
      _parseData(response);
    } catch (error) {
      print('error: $error');
      time = "Service down...";
    }

    return time;
  }

  void _parseData(Response response) {
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
    time = 'Ground Security 🛡️';
  }
}
