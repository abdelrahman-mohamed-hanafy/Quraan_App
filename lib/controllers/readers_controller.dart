import 'package:get/get.dart';
import 'package:quraan/models/readers.dart';
import 'package:quraan/services/QuranService.dart';

class RecitersController extends GetxController {
  final quranService = Get.find<QuranService>();

  final RxList<Reciter> readers = <Reciter>[].obs;
  final RxList<Reciter> filteredReader = <Reciter>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();

    ever(searchQuery, (_) => search());
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await quranService.getReaders();

      if (data != null) {
        readers.assignAll(data);
        filteredReader.assignAll(data);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void search() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredReader.assignAll(readers);
    } else {
      filteredReader.assignAll(
        readers.where((reader) =>
            reader.name.toLowerCase().contains(query)),
      );
    }
  }
}
