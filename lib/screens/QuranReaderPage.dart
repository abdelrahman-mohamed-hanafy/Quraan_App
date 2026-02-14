import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quraan/controllers/QuranReaderController.dart';

class QuranReaderPage extends GetView<QuranReaderController> {
  const QuranReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.toggleControls,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFE8D8),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7E3),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF0F3D2E),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      /// اسم السورة
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3D2E),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color(0xFFD4AF37),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "سورة ${controller.chapterName}",
                            style: const TextStyle(
                              fontFamily: 'UthmanicHafs',
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      /// البسملة
                      if (controller.hasBasmala)
                        Obx(() => AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: controller.showBasmala.value ? 1 : 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Text(
                              controller.basmalaText,
                              style: const TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: 30,
                                height: 2,
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),

                      /// الآيات
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Text.rich(
                            TextSpan(
                              children: controller.verses
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final verse = entry.value;

                                final displayNumber =
                                controller.chapterId == 1
                                    ? index + 1
                                    : verse.verseNumber;

                                return TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${verse.arabicText} ",
                                      style: const TextStyle(
                                        fontFamily: 'UthmanicHafs',
                                        fontSize: 28,
                                        height: 2.1,
                                        color: Color(0xFF1B1B1B),
                                      ),
                                      recognizer: LongPressGestureRecognizer()
                                        ..onLongPress = () {
                                          controller.selectVerse(verse);
                                          Get.bottomSheet(
                                            Container(
                                              padding:
                                              const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.vertical(
                                                  top: Radius.circular(25),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading:
                                                    const Icon(Icons.copy),
                                                    title:
                                                    const Text("نسخ"),
                                                    onTap: () async {
                                                      await controller
                                                          .copySelectedVerse();
                                                      Get.back();
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading:
                                                    const Icon(Icons.share),
                                                    title:
                                                    const Text("مشاركة"),
                                                    onTap: () {
                                                      Share.share(controller
                                                          .selectedVerseText);
                                                      Get.back();
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.menu_book),
                                                    title: const Text("تفسير"),
                                                    onTap: () {
                                                      Get.back();
                                                      Get.toNamed(
                                                        '/tafsir',
                                                        arguments: controller
                                                            .selectedVerse
                                                            .value,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                    ),
                                    WidgetSpan(
                                      alignment:
                                      PlaceholderAlignment.middle,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding:
                                        const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                            const Color(0xFFD4AF37),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          displayNumber.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'UthmanicHafs',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TextSpan(text: "  "),
                                  ],
                                );
                              }).toList(),
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        bottomNavigationBar: Obx(() {
          return controller.showControls.value
              ? Container(
            height: 70,
            color: Colors.black87,
            child: const Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.brightness_6,
                    color: Colors.white),
                Icon(Icons.bookmark,
                    color: Colors.white),
                Icon(Icons.menu,
                    color: Colors.white),
              ],
            ),
          )
              : const SizedBox();
        }),
      ),
    );
  }
}
