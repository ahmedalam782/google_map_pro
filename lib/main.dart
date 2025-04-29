import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_pro/core/storage/cache_helper.dart';
import 'package:google_map_pro/core/storage/lang.dart';
import 'package:google_map_pro/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppSharedPreferences.initialSharedPreference();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [arabicLocal, englishLocal],
      fallbackLocale: arabicLocal,
      startLocale: arabicLocal,
      path: assetsLocalization,
      child: const GoogleMapPackage(),
    ),
  );
}

class GoogleMapPackage extends StatelessWidget {
  const GoogleMapPackage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      locale: context.locale,
      localizationsDelegates: [
        ...context.localizationDelegates,
      ],
      supportedLocales: [
        ...context.supportedLocales,
        const Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
        const Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG'),
      ],
    );
  }
}

