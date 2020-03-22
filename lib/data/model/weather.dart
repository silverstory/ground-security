import 'package:meta/meta.dart';

class Weather {
  final String facepic;
  final String gender;
  final String placeholder;
  final String cityName;
  final double temperatureCelsius;

  Weather({
    @required this.facepic,
    @required this.gender,
    @required this.placeholder,
    @required this.cityName,
    @required this.temperatureCelsius,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Weather &&
        o.facepic == facepic &&
        o.gender == gender &&
        o.placeholder == placeholder &&
        o.cityName == cityName &&
        o.temperatureCelsius == temperatureCelsius;
  }

  @override
  int get hashCode => cityName.hashCode ^ temperatureCelsius.hashCode;
}
