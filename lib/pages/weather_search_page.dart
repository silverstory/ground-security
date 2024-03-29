import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/model/weather.dart';
// import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/main.dart';
import 'package:groundsecurity/pages/city_input_field.dart';
import 'package:groundsecurity/pages/infos/access_badge.dart';
import 'package:groundsecurity/pages/infos/basic_info.dart';
import 'package:groundsecurity/pages/infos/class_info.dart';
import 'package:groundsecurity/pages/infos/face_image.dart';
import 'package:groundsecurity/pages/scanner.dart';
import 'package:groundsecurity/services/socket_service.dart';
import 'package:groundsecurity/state/camera_state.dart';
// import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';

import 'package:provider/provider.dart';

class WeatherSearchPage extends StatefulWidget {
  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  final SocketService socketService = injector.get<SocketService>();
  Color accessFont = Colors.black;
  final asset = AssetFlare(
      bundle: rootBundle, name: "assets/flare/meteor_loading_eprel.flr");
  final pinAsset = AssetFlare(
      bundle: rootBundle, name: "assets/flare/pin_location_eprel.flr");

  // final weatherStore = RM.inject(() => WeatherStore(FakeWeatherRepository()));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CameraState(),
      child: Container(
        padding: EdgeInsets.only(top: 2.0, bottom: 16.0),
        alignment: Alignment.center,
        child: On.all(
          onIdle: () => buildInitialInput(),
          onWaiting: () => buildLoading(),
          onData: () => buildColumnWithData(weatherStore.state.weather),
          onError: (err, refresh) => buildInitialInput(),
        ).listenTo(weatherStore),

        // StateBuilder<WeatherStore>(
        //   models: [Injector.getAsReactive<WeatherStore>()],
        //   builder: (_, reactiveModel) {
        //     return reactiveModel.whenConnectionState(
        //       onIdle: () => buildInitialInput(),
        //       onWaiting: () => buildLoading(),
        //       onData: (store) => buildColumnWithData(store.weather),
        //       onError: (_) => buildInitialInput(),
        //     );
        //   },
        // ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Column(
      children: <Widget>[
        ScannerWidget(context: context),
        SizedBox(height: 30.0),
        Center(
          // child: CityInputField(),
          child: SizedBox(height: 5.0,),
        )
      ],
    );
  }

  Widget buildLoading() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 350.0,
        maxWidth: 350.0,
      ),
      child: FlareCacheBuilder(
        [asset],
        builder: (BuildContext context, bool _) {
          return FlareActor.asset(
            asset,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'Idle',
          );
        },
      ),
    );
  }

  Column buildColumnWithData(Weather weather) {
    // var datetime = new DateTime.now();

    // // socket send
    // dynamic person = {
    //   'id': weather.id,
    //   'profileid': weather.profileid,
    //   'name': weather.fullName,
    //   'gender': weather.gender,
    //   'imagepath': weather.facePic,
    //   'distinction': weather.classGroup,
    //   'gate': weather.gate,
    //   'qrcode': weather.qrcode,
    //   'datetime': datetime.toIso8601String(),
    //   'completed': false,
    // };
    // if (weather.sCode != '00000000') {
    //   // use api here instead of socket io
    //   Future<dynamic> res = _sendNotification(person);
    //   // one for livefeed
    //   // socketService.deliverSocketMessage('list:feed', person);
    //   // and another for entirelistfeed
    //   // socketService.deliverSocketMessage('entirelist:add', person);
    // }
    // // end socket send

    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          type: MaterialType.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          color: Color.fromRGBO(255, 255, 255, 0.07),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95, // double.infinity,
            height: 580.0, // 580.0 // old 650.0, // 530.0,
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.topCenter,
              fit: StackFit.loose,
              children: <Widget>[
                Positioned(
                  top: 0.0,
                  height: 200.0, // 290.0, //170.0,
                  child: ClassInfo(context: context, weather: weather),
                ),
                Positioned(
                  bottom: 0.0,
                  height: 400.0, // 400.0 // 360.0,
                  child: BasicInfo(context: context, weather: weather),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0, // 120.0,
                  ),
                  child: FaceImage(weather: weather),
                ),
              ],
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: Divider(
            height: 70.0,
            thickness: 12.0,
            // Color.fromARGB(255, 255, 222, 3),
            // Color.fromARGB(255, 255, 2, 102),
            // Color.fromARGB(255, 187, 134, 252),
            color: Color.fromRGBO(255, 255, 255, 0.07),
            // indent: 60.0,
            // endIndent: 60.0,
          ),
        ),
        AccessBadge(weather: weather),
        SizedBox(
          height: 30.0,
        ),
        ScannerWidget(context: context),
        SizedBox(height: 30.0),
        // CityInputField(),
      ],
    );
  }
}
