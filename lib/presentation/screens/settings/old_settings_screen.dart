import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/providers/theme_provider.dart'; // Adjust the import path as needed

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _showLicenseDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('MIT License'),
        content: SingleChildScrollView(
          child: Text(
            '''MIT License

Copyright (c) 2024 OpenLabX

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Access the ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light Mode'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Mode'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _showLicenseDialog(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('MIT License'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL('https://openlabx.com'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('About Us'),
            ),
            SizedBox(height: 20),
            FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text('Version ${snapshot.data ?? '1.0.0'}'),
                );
              },
            ),
            SizedBox(height: 40),
            Text(
              'In pursuit of innovation,\nOpenLabX Team',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 10),
            Text(
              'Contact Us:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () => _launchURL('mailto:contact@openlabx.com'),
                ),
                Text('Email: contact@openlabx.com'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Follow Us:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Center the icons to avoid overflow
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/icons/ig_64px.png',
                    width: 48.0, // Set the width of the image
                    height: 48.0, // Set the height of the image
                  ),
                  onPressed: () => _launchURL(
                      'https://www.instagram.com/openlabx_official/'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/x_64px.png',
                    width: 48.0, // Set the width of the image
                    height: 48.0, // Set the height of the image
                  ),
                  onPressed: () => _launchURL('https://x.com/openlabx'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/fb_64px.png',
                    width: 48.0, // Set the width of the image
                    height: 48.0, // Set the height of the image
                  ),
                  onPressed: () =>
                      _launchURL('https://www.facebook.com/openlabx/'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/yt_64px.png',
                    width: 48.0, // Set the width of the image
                    height: 48.0, // Set the height of the image
                  ),
                  onPressed: () =>
                      _launchURL('https://www.youtube.com/@OpenLabX'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/git_64px.png',
                    width: 48.0, // Set the width of the image
                    height: 48.0, // Set the height of the image
                  ),
                  onPressed: () => _launchURL('https://github.com/openlab-x'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
