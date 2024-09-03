import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'core/themes/light_theme.dart';
import 'core/themes/dark_theme.dart';
import 'core/providers/theme_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Open QR Code',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: HomeScreen(),
          debugShowCheckedModeBanner: false, // Disable the debug banner
        );
      },
    );
  }
}
