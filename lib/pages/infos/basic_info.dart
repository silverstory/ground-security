import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    double dWidth = MediaQuery.of(context).size.width * 0.7;
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
            padding: const EdgeInsets.fromLTRB(
                16.0, 0.0, 16.0, 24.0), // .only(bottom: 54.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Expanded(
                  flex: 2,
                  // child: FittedBox(
                  //   fit: BoxFit.contain,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // .end
                    children: <Widget>[
                      SizedBox(
                        width: cWidth,
                        height: 50.0,
                        child: AutoSizeText(
                          weather.position,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            wordSpacing: 6.0,
                            letterSpacing: 6.0,
                            fontSize: 21.0,
                            // Color.fromARGB(255, 3, 54, 255),
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      // SizedBox(
                      //   height: 22.0,
                      // ),
                      SizedBox(
                        width: cWidth,
                        height: 50.0,
                        child: AutoSizeText(
                          weather.fullName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            wordSpacing: 6.0,
                            letterSpacing: 3.0,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            // Color.fromARGB(255, 30, 30, 30),
                            color: Color.fromRGBO(255, 255, 255, 0.87),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      // SizedBox(
                      //   height: 40.0,
                      // ),
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
                          SizedBox(
                            width: dWidth, // c_width - 90,
                            height: 50.0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: AutoSizeText(
                                weather.office,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  wordSpacing: 6.0,
                                  letterSpacing: 6.0,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  // Color.fromARGB(255, 2, 53, 255),
                                  color: Color.fromRGBO(255, 255, 255, 0.38),
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
