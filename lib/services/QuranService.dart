import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quraan/models/ChapterModel.dart';
import 'package:quraan/models/PageVerseModel.dart';
import 'package:quraan/models/SurahAudioModel.dart';
import 'package:quraan/models/SurahWithAudio.dart';
import 'package:quraan/models/readers.dart';
import 'package:quraan/services/CacheService.dart';

// class QuranService {
//   final cache = Get.find<CacheService>();
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://api.quran.com/api/v4',
//       connectTimeout: Duration(seconds: 10),
//       receiveTimeout: Duration(seconds: 10),
//     )
//   );
//   // جلب اسماء السور
//   Future<List<ChapterModel>> getChapters() async {
//     try {
//       final cachedChapters = await cache.getChapters();
//       if (cachedChapters.isNotEmpty) {
//         return cachedChapters;
//       }
//       final response = await dio.get('/chapters');
//       if (response.statusCode == 200) {
//         final List data = response.data['chapters'];
//         final chapters = data.map((e) => ChapterModel.fromJson(e)).toList();
//
//         await cache.saveChapters(chapters);
//         return chapters;
//       } else {
//         throw Exception('Failed to load chapters');
//       }
//     } catch (e) {
//       throw Exception('Error fetching chapters: $e');
//     }
//   }
//  // جلب ايات السور
//   Future<List<VerseModel>> getVerses(int chapterId) async {
//     final cachedVerses = await cache.getVerses(chapterId);
//     if (cachedVerses != null && cachedVerses.isNotEmpty) {
//       return _processVerses(chapterId, cachedVerses);
//     }
//
//     try {
//       final response = await dio.get(
//         '/verses/by_chapter/$chapterId',
//         queryParameters: {
//           'words': false,
//           'per_page': 300,
//           'fields': 'text_uthmani,verse_number,chapter_id'
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List data = response.data['verses'];
//         final verses = data.map((e) => VerseModel.fromJson(e)).toList();
//
//         await cache.saveVerses(chapterId, verses);
//
//         return _processVerses(chapterId, verses);
//       } else {
//         throw Exception('Failed to load verses');
//       }
//     } catch (e) {
//       print("API ERROR: $e");
//       throw Exception('Error fetching verses: $e');
//     }
//   }
//   // تظبيط عرض الايات
//   List<VerseModel> _processVerses(int chapterId, List<VerseModel> verses) {
//
//     // الفاتحة: نرجعها زي ما هي (البسملة آية 1)
//     if (chapterId == 1) {
//       return verses;
//     }
//
//     // التوبة: بدون بسملة
//     if (chapterId == 9) {
//       return verses;
//     }
//
//     // باقي السور: نشيل البسملة من الآيات
//     if (verses.isNotEmpty &&
//         verses.first.verseNumber == 1 &&
//         verses.first.arabicText.contains("بِسْمِ اللَّهِ")) {
//       return verses.sublist(1);
//     }
//
//     return verses;
//   }
//
//   Future<List<PageVerseModel>> getPageVerses(int pageNumber) async {
//     try {
//       final response = await dio.get(
//         '/quran/verses/uthmani',
//         queryParameters: {
//           'page_number': pageNumber,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List data = response.data['verses'];
//         return data.map((e) => PageVerseModel.fromJson(e)).toList();
//       } else {
//         throw Exception('Failed to load page verses');
//       }
//     } catch (e) {
//       throw Exception('Error fetching page verses: $e');
//     }
//   }
//   Future<List<Recitation>> getReaders() async {
//     try {
//       final response = await dio.get('/resources/recitations');
//
//       if (response.statusCode == 200) {
//         final readers = Readers.fromJson(response.data);
//         return readers.recitations;
//       } else {
//         throw Exception('Failed to load readers');
//       }
//     } catch (e) {
//       throw Exception('Error fetching readers: $e');
//     }
//   }
//
// }

// more cleaner

class QuranService {
  final cache = Get.find<CacheService>();
  final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.quran.com/api/v4',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ));

  // main function
  Future<Response> _get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Request failed');
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    }
  }

  // السور
  Future<List<ChapterModel>> getChapters() async {
    final cached = await cache.getChapters();
    if (cached.isNotEmpty) return cached;

    final response = await _get('/chapters');
    final List data = response.data['chapters'];

    final chapters =
    data.map((e) => ChapterModel.fromJson(e)).toList();

    await cache.saveChapters(chapters);

    return chapters;
  }

  Future<List<Reciter>?> getReaders() async {
    try {
      final cached = await cache.getReaders();
      if (cached != null && cached.isNotEmpty) return cached;

      final response = await dio.get(
        'https://www.mp3quran.net/api/v3/reciters?language=ar',
      );

      if (response.statusCode == 200) {
        final readers = Readers.fromJson(response.data).reciters;
        await cache.saveReaders(readers);
        return readers;
      } else {
        throw Exception('Failed to load readers');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }



  // الايات
  Future<List<PageVerseModel>> getPageVerses(int pageNumber) async {
    final cached = cache.getPageVerses(pageNumber);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final response = await _get(
      '/quran/verses/uthmani',
      queryParameters: {
        'page_number': pageNumber,
      },
    );

    final List data = response.data['verses'];
    final verses =
    data.map((e) => PageVerseModel.fromJson(e)).toList();
    await cache.savePageVerses(pageNumber, verses);

    return verses;
  }

  Future<List<AudioFile>> getSurahAudiosByReciter(int reciterId) async {
    try {
      final cached = await cache.getSurahAudios(reciterId);
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }

      final readers = await getReaders();
      if (readers == null) return [];

      final reciter = readers.firstWhereOrNull((r) => r.id == reciterId);
      if (reciter == null || reciter.moshaf.isEmpty) {
        return [];
      }

      final moshaf = reciter.moshaf.first;

      final server = moshaf.server.endsWith('/')
          ? moshaf.server
          : "${moshaf.server}/";

      final surahNumbers =
      moshaf.surahList.split(',').map((e) => e.trim()).toList();

      final audioFiles = surahNumbers.map((number) {
        final num = int.parse(number);
        final padded = num.toString().padLeft(3, '0');

        return AudioFile(
          chapterId: num,
          audioUrl: "$server$padded.mp3",
        );
      }).toList();

      await cache.saveSurahAudios(reciterId, audioFiles);

      return audioFiles;
    } catch (e) {
      throw Exception('Failed to load surah audios: $e');
    }
  }
  Future<void> _requestPermission() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<String> downloadSurah(
      SurahWithAudio surah, {
        required Function(double progress) onProgress,
        required CancelToken cancelToken,
      }) async {
    await _requestPermission();

    final dir = Directory('/storage/emulated/0/Download/Quraan');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final safeName =
    surah.surahName.replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '');

    final filePath = "${dir.path}/$safeName.mp3";

    await dio.download(
      surah.audioUrl,
      filePath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(received / total);
        }
      },
    );

    return filePath;
  }
}