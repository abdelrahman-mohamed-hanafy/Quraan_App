import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/controllers/SurahsByReaderController.dart';
import 'package:quraan/controllers/AudioPlayerController.dart';
import 'package:quraan/screens/AudioPlayerPage.dart';
import 'package:quraan/Custom widget/mini_player.dart';

class SurahsByReaderPage extends GetView<SurahsByReaderController> {
  const SurahsByReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = Get.find<AudioPlayerController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0E3B2E),
              centerTitle: true,
              title: Text(
                controller.reciterName,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
              actions: [
                Obx(() {
                  return IconButton(
                    icon: Icon(
                      controller.isDownloadingAll.value
                          ? Icons.cancel
                          : Icons.download,
                      color: controller.isDownloadingAll.value
                          ? Colors.redAccent
                          : const Color(0xFFD4AF37),
                    ),
                    onPressed: () async {
                      if (controller.isDownloadingAll.value) {
                        // إلغاء الكل
                        controller.cancelAllDownloads();

                        Get.snackbar(
                          "تم الإلغاء",
                          "تم إلغاء جميع التحميلات",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        // تحميل الكل
                        final completed =
                        await controller.downloadAllSurahs();

                        if (completed) {
                          Get.snackbar(
                            "تم التحميل",
                            "تم الانتهاء من تحميل جميع السور",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                  );
                }),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.2,
                  colors: [
                    Color(0xFF0E3B2E),
                    Color(0xFF071A14),
                  ],
                  center: Alignment.topCenter,
                ),
              ),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.surahs.length,
                  itemBuilder: (context, index) {
                    final surah = controller.surahs[index];

                    return InkWell(
                      onTap: () {
                        audioController.showMiniPlayer.value = false;

                        Get.bottomSheet(
                          const AudioPlayerSheet(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        ).then((_) {
                          audioController.showMiniPlayer.value = true;
                        });

                        audioController.initPlaylist(
                          list: controller.surahs,
                          initialIndex: index,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFD4AF37),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.library_music,
                                color: Color(0xFFD4AF37)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                surah.surahName,
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            /// زر التحميل + progress + cancel
                            Obx(() {
                              final progress = controller
                                  .downloadProgress[surah.surahId];

                              if (progress != null) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 3,
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () {
                                        controller
                                            .cancelDownload(surah.surahId);
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.download,
                                      color: Color(0xFFD4AF37)),
                                  onPressed: () async {
                                    final success =
                                    await controller.downloadSurah(surah);

                                    if (success) {
                                      Get.snackbar(
                                        "تم التحميل",
                                        "تم تحميل سورة ${surah.surahName}",
                                        snackPosition:
                                        SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}
