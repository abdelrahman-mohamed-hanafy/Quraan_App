import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quraan/controllers/AudioPlayerController.dart';
import 'package:quraan/controllers/MushafController.dart';
import 'package:quraan/controllers/SignUpController.dart';
import 'package:quraan/controllers/SurahController.dart';
import 'package:quraan/controllers/SurahsByReaderController.dart';
import 'package:quraan/controllers/home_controller.dart';
import 'package:quraan/controllers/readers_controller.dart';
import 'package:quraan/screens/AudioPlayerPage.dart';
import 'package:quraan/screens/SurahPage.dart';
import 'package:quraan/screens/home_page.dart';
import 'package:quraan/screens/signUp_page.dart';
import 'package:quraan/screens/surahsByReaderPage.dart';
import 'package:quraan/services/LocationService.dart';
import 'package:quraan/services/PrayerTimesService.dart';
import 'package:quraan/services/QuranService.dart';
import 'package:quraan/services/SupabaseService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/LoginController.dart';
import 'screens/MushafPage.dart';
import 'screens/logIn_page.dart';
import 'screens/readers_page.dart';
import 'services/CacheService.dart';
import 'services/workManagerService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uuymwrpwmagsyzdrxwfp.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );

  await Hive.initFlutter();

  // Services
  Get.put<UserService>(UserService(), permanent: true);

  final cacheService = CacheService();
  await cacheService.init();
  Get.put<CacheService>(cacheService, permanent: true);

  await WorkManagerService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Global Services
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => QuranService(), fenix: true);
        Get.lazyPut(() => PrayerTimesService(), fenix: true);
        Get.lazyPut(() => LocationService(), fenix: true);

        // ✅ Audio Player Global
        Get.put(AudioPlayerController(), permanent: true);
      }),

      initialRoute: '/home',

      getPages: [
        // ✅ HOME
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: BindingsBuilder(() {
            Get.put(HomeController(), permanent: true);
          }),
        ),

        // ✅ SIGN UP
        GetPage(
          name: '/Sign',
          page: () => const SignUpPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => SignUpController());
          }),
        ),

        // ✅ LOGIN
        GetPage(
          name: '/LogIn',
          page: () => const LoginPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => LoginController());
          }),
        ),

        // ✅ SURAH
        GetPage(
          name: '/Surah',
          page: () => const SurahPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => SurahController());
          }),
        ),

        // ✅ MUSHAf
        GetPage(
          name: '/mushaf',
          page: () => const MushafPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MushafController());
          }),
        ),
        // ✅ READER
        GetPage(
          name: '/readers',
          page: () => ReadersPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => RecitersController());
          }),
        ),
        GetPage(name: '/surahsByReader', page: () =>  SurahsByReaderPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => SurahsByReaderController());
        })
        ),
      ],
    );
  }
}
