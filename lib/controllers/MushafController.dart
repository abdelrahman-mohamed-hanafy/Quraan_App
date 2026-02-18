import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/controllers/home_controller.dart';
import 'package:quraan/services/CacheService.dart';
import '../models/PageVerseModel.dart';
import '../models/ChapterModel.dart';
import '../services/QuranService.dart';

class MushafController extends GetxController {
  final service = Get.find<QuranService>();
  final cache = Get.find<CacheService>();
  final homeController = Get.find<HomeController>();

  final RxInt currentPage = 1.obs;
  final RxMap<int, List<PageVerseModel>> pagesCache = <int, List<PageVerseModel>>{}.obs;

  PageController pageController = PageController();

  List<ChapterModel> chapters = [];

  final RxString currentSurahName = ''.obs;
  RxDouble currentScale = 1.0.obs;

  /// 🔹 متغير لمعرفة إذا جاء المستخدم من صفحة السور
  bool cameFromSurahList = false;

  final TransformationController transformationController = TransformationController();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    int startPage = 1;
    String startSurahName = '';

    if (args != null && args is Map) {
      startPage = args['page'] ?? 1;

      if (args['nameArabic'] != null &&
          args['nameArabic'].toString().isNotEmpty) {
        startSurahName = args['nameArabic'];
        cameFromSurahList = true; // 👈 جاء من صفحة السور
      }
    }

    currentPage.value = startPage;
    pageController = PageController(initialPage: startPage - 1);
    currentSurahName.value = startSurahName;

    _initData(startPage);
  }

  /// 🔹 تحميل البيانات الأساسية للسورة والصفحة
  void _initData(int startPage) async {
    chapters = await service.getChapters();
    await loadPage(startPage);

    final verses = pagesCache[startPage];

    if (verses != null && verses.isNotEmpty) {

      // 👈 لو المستخدم جاي من صفحة السور، الاسم ثابت، ما تغيرش
      if (!cameFromSurahList) {
        _updateSurahName(verses);
      }

      // 👈 حفظ آخر قراءة
      await cache.saveLastRead(startPage, currentSurahName.value);
      homeController.lastReadChanged.toggle();
    }
  }

  /// 🔹 تحميل صفحة معينة مع التخزين المؤقت
  Future<void> loadPage(int pageNumber) async {
    if (pagesCache.containsKey(pageNumber)) return;

    final verses = await service.getPageVerses(pageNumber);
    pagesCache[pageNumber] = verses;

    // 👈 تحديث اسم السورة إذا لم يأتِ من صفحة السور
    if (!cameFromSurahList) {
      _updateSurahName(verses);
    }

    preloadNext(pageNumber);
  }

  /// 🔹 تحميل الصفحات القادمة للتصفح السلس
  void preloadNext(int page) {
    if (page + 1 <= 604) service.getPageVerses(page + 1);
    if (page + 2 <= 604) service.getPageVerses(page + 2);
  }

  /// 🔹 عند تغيير الصفحة
  void onPageChanged(int index) async {
    final newPage = index + 1;

    if (newPage == currentPage.value) return;

    currentPage.value = newPage;

    await loadPage(newPage);

    final verses = pagesCache[newPage];
    if (verses != null && verses.isNotEmpty) {
      _updateSurahName(verses);
    }

    await cache.saveLastRead(newPage, currentSurahName.value);
    homeController.lastReadChanged.toggle();
  }

  /// 🔹 تحديث اسم السورة من الصفحة
  void _updateSurahName(List<PageVerseModel> verses) {
    final chapterId = verses.first.chapterId;
    final chapter = chapters.firstWhereOrNull((c) => c.id == chapterId);
    currentSurahName.value = chapter?.nameArabic ?? '';
  }

  /// 🔹 التحقق من ظهور البسملة
  bool shouldShowBasmala(List<PageVerseModel> verses) {
    final first = verses.first;
    if (first.chapterId == 1) return false;
    if (first.chapterId == 9) return false; // سورة التوبة مفيهاش بسملة
    return first.verseNumber == 1;
  }

  /// 🔹 التحقق إذا كانت الصفحة هي أول صفحة للسورة
  bool isFirstPageOfSurah(List<PageVerseModel> verses) {
    return verses.first.verseNumber == 1;
  }

  /// 🔹 جلب اسم السورة حسب الـ chapterId
  String getSurahName(int chapterId) {
    final chapter = chapters.firstWhereOrNull((c) => c.id == chapterId);
    return chapter?.nameArabic ?? '';
  }
}
