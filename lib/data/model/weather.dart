import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Weather {
  // final String facepic;
  // final String gender;
  // final String placeholder;
  // final String cityName;
  // final double temperatureCelsius;

  // orig has the final keyword
  // final String sCode;
  // final String fullName;
  // final String position;
  // final String office;
  // final String classGroup;
  // final String facePic;
  // final String placeHolder;
  // final String gender;
  // final Color one;
  // final Color two;
  // final Color three;
  // final Color four;

  String sCode;
  String fullName;
  String position;
  String office;
  String classGroup;
  String facePic;
  String placeHolder;
  String gender;
  Color one;
  Color two;
  Color three;
  Color four;

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

  Weather.empty() {
    sCode = '00000000';
    fullName = 'error contacting server';
    position = 'Report to ICTO loc. 4286';
    office = 'request disrupted';
    classGroup = 'SERVICE INACCESSIBLE';
    facePic =
        'https://images.pexels.com/photos/2911086/pexels-photo-2911086.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260';
    placeHolder = 'male.jpg';
    gender = 'male';
    one = Color.fromRGBO(255, 255, 255, 0.27);
    two = Color.fromRGBO(255, 255, 255, 0.27);
    three = Color.fromRGBO(255, 255, 255, 0.27);
    four = Color.fromRGBO(255, 255, 255, 0.27);
  }

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

  /* sources:
  * https://bezkoder.com/dart-flutter-constructors/
  */

  /*
  * inaccessible face images
  * https://images.pexels.com/photos/2911086/pexels-photo-2911086.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260
  * https://images.pexels.com/photos/3807738/pexels-photo-3807738.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260
  * https://images.pexels.com/photos/4226215/pexels-photo-4226215.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260
  * https://images.pexels.com/photos/4226221/pexels-photo-4226221.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260
  */
}
