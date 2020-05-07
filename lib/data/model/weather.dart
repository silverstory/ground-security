import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Weather {
  // final String facepic;
  // final String gender;
  // final String placeholder;
  // final String cityName;
  // final double temperatureCelsius;
  final String sCode;
  final String fullName;
  final String position;
  final String office;
  final String classGroup;
  final String facePic;
  final String placeHolder;
  final String gender;
  final Color one;
  final Color two;
  final Color three;
  final Color four;

  Weather(
      {@required this.sCode,
      @required this.fullName,
      @required this.position,
      @required this.office,
      @required this.classGroup,
      @required this.facePic,
      @required this.placeHolder,
      @required this.gender,
      @required this.one,
      @required this.two,
      @required this.three,
      @required this.four});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Weather &&
        o.sCode == sCode &&
        o.fullName == fullName &&
        o.position == position &&
        o.office == office &&
        o.classGroup == classGroup &&
        o.facePic == facePic &&
        o.placeHolder == placeHolder &&
        o.gender == gender &&
        o.one == one &&
        o.two == two &&
        o.three == three &&
        o.four == four;
  }

  @override
  int get hashCode => fullName.hashCode ^ classGroup.hashCode;
}
