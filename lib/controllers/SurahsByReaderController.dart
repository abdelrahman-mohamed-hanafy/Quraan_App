import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/SurahWithAudio.dart';
import '../services/QuranService.dart';

class SurahsByReaderController extends GetxController {
  final QuranService service = Get.find<QuranService>();

  final RxList<SurahWithAudio> surahs = <SurahWithAudio>[].obs;
  final RxBool isLoading = false.obs;

  final RxMap<int, double> downloadProgress = <int, double>{}.obs;
  final Map<int, CancelToken> cancelTokens = {};

  late int reciterId;
  late String reciterName;
  final RxBool isDownloadingAll = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    reciterId = args['id'];
    reciterName = args['name'];

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final audioFiles = await service.getSurahAudiosByReciter(reciterId);
      final chapters = await service.getChapters();

      final result = <SurahWithAudio>[];

      for (final audio in audioFiles) {
        final chapter =
        chapters.firstWhereOrNull((c) => c.id == audio.chapterId);

        if (chapter == null) continue;

        result.add(
          SurahWithAudio(
            surahId: audio.chapterId,
            surahName: chapter.nameArabic,
            audioUrl: audio.audioUrl,
          ),
        );
      }

      surahs.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  /// تحميل سورة واحدة
  Future<bool> downloadSurah(SurahWithAudio surah) async {
    if (downloadProgress.containsKey(surah.surahId)) return false;

    final cancelToken = CancelToken();
    cancelTokens[surah.surahId] = cancelToken;
    downloadProgress[surah.surahId] = 0;

    bool completed = false;

    try {
      await service.downloadSurah(
        surah,
        cancelToken: cancelToken,
        onProgress: (p) {
          downloadProgress[surah.surahId] = p;
        },
      );

      completed = true; // تم التحميل بنجاح
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        completed = false; // تم الإلغاء
        print("تم إلغاء تحميل ${surah.surahName}");
      } else {
        print("خطأ في التحميل: $e");
      }
    } finally {
      downloadProgress.remove(surah.surahId);
      cancelTokens.remove(surah.surahId);
    }

    return completed;
  }

  /// تحميل كل السور
  Future<bool> downloadAllSurahs() async {
    if (isDownloadingAll.value) return false;

    isDownloadingAll.value = true;
    bool completedAll = true;

    for (final surah in surahs) {
      if (!isDownloadingAll.value) {
        completedAll = false;
        break;
      }

      await downloadSurah(surah);
    }

    isDownloadingAll.value = false;
    return completedAll;
  }


  void cancelDownload(int surahId) {
    if (cancelTokens.containsKey(surahId)) {
      cancelTokens[surahId]!.cancel();
    }
  }
  void cancelAllDownloads() {
    for (final token in cancelTokens.values) {
      token.cancel();
    }

    cancelTokens.clear();
    downloadProgress.clear();
    isDownloadingAll.value = false;
  }


}
