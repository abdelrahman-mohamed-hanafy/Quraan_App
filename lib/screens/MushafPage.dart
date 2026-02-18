import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/Custom%20widget/mushaf_page_content.dart';
import '../controllers/MushafController.dart';

class MushafPage extends GetView<MushafController> {
  const MushafPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: const Color(0xFF0B2B0D),
          body: SafeArea(
    child: PageView.builder(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      itemCount: 604,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final pageNumber = index + 1;

        return Obx(() {
          final verses = controller.pagesCache[pageNumber];

          if (verses == null) {
            controller.loadPage(pageNumber);
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF37),
              ),
            );
          }

          return MushafPageContent(verses: verses);
        });
      },
    )),
          );
  }
}
