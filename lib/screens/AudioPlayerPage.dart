import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AudioPlayerController.dart';

class AudioPlayerSheet extends GetView<AudioPlayerController> {
  const AudioPlayerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.12,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.12, 0.95],
      builder: (context, scrollController) {
        return Obx(() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: controller.gradientForSurah(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: _playerUI(scrollController),
        ));
      },
    );
  }

  Widget _playerUI(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white, size: 32),
              onPressed: () => Get.back(),
            ),
            const Spacer(),
            const Text("Now Playing",
                style: TextStyle(color: Colors.white70)),
            const Spacer(),
          ],
        ),

        const SizedBox(height: 20),

        Obx(() => Text(
          controller.surahName.value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )),

        const SizedBox(height: 25),

        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1),
          ),
          child: const Center(
            child: Icon(Icons.graphic_eq,
                size: 70, color: Color(0xFFD4AF37)),
          ),
        ),

        const SizedBox(height: 25),

        Obx(() {
          final pos = controller.position.value;
          final dur = controller.duration.value;

          return Column(
            children: [
              Slider(
                value: dur.inSeconds == 0
                    ? 0
                    : pos.inSeconds
                    .toDouble()
                    .clamp(0, dur.inSeconds.toDouble()),
                max: dur.inSeconds == 0 ? 1 : dur.inSeconds.toDouble(),
                onChanged: controller.seek,
                activeColor: const Color(0xFFD4AF37),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.formatTime(pos),
                      style:
                      const TextStyle(color: Colors.white70)),
                  Text(controller.formatTime(dur),
                      style:
                      const TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          );
        }),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous,
                  color: Colors.white, size: 40),
              onPressed: controller.playPrevious,
            ),
            Obx(() => IconButton(
              iconSize: 80,
              icon: Icon(
                controller.isPlaying.value
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: const Color(0xFFD4AF37),
              ),
              onPressed: controller.playPause,
            )),
            IconButton(
              icon: const Icon(Icons.skip_next,
                  color: Colors.white, size: 40),
              onPressed: controller.playNext,
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Divider(color: Colors.white30),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.surahs.length,
          itemBuilder: (context, index) {
            final surah = controller.surahs[index];

            return Obx(() => ListTile(
              title: Text(
                surah.surahName,
                style: TextStyle(
                  color:
                  index == controller.currentIndex.value
                      ? const Color(0xFFD4AF37)
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(
                index == controller.currentIndex.value
                    ? Icons.play_circle_fill
                    : Icons.library_music,
                color: const Color(0xFFD4AF37),
              ),
              onTap: () async {
                await controller.player.seek(
                  Duration.zero,
                  index: index,
                );
                await controller.player.play();
              },
            ));
          },
        ),
      ],
    );
  }
}
