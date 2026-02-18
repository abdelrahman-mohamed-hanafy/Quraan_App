import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/Custom%20widget/surah_header_decoration.dart';
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B2B0D), Color(0xFF143E1F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFD4AF37), width: 3),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text.rich(
                TextSpan(children: _buildVerseSpans()),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
              ),
            ),
          ),

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
    );
  }

  List<InlineSpan> _buildVerseSpans() {
    List<InlineSpan> spans = [];

    for (var v in verses) {
      // عنوان السورة + البسملة
      if (v.verseNumber == 1) {
        spans.add(const TextSpan(text: "\n"));

        spans.add(
          WidgetSpan(
            child: Center(
              child: SurahHeaderDecoration(
                surahName: controller.getSurahName(v.chapterId),
              ),
            ),
          ),
        );

        if (v.chapterId != 1 && v.chapterId != 9) {
          spans.add(
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
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
              ),
            ),
          );
        }

        spans.add(const TextSpan(text: "\n"));
      }

      // نص الآية
      spans.add(
        TextSpan(
          text: v.text,
          style: const TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: 24,
            height: 2,
            color: Color(0xFFFFD700),
          ),
        ),
      );

      spans.add(
        TextSpan(
          text: " ﴿${v.verseNumber}﴾ ",
          style: const TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: 18,
            color: Color(0xFFD4AF37),
          ),
        ),
      );
    }

    return spans;
  }
}
