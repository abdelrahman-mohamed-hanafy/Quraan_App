import 'package:hive/hive.dart';
import 'package:quraan/models/ChapterModel.dart';
import 'package:quraan/models/VerseModel.dart';
import 'package:supabase/supabase.dart';

class CacheService {
  // =========================
  // 🔹 Box Names
  // =========================
  static const String appBox = 'app_cache';
  static const String chaptersBox = 'quran_chapters';
  static const String versesBox = 'quran_verses';

  // =========================
  // 🔹 Hive Boxes
  // =========================
  late final Box _appBox;
  late final Box _chaptersBox;
  late final Box _versesBox;

  /// Initialize all Hive boxes
  Future<void> init() async {
    _appBox = await Hive.openBox(appBox);
    _chaptersBox = await Hive.openBox(chaptersBox);
    _versesBox = await Hive.openBox(versesBox);
  }

  // =========================
  // 🔹 Prayer Times
  // =========================
  Future<void> savePrayerTimes(
      Map<String, String> timings, double lat, double lng) async {
    await _appBox.put('prayer_timings', timings);
    await _appBox.put(
      'prayer_date',
      DateTime.now().toIso8601String().split('T')[0],
    );
    await _appBox.put('prayer_lat', lat);
    await _appBox.put('prayer_lng', lng);
  }

  bool _isSameLocation(double? a, double? b) {
    if (a == null || b == null) return false;
    return (a - b).abs() < 0.0001;
  }

  Future<Map<String, String>?> getPrayerTimes(double lat, double lng) async {
    final timings = _appBox.get('prayer_timings');
    final date = _appBox.get('prayer_date');
    final cachedLat = _appBox.get('prayer_lat') as double?;
    final cachedLng = _appBox.get('prayer_lng') as double?;
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (timings != null &&
        date == today &&
        _isSameLocation(lat, cachedLat) &&
        _isSameLocation(lng, cachedLng)) {
      return Map<String, String>.from(timings);
    }

    return null;
  }

  Future<Map<String, String>?> getLastPrayerTimes() async {
    final timings = _appBox.get('prayer_timings');
    if (timings != null) return Map<String, String>.from(timings);
    return null;
  }

  // =========================
  // 🔹 User Data
  // =========================
  Future<void> saveUserName(String userId, String name) async {
    await _appBox.put('user_name_$userId', name);
  }

  Future<String?> getUserName(String userId) async {
    return _appBox.get('user_name_$userId');
  }

  Future<void> clearUserData(String userId) async {
    await _appBox.delete('user_name_$userId');
    await _appBox.delete('prayer_timings');
    await _appBox.delete('prayer_date');
    await _appBox.delete('prayer_lat');
    await _appBox.delete('prayer_lng');
  }

  // =========================
  // 🔹 Quran Chapters
  // =========================
  Future<void> saveChapters(List<ChapterModel> chapters) async {
    final data = chapters.map((e) => e.toJson()).toList();
    await _chaptersBox.put('chapters_list', data);
  }

  List<ChapterModel> getChapters() {
    final data = _chaptersBox.get('chapters_list');
    if (data == null) return [];
    return (data as List)
        .map((e) => ChapterModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // =========================
  // 🔹 Quran Verses
  // =========================
  Future<void> saveVerses(int chapterId, List<VerseModel> verses) async {
    final Map<String, Map<String, dynamic>> data = {
      for (var verse in verses) verse.verseNumber.toString(): verse.toJson()
    };
    await _versesBox.put(chapterId.toString(), data);
  }

  List<VerseModel>? getVerses(int chapterId) {
    final data = _versesBox.get(chapterId.toString());
    if (data == null) return null;

    return (data as Map).values
        .map((e) => VerseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // =========================
  // 🔹 (Last Read)
  // =========================
  Future<void> saveLastRead(int page, String surah) async {
    await _appBox.put('last_read_page', page);
    await _appBox.put('last_read_surah', surah);

    print('Saved last read page: $page');
    print('Saved last read surah: $surah');
  }
  Future<int?> getLastReadPage() async {
    return _appBox.get('last_read_page');
  }

  Future<String?> getLastReadSurah() async {
    return _appBox.get('last_read_surah');
  }

}
