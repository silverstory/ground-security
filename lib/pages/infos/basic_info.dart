import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';

class BasicInfo extends StatelessWidget {
  const BasicInfo({
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
        color: Colors.transparent,
      ),
      height: 45.0,
      width: MediaQuery.of(context).size.width * 0.90,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 54.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'DIRECTOR XCVIII',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    wordSpacing: 6.0,
                    letterSpacing: 6.0,
                    fontSize: 21.0,
                    // Color.fromARGB(255, 3, 54, 255),
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                ),
                SizedBox(
                  height: 22.0,
                ),
                Text(
                  weather.cityName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    wordSpacing: 6.0,
                    letterSpacing: 3.0,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    // Color.fromARGB(255, 30, 30, 30),
                    color: Color.fromRGBO(255, 255, 255, 0.87),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.pin_drop,
                      size: 35.0,
                      // Color.fromARGB(255, 2, 53, 255),
                      color: Color.fromARGB(255, 255, 2, 102),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'ODESFA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        wordSpacing: 6.0,
                        letterSpacing: 6.0,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        // Color.fromARGB(255, 2, 53, 255),
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
