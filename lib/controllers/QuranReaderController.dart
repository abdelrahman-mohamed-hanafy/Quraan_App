import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quraan/models/VerseModel.dart';
import 'package:quraan/services/CacheService.dart';
import 'package:quraan/services/QuranService.dart';

class QuranReaderController extends GetxController {

  final service = Get.find<QuranService>();
  final cache = Get.find<CacheService>();

  final RxList<VerseModel> verses = <VerseModel>[].obs;
  final RxBool isLoading = false.obs;

  late final int chapterId;
  late final String chapterName;

  final RxBool showControls = false.obs;
  final Rx<VerseModel?> selectedVerse = Rx<VerseModel?>(null);
  RxBool showBasmala = true.obs;
  ScrollController scrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
    chapterId = Get.arguments['id'];
    chapterName = Get.arguments['nameArabic'];
    loadVerses();
    scrollController.addListener(() {
      showBasmala.value = scrollController.offset < 10;
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadVerses() async {
    try {
      isLoading.value = true;
      final data = await service.getVerses(chapterId);
      verses.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }



  int getDisplayVerseNumber(int index) {
    if (chapterId == 1) {
      return index + 1; // إعادة ترقيم الفاتحة
    }
    return verses[index].verseNumber;
  }

  bool get hasBasmala => chapterId != 1 && chapterId != 9;
  String get basmalaText => "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";

  void toggleControls() => showControls.toggle();

  /// اختيار آية
  void selectVerse(VerseModel verse) {
    selectedVerse.value = verse;
  }

  /// نسخ
  Future<void> copySelectedVerse() async {
    if (selectedVerse.value == null) return;
    await Clipboard.setData(
      ClipboardData(text: selectedVerse.value!.arabicText),
    );
  }

  /// النص للمشاركة
  String get selectedVerseText => selectedVerse.value?.arabicText ?? "";


}