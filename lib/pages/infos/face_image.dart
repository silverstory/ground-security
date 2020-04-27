import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';
import 'package:progressive_image/progressive_image.dart';

class FaceImage extends StatelessWidget {
  const FaceImage({
    Key key,
    @required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      startDelay: Duration(milliseconds: 1000),
      glowColor: Color.fromARGB(255, 102, 18, 222),
      endRadius: 170.0,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        color: Colors.transparent,
        child: CircleAvatar(
          radius: 103,
          backgroundColor: Color.fromARGB(255, 187, 134, 252),
          child: CircleAvatar(
            radius: 100.0,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(100),
              child: ProgressiveImage(
                placeholder: AssetImage('assets/placeholder/placeholder.gif'),
                thumbnail: AssetImage(
                    'assets/placeholder/${weather.placeholder}'), // 64x43 recommended
                image: NetworkImage('${weather.facepic}'),
                height: 200.0,
                width: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      shape: BoxShape.circle,
      animate: true,
      curve: Curves.fastOutSlowIn,
    );
  }
}
