import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;

  final assetPlayPause =
      AssetFlare(bundle: rootBundle, name: "assets/flare/qrcode_eprel.flr");

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      type: MaterialType.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      color: Color.fromRGBO(255, 255, 255, 0.07),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: 170.0,
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7.0),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(
                          // Color.fromARGB(255, 255, 2, 102),
                          color: Color.fromARGB(255, 3, 218, 197),
                          width: 2.0,
                        ),
                        // Color.fromARGB(255, 255, 2, 102),
                        color: Color.fromARGB(255, 3, 218, 197),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        //This keeps the splash effect within the circle
                        borderRadius: BorderRadius.circular(
                            800.0), //Something large to ensure a circle
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 50.0,
                              maxWidth: 50.0,
                            ),
                            child: FlareCacheBuilder(
                              [assetPlayPause],
                              builder: (BuildContext context, bool _) {
                                return FlareActor.asset(
                                  assetPlayPause,
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: 'show',
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
