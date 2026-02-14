import 'package:get/get.dart';
import 'package:quraan/models/ChapterModel.dart';
import 'package:quraan/services/QuranService.dart';

class SurahController extends GetxController {
  final service = Get.find<QuranService>();

  final RxList<ChapterModel> surahs = <ChapterModel>[].obs;
  final RxList<ChapterModel> filteredSurahs = <ChapterModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    try {
      isLoading.value = true;

      final chapters = await service.getChapters();

      surahs.assignAll(chapters);
      filteredSurahs.assignAll(chapters);

    } catch (e) {
      print("Error loading surahs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredSurahs.assignAll(surahs);
      return;
    }

    final lowerQuery = query.toLowerCase();

    filteredSurahs.assignAll(
      surahs.where(
            (s) =>
        s.nameArabic.contains(query) ||
            s.nameSimple.toLowerCase().contains(lowerQuery) ||
            s.id.toString().contains(query),
      ),
    );
  }
}
