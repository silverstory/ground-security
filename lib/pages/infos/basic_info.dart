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
    double c_width = MediaQuery.of(context).size.width * 0.9;
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
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // .end
                      children: <Widget>[
                        Container(
                          width: c_width,
                          child: Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              weather.position,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                wordSpacing: 6.0,
                                letterSpacing: 6.0,
                                fontSize: 21.0,
                                // Color.fromARGB(255, 3, 54, 255),
                                color: Color.fromRGBO(255, 255, 255, 0.6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        Container(
                          width: c_width,
                          child: Flexible(
                            fit: FlexFit.tight,
                            child: Text(
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
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          width: c_width,
                          child: Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              '📍 ' + weather.office,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                wordSpacing: 6.0,
                                letterSpacing: 6.0,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                // Color.fromARGB(255, 2, 53, 255),
                                color: Color.fromARGB(255, 114, 114, 114),
                              ),
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     Icon(
                        //       Icons.pin_drop,
                        //       size: 35.0,
                        //       // Color.fromARGB(255, 2, 53, 255),
                        //       color: Color.fromARGB(255, 255, 2, 102),
                        //     ),
                        //     SizedBox(
                        //       width: 15.0,
                        //     ),
                        //     Text(
                        //       weather.office,
                        //       textAlign: TextAlign.center,
                        //       style: TextStyle(
                        //         wordSpacing: 6.0,
                        //         letterSpacing: 6.0,
                        //         fontSize: 28,
                        //         fontWeight: FontWeight.bold,
                        //         // Color.fromARGB(255, 2, 53, 255),
                        //         color: Color.fromRGBO(255, 255, 255, 0.38),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
