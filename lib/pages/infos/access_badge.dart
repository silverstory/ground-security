import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';

class AccessBadge extends StatelessWidget {
  const AccessBadge({
    Key key,
    @required this.accessFont,
    @required this.weather,
  }) : super(key: key);

  final Color accessFont;
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        AvatarGlow(
          glowColor: Colors.green[200],
          endRadius: 55.0,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          curve: Curves.fastLinearToSlowEaseIn,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_1,
                color: Colors.green,
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
        AvatarGlow(
          glowColor: Colors.blue[400],
          endRadius: 55.0,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          curve: Curves.fastLinearToSlowEaseIn,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_2,
                color: Colors.blue,
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
        AvatarGlow(
          glowColor: Colors.white,
          endRadius: 55.0,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          curve: Curves.fastLinearToSlowEaseIn,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_3,
                color: Color.fromRGBO(255, 255, 255, 0.87),
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
        AvatarGlow(
          glowColor: Colors.red,
          endRadius: 55.0,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          curve: Curves.fastLinearToSlowEaseIn,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_4,
                color: Colors.red,
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
      ],
    );
  }
}
