import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io' as io;

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  String _inputData = '';

  Future<void> _saveQRCode() async {
    try {
      // Get the external storage directory
      final directory = await getExternalStorageDirectory();

      // Define the path to the Pictures directory
      final path = '/storage/emulated/0/Pictures/QR_Codes';

      // Ensure the directory exists
      await io.Directory(path).create(recursive: true);

      // Save the screenshot to the specified directory
      final imagePath = await _screenshotController.captureAndSave(path,
          fileName: 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code saved to $imagePath')),
      );

      // Optionally, refresh the gallery so the image appears immediately
      await io.File(imagePath!).create();
    } catch (e) {
      print('Error saving QR code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save QR code.')),
      );
    }
  }

  Future<void> _shareQRCode() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await _screenshotController
          .captureAndSave(directory.path, fileName: 'qr_code.png');
      if (imagePath != null) {
        final file = io.File(imagePath);
        await Share.shareXFiles([XFile(file.path)],
            text: 'Here is your QR code!');
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
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: QrImageView(
                        data: _inputData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
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
