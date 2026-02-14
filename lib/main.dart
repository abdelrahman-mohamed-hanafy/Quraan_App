import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quraan/controllers/QuranReaderController.dart';
import 'package:quraan/controllers/SignUpController.dart';
import 'package:quraan/controllers/SurahController.dart';
import 'package:quraan/controllers/home_controller.dart';
import 'package:quraan/screens/SurahPage.dart';
import 'package:quraan/screens/home_page.dart';
import 'package:quraan/screens/signUp_page.dart';
import 'package:quraan/services/LocationService.dart';
import 'package:quraan/services/PrayerTimesService.dart';
import 'package:quraan/services/QuranService.dart';
import 'package:quraan/services/SupabaseService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/LoginController.dart';
import 'screens/QuranReaderPage.dart';
import 'screens/logIn_page.dart';
import 'services/CacheService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uuymwrpwmagsyzdrxwfp.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );

  await Hive.initFlutter();

  Get.put<UserService>(UserService(), permanent: true);
  final cacheService = CacheService();
  await cacheService.init();
  Get.put<CacheService>(cacheService, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => QuranService(), fenix: true);
        Get.lazyPut(() => PrayerTimesService(), fenix: true);
        Get.lazyPut(() => LocationService(), fenix: true);
      }),

      initialRoute: '/home',

      getPages: [
        GetPage(
          name: '/home',
          page: () => HomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => HomeController());
          }),
        ),
        GetPage(
          name: '/Sign',
          page: () => SignUpPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => SignUpController());
          }),
        ),
        GetPage(
          name: '/LogIn',
          page: () => LoginPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => LoginController());
          }),
        ),
        GetPage(
          name: '/Surah',
          page: () => SurahPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => SurahController());
          }),
        ),
        GetPage(
          name: '/reader',
          page: () => QuranReaderPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => QuranReaderController());
          }),
        ),

      ],
    );
  }
}
