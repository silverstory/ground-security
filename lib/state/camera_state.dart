import 'package:flutter/material.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class CameraState extends ChangeNotifier {
  String _flashState = flashOn;
  String _cameraState = frontCamera;

  String get flashState {
    return _flashState;
  }

  void setFlashState(String newFlashState) {
    _flashState = newFlashState;
    notifyListeners();
  }

  String get cameraState {
    return _cameraState;
  }

  void setCameraState(String newCameraState) {
    _cameraState = newCameraState;
    notifyListeners();
  }
}
