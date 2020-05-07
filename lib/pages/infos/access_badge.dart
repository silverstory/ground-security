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
        // AvatarGlow(
        //   glowColor: Colors.green,
        //   endRadius: 55.0,
        //   duration: Duration(milliseconds: 2000),
        //   repeat: false,
        //   animate: false,
        //   showTwoGlows: true,
        //   curve: Curves.fastLinearToSlowEaseIn,
        //   repeatPauseDuration: Duration(milliseconds: 100),
        CircleAvatar(
          radius: 55.0,
          backgroundColor: Colors.transparent,
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_1,
                color: weather.one,
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
        // AvatarGlow(
        //   glowColor: Colors.blue,
        //   endRadius: 55.0,
        //   duration: Duration(milliseconds: 2000),
        //   repeat: false,
        //   animate: false,
        //   showTwoGlows: true,
        //   curve: Curves.fastLinearToSlowEaseIn,
        //   repeatPauseDuration: Duration(milliseconds: 100),
        CircleAvatar(
          radius: 55.0,
          backgroundColor: Colors.transparent,
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_2,
                color: weather.two,
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
        // AvatarGlow(
        //   glowColor: Color.fromRGBO(255, 255, 255, 0.87),
        //   endRadius: 55.0,
        //   duration: Duration(milliseconds: 2000),
        //   repeat: false,
        //   animate: false,
        //   showTwoGlows: true,
        //   curve: Curves.fastLinearToSlowEaseIn,
        //   repeatPauseDuration: Duration(milliseconds: 100),
        CircleAvatar(
          radius: 55.0,
          backgroundColor: Colors.transparent,
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_3,
                color: weather.three,
                size: 36.0,
              ),
              radius: 40.0,
            ),
          ),
        ),
        // AvatarGlow(
        //   glowColor: Colors.red,
        //   endRadius: 55.0,
        //   duration: Duration(milliseconds: 2000),
        //   repeat: false,
        //   animate: false,
        //   showTwoGlows: true,
        //   curve: Curves.fastLinearToSlowEaseIn,
        //   repeatPauseDuration: Duration(milliseconds: 100),
        CircleAvatar(
          radius: 55.0,
          backgroundColor: Colors.transparent,
          child: Material(
            elevation: 3.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_4,
                color: weather.four,
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
