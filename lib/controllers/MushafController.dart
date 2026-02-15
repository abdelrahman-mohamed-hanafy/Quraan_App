import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/PageVerseModel.dart';
import '../models/ChapterModel.dart';
import '../services/QuranService.dart';

class MushafController extends GetxController {
  final service = Get.find<QuranService>();

  final RxInt currentPage = 1.obs;
  final RxMap<int, List<PageVerseModel>> pagesCache = <int, List<PageVerseModel>>{}.obs;

  PageController pageController = PageController();

  List<ChapterModel> chapters = [];

  final RxString currentSurahName = ''.obs;
  RxDouble currentScale = 1.0.obs;
  RxBool isZooming = false.obs;

  @override
  void onInit() {
    super.onInit();

    int startPage = Get.arguments?['page'] ?? 1;
    currentPage.value = startPage;

    pageController = PageController(initialPage: startPage - 1);

    _initData(startPage);
  }

  void _initData(int startPage) async {
    chapters = await service.getChapters();
    await loadPage(startPage);
  }

  final TransformationController transformationController =
  TransformationController();

  Future<void> loadPage(int pageNumber) async {
    if (pagesCache.containsKey(pageNumber)) return;

    final verses = await service.getPageVerses(pageNumber);

    pagesCache[pageNumber] = verses;

    _updateSurahName(verses);

    preloadNext(pageNumber);
  }

  void preloadNext(int page) {
    if (page + 1 <= 604) service.getPageVerses(page + 1);
    if (page + 2 <= 604) service.getPageVerses(page + 2);
  }

  void onPageChanged(int index) async {
    currentPage.value = index + 1;
    await loadPage(currentPage.value);

    final verses = pagesCache[currentPage.value];
    if (verses != null && verses.isNotEmpty) {
      _updateSurahName(verses);
    }
  }

  void _updateSurahName(List<PageVerseModel> verses) {
    final chapterId = verses.first.chapterId;
    final chapter = chapters.firstWhereOrNull((c) => c.id == chapterId);
    currentSurahName.value = chapter?.nameArabic ?? '';
  }

  bool shouldShowBasmala(List<PageVerseModel> verses) {
    final first = verses.first;

    if (first.chapterId == 1) return false;
    if (first.chapterId == 9) return false; // التوبة مفيهاش بسملة

    return first.verseNumber == 1;
  }
  bool isFirstPageOfSurah(List<PageVerseModel> verses) {
    return verses.first.verseNumber == 1;
  }

  String getSurahName(int chapterId) {
    final chapter = chapters.firstWhereOrNull((c) => c.id == chapterId);
    return chapter?.nameArabic ?? '';
  }

}
