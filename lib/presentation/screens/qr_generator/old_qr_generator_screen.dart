import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:html' as html if (dart.library.html) 'dart:html';
import 'dart:io' as io if (dart.library.io) 'dart:io';

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  String _inputData = '';

  Future<void> _saveQRCode() async {
    if (kIsWeb) {
      // Web-specific saving logic
      Uint8List? capturedImage = await _screenshotController.capture();
      if (capturedImage != null) {
        final blob = html.Blob([capturedImage]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'qr_code.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture QR code image.')),
        );
      }
    } else {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await _screenshotController.captureAndSave(directory.path, fileName: 'qr_code.png');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code saved to $imagePath')),
        );
        // Optionally save to gallery using gallery_saver package if desired
      } catch (e) {
        print('Error saving QR code: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save QR code.')),
        );
      }
    }
  }

  Future<void> _shareQRCode() async {
    if (kIsWeb) {
      // Web-specific sharing logic (may not work on all browsers)
      Uint8List? capturedImage = await _screenshotController.capture();
      if (capturedImage != null) {
        final blob = html.Blob([capturedImage]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'qr_code.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture QR code image.')),
        );
      }
    } else {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await _screenshotController.captureAndSave(directory.path, fileName: 'qr_code.png');
        if (imagePath != null) {
          final file = io.File(imagePath);
          await Share.shareXFiles([XFile(file.path)], text: 'Here is your QR code!');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to capture QR code image.')),
          );
        }
      } catch (e) {
        print('Error sharing QR code: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share QR code.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter data for QR Code',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _inputData = value;
                });
              },
            ),
            SizedBox(height: 20),
            _inputData.isEmpty
                ? Container()
                : Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      color: Colors.white,  // Ensure white background
                      padding: const EdgeInsets.all(20.0),
                      child: QrImageView(
                        data: _inputData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,  // Also set QR code background
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_inputData.isNotEmpty) {
                      _saveQRCode();
                    }
                  },
                  child: Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_inputData.isNotEmpty) {
                      _shareQRCode();
                    }
                  },
                  child: Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
