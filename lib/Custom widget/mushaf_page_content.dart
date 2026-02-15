import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/MushafController.dart';
import '../models/PageVerseModel.dart';

class MushafPageContent extends GetView<MushafController> {
  final List<PageVerseModel> verses;

  const MushafPageContent({
    super.key,
    required this.verses,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 4.0,
      panEnabled: true,
      onInteractionUpdate: (details) {
        controller.currentScale.value = details.scale;
      },
      onInteractionStart: (_) {
        controller.isZooming.value = true;
      },
      onInteractionEnd: (_) {
        controller.isZooming.value = false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B2B0D), Color(0xFF143E1F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFD4AF37), width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // عنوان السورة
            if (controller.isFirstPageOfSurah(verses))
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E4C2B),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Text(
                  "سورة ${controller.getSurahName(verses.first.chapterId)}",
                  style: const TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ),

            // البسملة
            if (controller.shouldShowBasmala(verses))
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                  style: TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 22,
                    color: Color(0xFFFFD700),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // الآيات
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Text.rich(
                        TextSpan(
                          children: verses.map((v) {
                            return TextSpan(
                              children: [
                                TextSpan(
                                  text: "${v.text} ",
                                  style: const TextStyle(
                                    fontFamily: 'UthmanicHafs',
                                    fontSize: 22,
                                    height: 2,
                                    color: Color(0xFFFFD700),
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFD4AF37),
                                      ),
                                      color: Colors.black87,
                                    ),
                                    child: Text(
                                      v.verseNumber.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'UthmanicHafs',
                                        color: Color(0xFFFFD700),
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
                  );
                },
              ),
            ),

            // رقم الصفحة
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Obx(() => Text(
                "صفحة ${controller.currentPage.value}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFFD700),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
