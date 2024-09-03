// qr_generator_screen.dart

export 'qr_generator_screen_mobile.dart'
    if (dart.library.html) 'qr_generator_screen_web.dart';
