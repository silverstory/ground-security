import 'dart:math';
import 'package:flutter/material.dart';

import 'model/weather.dart';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:groundsecurity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:groundsecurity/interceptor/retry_interceptor.dart';

import 'package:faker/faker.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
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
      Duration(seconds: 3),
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

        final random = Random();

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

        fullName = faker.person.name();
        position = faker.job.title();
        office = faker.company.name();
        classGroup = faker.sport.name();
        facePic = picNow;
        placeHolder = placeholderNow;
        gender = genderNow;

        /*
          * colors values should come from
          * colorN's equivalent enum value
          */
        Color one = Colors.green;
        Color two = Colors.blue;
        Color three = Color.fromRGBO(255, 255, 255, 0.87);
        Color four = Colors.red;

        dio.interceptors.removeLast();
        dio = null;

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
