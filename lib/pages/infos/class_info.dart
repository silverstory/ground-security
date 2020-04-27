import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';

class ClassInfo extends StatelessWidget {
  const ClassInfo({
    Key key,
    @required this.context,
    @required this.weather,
  }) : super(key: key);

  final BuildContext context;
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/placeholder/male.jpg'),
          fit: BoxFit.cover,
        ),
        color: Color.fromARGB(255, 3, 54, 255),
      ),
      height: 45.0,
      width: MediaQuery.of(context).size.width * 0.90,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'OP OFFICIAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                wordSpacing: 6.0,
                letterSpacing: 6.0,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
