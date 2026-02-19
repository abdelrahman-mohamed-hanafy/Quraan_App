import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/screens/AudioPlayerPage.dart';
import '../controllers/AudioPlayerController.dart';

class MiniPlayer extends GetView<AudioPlayerController> {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showMiniPlayer.value) {
        return const SizedBox();
      }

      return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            controller.showMiniPlayer.value = false;

            Get.bottomSheet(
              const AudioPlayerSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            ).then((_) {
              controller.showMiniPlayer.value = true;
            });
          },
          child: Container(
            height: 70,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF0E3B2E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: Color(0xFFD4AF37)),
                const SizedBox(width: 12),

                Expanded(
                  child: Obx(() => Text(
                    controller.surahName.value,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )),
                ),

                Obx(() => IconButton(
                  icon: Icon(
                    controller.isPlaying.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: const Color(0xFFD4AF37),
                  ),
                  onPressed: controller.playPause,
                )),

                // زر الإلغاء ❌
                IconButton(
                  splashRadius: 20,
                  iconSize: 20,
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () {
                    controller.stop();
                    controller.showMiniPlayer.value = false;
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
