// import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:groundsecurity/main.dart';
import 'package:groundsecurity/services/socket_service.dart';

import 'model/weather.dart';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:groundsecurity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:groundsecurity/interceptor/retry_interceptor.dart';

import 'package:faker/faker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'dart:async';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Future<String> _token;

  // final SocketService socketService = injector.get<SocketService>();
  Dio dio;
  double cachedTempCelsius;
  Map<String, String> placeholderMap = {
    'male': 'male.jpg',
    'female': 'female.jpg'
  };
  Map<int, String> genderMap = {1: 'male', 2: 'female'};
  Map<int, String> maleMap = {
    1: 'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    2: 'https://images.pexels.com/photos/2473581/pexels-photo-2473581.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    3: 'https://images.pexels.com/photos/938642/pexels-photo-938642.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    4: 'https://images.pexels.com/photos/2589650/pexels-photo-2589650.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  };
  Map<int, String> femaleMap = {
    1: 'https://images.pexels.com/photos/3891820/pexels-photo-3891820.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    2: 'https://images.pexels.com/photos/2135135/pexels-photo-2135135.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    3: 'https://images.pexels.com/photos/1727273/pexels-photo-1727273.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    4: 'https://images.pexels.com/photos/247120/pexels-photo-247120.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  };

  @override
  Future<Weather> fetchWeather(String sCode) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 2),
      () async {
        /*
        * read token from storage
        */
        // _token = _prefs.then((SharedPreferences prefs) {
        //   return (prefs.getString('token') ?? 'an invalid token');
        // });
        String _token = await _tokenRetriever();
        List<String> urlArr = sCode.split('/');
        String hmac = urlArr.last;
        /*
        * start to get data from api
        */
        String fullName;
        String position;
        String office;
        String classGroup;
        String facePic;
        String placeHolder;
        String gender;
        /*
        * use enum to transform colorN
        * to a color object below
        */
        String color1;
        String color2; // data coming from api
        String color3; // as hex color value
        String color4;

        // for socket
        String id;
        String profileid;
        String qrcode;
        String gate = await _gateRetriever();

        // FormData formData = new FormData.fromMap({
        //   "name": "wendux",
        //   "age": 25,
        // });

        // Response response = await dio.post(url, data: formData);

        // response = await dio.post(
        //   "http://www.dtworkroom.com/doris/1/2.0.0/test",
        //   data: {"aa": "bb" * 22},
        //   onSendProgress: (int sent, int total) {
        //     print("$sent $total");
        //   },
        // );

        // uncomment lines below for ciss API

        dio = Dio();

        dio.interceptors.add(
          RetryOnConnectionChangeInterceptor(
            requestRetrier: DioConnectivityRequestRetrier(
              dio: Dio(),
              connectivity: Connectivity(),
            ),
          ),
        );

        String url = "http://210.213.193.149/api/profile/${hmac}";

        if (hmac.contains('VEHICLE')) {
          url = "http://210.213.193.149/api/vehicle/${hmac}";
        }

        // Dio dio = new Dio();
        dio.options.headers["Authorization"] = "Bearer ${_token}";

        Response response = await dio.get(url);

        // handle not found
        if (response.data == null) {
          return Weather.notFound();
        }

        Map data = response.data;

        // end uncomment lines below for ciss API
        if (hmac.contains('VEHICLE')) {
          // use vehicle profile
          fullName = data['platenumber'];
          position =
              data['make'] + ' ' + data['series'] + ' [' + data['color'] + ']';
          office = data['vehicleowner'];
          classGroup = data['parkingslot'];
          String _facePic = data['vehiclephoto'];
          facePic = _facePic.replaceAll(
              'http://192.168.23.60/', 'http://58.69.10.203/');
          placeHolder = 'female.jpg';
          gender = 'female';
          // for socket
          id = data['_id'].toString();
          profileid = data['controlnumber'];
          qrcode = data['qrcode'];
        } else {
          // use human profile
          fullName = data['name']['first'] + ' ' + data['name']['last'];
          // if clause here on what field to
          // display depending on distinction
          position = data['employee']['position'];
          office = data['employee']['office'] +
              ' [' +
              data['employee']['recordstatus'].toString().toUpperCase() +
              ']';
          // end if clause
          classGroup = data['distinction'];
          String _facePic = data['photothumbnailurl'];
          facePic = _facePic.replaceAll(
              'http://192.168.23.60/', 'http://58.69.10.203/');
          placeHolder = 'male.jpg';
          print(data['gender'].toString().trim());
          if (data['gender'].toString().trim() == 'male') {
            placeHolder = 'male.jpg';
          } else {
            placeHolder = 'female.jpg';
          }
          gender = data['gender'].toString().trim();
          // for socket
          id = data['_id'].toString();
          profileid = data['profileid'];
          qrcode = data['cissinqtext'];
        }

        // additional fields for socket io
        // to add to Weather class
        //
        // id
        // profileid
        // gate
        // qrcode
        // datetime
        var datetime = new DateTime.now();

        /*
        * colors values should come from
        * colorN's equivalent enum value
        */
        /*
        * create a function to convert colors
        */
        Color one = Colors.green;
        Color two = Colors.blue;
        Color three = Color.fromRGBO(255, 255, 255, 0.87);
        Color four = Colors.red;

        // uncomment lines below for ciss API

        dio.interceptors.removeLast();
        dio = null;

        // end uncomment lines below for ciss API

        // dynamic person = {
        //   'id': sCode,
        //   'profileid': 'replace-this-value' + sCode,
        //   'name': fullName,
        //   'gender': gender,
        //   'imagepath': facePic,
        //   'distinction': classGroup,
        //   'gate': 'GATE-7',
        //   'qrcode': 'replace-this-value',
        //   'datetime': datetime.toIso8601String(),
        //   'completed': false,
        // };

        dynamic person = {
          'id': id,
          'profileid': profileid,
          'name': fullName,
          'gender': gender,
          'imagepath': facePic,
          'distinction': classGroup,
          'gate': gate,
          'qrcode': qrcode,
          'datetime': datetime.toIso8601String(),
          'completed': false,
        };

        dynamic _res = await _sendNotification(person);

        print(_res);

        // socketService.deliverSocketMessage('list:feed', person);

        // // Return "fetched" weather
        return Weather(
            sCode: sCode,
            fullName: fullName,
            position: position,
            office: office,
            classGroup: classGroup,
            facePic: facePic,
            placeHolder: placeHolder,
            gender: gender,
            one: one,
            two: two,
            three: three,
            four: four,
            id: id,
            profileid: profileid,
            qrcode: qrcode,
            gate: gate);
      },
    );
  }

  // send notification
  Future<dynamic> _sendNotification(dynamic person) async {
    var url = 'http://58.69.10.198/send-notification';

    var body = json.encode(person);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(url, body: body, headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var _res = json.decode(response.body);

    return _res;
  }
  // end send notification

  Future<String> _tokenRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 'an invalid token';
    print(token);
    return token;
  }

  Future<String> _gateRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('location') ?? 'CISS MOBILE';
    print(location);
    return location;
  }

  // @override
  Future<Weather> oldFetchWeather(String sCode) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 2),
      () async {
        /*
        * start to get data from api
        */

        String fullName;
        String position;
        String office;
        String classGroup;
        String facePic;
        String placeHolder;
        String gender;

        /*
        * use enum to transform colorN
        * to a color object below
        */
        String color1;
        String color2; // data coming from api
        String color3; // as hex color value
        String color4;

        // final random = Random();

        // Simulate some network error
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }

        /*
        * Since we're inside a fake repository, we need to cache the temperature
        * in order to have the same one returned in for the detailed weather
        * cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();
        */

        final _random = new Random();

        /*
        * Generates a positive random integer uniformly distributed on the range
        * from [min], inclusive, to [max], exclusive.
        */

        int next(int min, int max) => min + _random.nextInt(max - min);

        int intNow = next(1, 3);
        String genderNow = genderMap[intNow];
        int picRand = next(1, 5);
        String picNow =
            genderNow == 'male' ? maleMap[picRand] : femaleMap[picRand];
        String placeholderNow = placeholderMap[genderNow];

        const faker = Faker();

        // uncomment lines below for ciss API

        // dio = Dio();

        // dio.interceptors.add(
        //   RetryOnConnectionChangeInterceptor(
        //     requestRetrier: DioConnectivityRequestRetrier(
        //       dio: Dio(),
        //       connectivity: Connectivity(),
        //     ),
        //   ),
        // );

        // Response response = await dio.get('http://worldtimeapi.org/api/ip');

        // handle not found
        // if (response.data == null) {
        //   return Weather.notFound();
        // }

        // end uncomment lines below for ciss API

        fullName = faker.person.name();
        position = faker.job.title();
        office = faker.company.name();
        classGroup = faker.sport.name();
        facePic = picNow;
        placeHolder = placeholderNow;
        gender = genderNow;

        // additional fields for socket io
        // to add to Weather class
        //
        // id
        // profileid
        // gate
        // qrcode
        // datetime
        var datetime = new DateTime.now();

        /*
          * colors values should come from
          * colorN's equivalent enum value
          */
        Color one = Colors.green;
        Color two = Colors.blue;
        Color three = Color.fromRGBO(255, 255, 255, 0.87);
        Color four = Colors.red;

        // uncomment lines below for ciss API

        // dio.interceptors.removeLast();
        // dio = null;

        // end uncomment lines below for ciss API

        // dynamic person = {
        //   'id': sCode,
        //   'profileid': 'replace-this-value' + sCode,
        //   'name': fullName,
        //   'gender': gender,
        //   'imagepath': facePic,
        //   'distinction': classGroup,
        //   'gate': 'GATE-7',
        //   'qrcode': 'replace-this-value',
        //   'datetime': datetime,
        //   'completed': false,
        // };

        // socketService.deliverSocketMessage('list:feed', person);

        // // Return "fetched" weather
        return Weather(
          sCode: sCode,
          fullName: fullName,
          position: position,
          office: office,
          classGroup: classGroup,
          facePic: facePic,
          placeHolder: placeHolder,
          gender: gender,
          one: one,
          two: two,
          three: three,
          four: four,
          id: 'id',
          profileid: 'profileid',
          qrcode: 'qrcode',
          gate: 'gate',
        );
      },
    );
  }
}

class NetworkError extends Error {}
