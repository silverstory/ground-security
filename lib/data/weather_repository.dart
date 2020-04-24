import 'dart:math';
import 'model/weather.dart';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:groundsecurity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:groundsecurity/interceptor/retry_interceptor.dart';

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
  Future<Weather> fetchWeather(String cityName) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 3),
      () async {
        final random = Random();

        // // Simulate some network error
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }

        // Since we're inside a fake repository, we need to cache the temperature
        // in order to have the same one returned in for the detailed weather
        cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

        final _random = new Random();
        /**
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

        // // Return "fetched" weather
        return Weather(
          facepic: picNow,
          gender: genderNow,
          placeholder: placeholderNow,
          cityName: cityName,
          // Temperature between 20 and 35.99
          temperatureCelsius: cachedTempCelsius,
        );
      },
    );
  }
}

class NetworkError extends Error {}
