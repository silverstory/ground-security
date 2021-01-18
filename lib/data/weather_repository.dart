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

        const url = "http://210.213.193.149/profile/${sCode}";

        // Dio dio = new Dio();
        dio.options.headers["Authorization"] = "Bearer ${_token}";

        Response response = await dio.get(url);

        // handle not found
        if (response.data == null) {
          return Weather.notFound();
        }

        Map data = response.data;

        // end uncomment lines below for ciss API

        fullName = data['name']['first'] + ' ' + data['name']['last'];
        // if clause here on what field to
        // display depending on distinction
        position = data['employee']['position'];
        office = data['employee']['office'];
        // end if clause
        classGroup = data['distinction'];
        facePic = data['photothumbnailurl'];
        placeHolder = placeholderMap[data['gender']];
        gender = data['gender'];

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
        );
      },
    );
  }

  Future<String> _tokenRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 'an invalid token';
    print(token);
    return token;
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
        );
      },
    );
  }
}

class NetworkError extends Error {}
