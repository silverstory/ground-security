import 'dart:async';
import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/state/camera_state.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:provider/provider.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  _ScannerWidgetState createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  var qrText = '';
  // var flashState = flashOn;
  // var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  StreamSubscription subscription;

  final assetPlayPause = AssetFlare(
      bundle: rootBundle, name: "assets/flare/play-pause-dark-mode.flr");

  @override
  Widget build(BuildContext context) {
    var _camera = Provider.of<CameraState>(context);
    return Material(
      elevation: 2.0,
      type: MaterialType.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      color: Color.fromRGBO(255, 255, 255, 0.07),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 200.0, // 220
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 180, // 200
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[

                    // FLASH
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          child: IconButton(
                            iconSize: 25.0,
                            color: Color.fromARGB(255, 255, 17, 104),
                            icon: Icon(Icons.lightbulb_outline),
                            tooltip: 'Turn flash on/off',
                            onPressed: () {
                              if (controller != null) {
                                controller.toggleFlash();
                                if (_isFlashOn(_camera.flashState)) {
                                  // setState(() {
                                  _camera.setFlashState(flashOff);
                                  // });
                                } else {
                                  // setState(() {
                                  _camera.setFlashState(flashOn);
                                  // });
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Consumer<CameraState>(
                          builder: (context, camera, child) {
                            return Text(
                              camera.flashState,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(255, 255, 255, 0.87),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // ACTIVE CAMERA
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          child: IconButton(
                            iconSize: 25.0,
                            color: Color.fromARGB(255, 255, 17, 104),
                            icon: Icon(Icons.camera_alt),
                            tooltip: 'Turn flash on/off',
                            onPressed: () {
                              if (controller != null) {
                                controller.flipCamera();
                                if (_isBackCamera(_camera.cameraState)) {
                                  // setState(() {
                                  _camera.setCameraState(frontCamera);
                                  // });
                                } else {
                                  // setState(() {
                                  _camera.setCameraState(backCamera);
                                  // });
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Consumer<CameraState>(
                          builder: (context, camera, child) {
                            return Text(
                              camera.cameraState,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(255, 255, 255, 0.87),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // play flare button
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5.0,
                            bottom: 7.0,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: Color.fromARGB(255, 255, 17, 104),
                                //   width: 3.0,
                                // ),
                                color: Color.fromARGB(255, 0, 0, 0),
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(
                                    800.0), // 1000.0 - Something large to ensure a circle
                                onTap: () {
                                  controller?.resumeCamera();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.0), // all(15.0)
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 50.0, // 50.0,
                                      maxWidth: 50.0, // 50.0,
                                    ),
                                    child: FlareCacheBuilder(
                                      [assetPlayPause],
                                      builder: (BuildContext context, bool _) {
                                        return FlareActor.asset(
                                          assetPlayPause,
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          animation: 'Pause',
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // pause flare button
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5.0,
                            bottom: 7.0,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: Color.fromARGB(255, 0, 0, 0),
                                //   width: 3.0,
                                // ),
                                color: Color.fromARGB(255, 0, 0, 0),
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(
                                    800.0), // 1000.0 - Something large to ensure a circle
                                onTap: () {
                                  controller?.pauseCamera();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.0), // all(15.0)
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 50.0, // 50.0,
                                      maxWidth: 50.0, // 50.0,
                                    ),
                                    child: FlareCacheBuilder(
                                      [assetPlayPause],
                                      builder: (BuildContext context, bool _) {
                                        return FlareActor.asset(
                                          assetPlayPause,
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          animation: 'Play',
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    var _camera = Provider.of<CameraState>(context);
    if (!_isFlashOn(_camera.flashState)) {
      this.controller.toggleFlash();
    }
    if (_isBackCamera(_camera.cameraState)) {
      this.controller.flipCamera();
    }
    this.subscription = controller.scannedDataStream.take(1).listen((data) {
      setState(() {
        qrText = data;
      });
      submitCityName(context, data);
      this.subscription.pause(
            Future.delayed(
                Duration(seconds: 2),
                () => {
                      this.controller.scannedDataStream.drain(),
                    }),
          );
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print('Some Error: $error');
    });
  }

  void submitCityName(BuildContext context, String cityName) {
    final reactiveModel = Injector.getAsReactive<WeatherStore>();
    reactiveModel.setState(
      (store) => store.getWeather(cityName),
      onError: (context, error) {
        if (error is NetworkError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Couldn't fetch weather. Is the device online?"),
            ),
          );
        } else {
          reactiveModel.setState(
            (store) => store.getEmptyWeather(),
          );
          // throw error;
        }
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    controller.dispose();
    super.dispose();
  }
}
