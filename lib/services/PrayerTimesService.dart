import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:quraan/services/CacheService.dart';

class PrayerTimesService {
  final Dio _dio;
  final CacheService _cache;

  PrayerTimesService({Dio? dio, CacheService? cache})
      : _dio = dio ?? Dio(),
        _cache = cache ?? Get.find<CacheService>();

  Future<Map<String, String>> fetchPrayerTimes(
      double lat,
      double lng, {
        bool forceRefresh = false,
      }) async {
    if (!forceRefresh) {
      final cached =
      await _cache.getPrayerTimes(lat, lng);
      if (cached != null) return cached;
    }

    try {
      final today = DateTime.now();
      final formattedDate =
          "${today.day}-${today.month}-${today.year}";

      final response = await _dio.get(
        'https://api.aladhan.com/v1/timings/$formattedDate',
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'method': 5,
        },
        options: Options(
          receiveTimeout:
          const Duration(seconds: 10),
          sendTimeout:
          const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final timingsRaw =
            response.data['data']['timings'] ?? {};

        final data =
        timingsRaw.map<String, String>(
              (key, value) =>
              MapEntry(key.toString(), value.toString()),
        );

        await _cache.savePrayerTimes(
            data, lat, lng);

        return data;
      }

      throw Exception('فشل تحميل البيانات');
    } on DioException catch (e) {
      final last =
      await _cache.getLastPrayerTimes();
      if (last != null) return last;

      throw Exception(
          e.message ?? 'خطأ أثناء الاتصال بالخادم');
    } catch (_) {
      final last =
      await _cache.getLastPrayerTimes();
      if (last != null) return last;

      throw Exception('حدث خطأ غير متوقع');
    }
  }
}
