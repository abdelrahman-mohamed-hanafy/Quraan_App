import 'dart:async';
import 'package:get/get.dart';
import 'package:quraan/services/LocationService.dart';
import 'package:quraan/services/SupabaseService.dart';
import 'package:quraan/services/PrayerTimesService.dart';
import 'package:quraan/services/CacheService.dart';
import 'package:quraan/services/workManagerService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final userService = Get.find<UserService>();
  final prayerService = Get.find<PrayerTimesService>();
  final cache = Get.find<CacheService>();
  final  locationService = Get.find<LocationService>();
  final RxString nextPrayer = ''.obs;
  final RxBool lastReadChanged = false.obs;

  final RxString userName = ''.obs;
  final RxBool isUserLoading = false.obs;

  final RxMap<String, String> prayerTimes = <String, String>{}.obs;
  final RxBool isPrayerLoading = false.obs;

  final RxString errorMessage = ''.obs;

  StreamSubscription<AuthState>? _authSub;

  final RxInt lastPage = 1.obs;
  final RxString lastSurah = ''.obs;
  late final prayerTime ;
  String? get _userId =>
      Supabase.instance.client.auth.currentUser?.id;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _listenToAuthChanges();
    loadLastRead();
    ever(lastReadChanged, (_) {
      loadLastRead();
    });
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadUserName(),
      _loadPrayerTimes(),
    ]);
  }

  void _listenToAuthChanges() {
    _authSub =
        userService.authStateChanges.listen((data) {
          if (data.event == AuthChangeEvent.signedIn ||
              data.event == AuthChangeEvent.signedOut ||
              data.event == AuthChangeEvent.userUpdated) {
            _loadUserName();
          }
        });
  }

  // =========================
  // 🔹 Load User Name (Offline First)
  // =========================
  Future<void> _loadUserName() async {
    final userId = _userId;

    if (userId == null) {
      userName.value = 'أهلاً بك';
      return;
    }

    try {
      isUserLoading.value = true;
      errorMessage.value = '';

      String? cachedName =
      await cache.getUserName(userId);

      if (cachedName != null &&
          cachedName.isNotEmpty) {
        userName.value = cachedName;
      }

      try {
        final remoteName = await userService.fetchUserName();

        if (remoteName != null &&
            remoteName.isNotEmpty) {
          userName.value = remoteName;

          if (remoteName != cachedName) {
            await cache.saveUserName(
                userId, remoteName);
          }
        }
      } catch (_) {

      }

      if (userName.value.isEmpty) {
        userName.value = 'أهلاً بك';
      }

    } finally {
      isUserLoading.value = false;
    }
  }

  // =========================
  // 🔹 Load Prayer Times
  // =========================
  Future<void> _loadPrayerTimes(
      {bool forceRefresh = false}) async {
    try {
      errorMessage.value = '';
      isPrayerLoading.value = true;

      final position =
      await locationService.getCurrentLocation();

      final data =
      await prayerService.fetchPrayerTimes(
        position.latitude,
        position.longitude,
        forceRefresh: forceRefresh,
      );
      final filteredArabic = {
        "الفجر": _formatTime(data["Fajr"] ?? ""),
        "الشروق": _formatTime(data["Sunrise"] ?? ""),
        "الظهر": _formatTime(data["Dhuhr"] ?? ""),
        "العصر": _formatTime(data["Asr"] ?? ""),
        "المغرب": _formatTime(data["Maghrib"] ?? ""),
        "العشاء": _formatTime(data["Isha"] ?? ""),
      };

      prayerTimes.assignAll(filteredArabic);
      _calculateNextPrayer();
      final duration = await durationFromNowToNextPrayer();
      //   final duration = const Duration(seconds: 10);

      await WorkManagerService.registerBackgroundTask(
        nextPrayer.value,
        duration,
      );


    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
    } finally {
      isPrayerLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadPrayerTimes(forceRefresh: true);
  }
  void _calculateNextPrayer() {
    if (prayerTimes.isEmpty) return;

    final now = DateTime.now();

    for (var entry in prayerTimes.entries) {
      final timeParts = entry.value.split(":");

      if (timeParts.length < 2) continue;

      final prayerTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      if (prayerTime.isAfter(now)) {
        nextPrayer.value = entry.key;
        return;
      }
    }
    nextPrayer.value = "الفجر";
  }
  String _formatTime(String time) {
    final cleanTime = time.split(" ").first;

    final parts = cleanTime.split(":");
    if (parts.length < 2) return cleanTime;

    int hour = int.parse(parts[0]);
    final minute = parts[1].padLeft(2, '0');

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute";
  }
  // =========================
  // 🔹 Next Prayer Date Time
  // =========================
  DateTime get nextPrayerDateTime {
    final now = DateTime.now();
    final nextPrayerTime = prayerTimes[nextPrayer.value];

    if (nextPrayerTime == null) return now;

    final parts = nextPrayerTime.split(":");
    if (parts.length < 2) return now;

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    DateTime prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (prayerDateTime.isBefore(now)) {
      prayerDateTime = prayerDateTime.add(const Duration(days: 1));
    }

    return prayerDateTime;
  }
  // =========================
  // 🔹 Duration From Now To Next Prayer
  // =========================
  Future<Duration> durationFromNowToNextPrayer() async {
    final now = DateTime.now();
    final duration = await nextPrayerDateTime.difference(now);
    return duration;
  }

  Future<void> loadLastRead() async {
    final page = await cache.getLastReadPage();
    final surah = await cache.getLastReadSurah();

    if (page != null) lastPage.value = page;
    if (surah != null) lastSurah.value = surah;
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }
}
