import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:quraan/models/ChapterModel.dart';
import 'package:quraan/models/VerseModel.dart';
import 'package:quraan/services/CacheService.dart';

class QuranService {
  final cache = Get.find<CacheService>();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.quran.com/api/v4',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    )
  );
  // جلب اسماء السور
  Future<List<ChapterModel>> getChapters() async {
    try {
      final cachedChapters = await cache.getChapters();
      if (cachedChapters.isNotEmpty) {
        return cachedChapters;
      }
      final response = await dio.get('/chapters');
      if (response.statusCode == 200) {
        final List data = response.data['chapters'];
        final chapters = data.map((e) => ChapterModel.fromJson(e)).toList();

        await cache.saveChapters(chapters);
        return chapters;
      } else {
        throw Exception('Failed to load chapters');
      }
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }
 // جلب ايات السور
  Future<List<VerseModel>> getVerses(int chapterId) async {
    final cachedVerses = await cache.getVerses(chapterId);
    if (cachedVerses != null && cachedVerses.isNotEmpty) {
      return _processVerses(chapterId, cachedVerses);
    }

    try {
      final response = await dio.get(
        '/verses/by_chapter/$chapterId',
        queryParameters: {
          'words': false,
          'per_page': 300,
          'fields': 'text_uthmani,verse_number,chapter_id'
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['verses'];
        final verses = data.map((e) => VerseModel.fromJson(e)).toList();

        await cache.saveVerses(chapterId, verses);

        return _processVerses(chapterId, verses);
      } else {
        throw Exception('Failed to load verses');
      }
    } catch (e) {
      print("API ERROR: $e");
      throw Exception('Error fetching verses: $e');
    }
  }
  // تظبيط عرض الايات
  List<VerseModel> _processVerses(int chapterId, List<VerseModel> verses) {

    if (chapterId == 9) {
      return verses;
    }

    if (verses.isNotEmpty &&
        verses.first.verseNumber == 1 &&
        verses.first.arabicText.contains("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")) {
      return verses.sublist(1);
    }

    return verses;
  }


}