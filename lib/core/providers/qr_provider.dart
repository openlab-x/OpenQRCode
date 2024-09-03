import 'package:flutter/material.dart';

class QRProvider extends ChangeNotifier {
  String? _qrData;

  String? get qrData => _qrData;

  void setQRData(String data) {
    _qrData = data;
    notifyListeners();
  }
}
