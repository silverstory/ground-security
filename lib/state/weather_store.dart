import 'package:groundsecurity/data/model/weather.dart';
import 'package:groundsecurity/data/weather_repository.dart';

class WeatherStore {
  final WeatherRepository _weatherRepository;

  WeatherStore(this._weatherRepository);

  Weather _weather;
  Weather get weather => _weather;

  void getWeather(String cityName) async {
    _weather = await _weatherRepository.fetchWeather(cityName);
  }
}
