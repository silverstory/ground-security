import 'dart:math';
import 'model/weather.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
  double cachedTempCelsius;
  Map<String, String> placeholderMap = {
    'male': 'male.jpeg',
    'female': 'female.jpeg'
  };
  Map<int, String> genderMap = {1: 'male', 2: 'female', 3: 'male'};
  Map<int, String> maleMap = {
    1: 'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    2: 'https://images.pexels.com/photos/732425/pexels-photo-732425.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    3: 'https://images.pexels.com/photos/938642/pexels-photo-938642.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
  };
  Map<int, String> femaleMap = {
    1: 'https://images.pexels.com/photos/3891820/pexels-photo-3891820.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    2: 'https://images.pexels.com/photos/1727273/pexels-photo-1727273.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    3: 'https://images.pexels.com/photos/2135135/pexels-photo-2135135.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
  };

  @override
  Future<Weather> fetchWeather(String cityName) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 2),
      () {
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

        int intNow = next(1, 4);
        String genderNow = genderMap[intNow];
        String picNow =
            genderNow == 'male' ? maleMap[intNow] : femaleMap[intNow];
        String placeholderNow = placeholderMap[genderNow];
        // Return "fetched" weather
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
