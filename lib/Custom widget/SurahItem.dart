import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/models/ChapterModel.dart';

class SurahItem extends StatelessWidget {
  final ChapterModel surah;
  const SurahItem({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // الانتقال لصفحة قراءة السورة مع إرسال المعلومات اللازمة
        Get.toNamed('/reader', arguments: {
          'id': surah.id,
          'nameArabic': surah.nameArabic,
          // لاحقًا يمكن إضافة: 'initialOffset': offset
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF123E2F), // خلفية داكنة
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4AF37)), // إطار ذهبي
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${surah.id} - ${surah.nameArabic}",
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
