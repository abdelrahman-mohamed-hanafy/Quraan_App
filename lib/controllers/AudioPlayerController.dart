import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class AudioPlayerController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  var surahName = ''.obs;
  var isPlaying = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var currentIndex = 0.obs;

  var showMiniPlayer = false.obs;

  List<dynamic> surahs = [];
  ConcatenatingAudioSource? playlist;

  @override
  void onInit() {
    super.onInit();

    player.positionStream.listen((p) {
      position.value = p;
    });

    player.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    player.currentIndexStream.listen((index) {
      if (index != null && surahs.isNotEmpty) {
        currentIndex.value = index;
        surahName.value = surahs[index].surahName;
      }
    });
  }

  Future<void> initPlaylist({
    required List<dynamic> list,
    required int initialIndex,
  }) async {
    surahs = list;

    playlist = ConcatenatingAudioSource(
      children: list
          .map((s) => AudioSource.uri(Uri.parse(s.audioUrl)))
          .toList(),
    );

    await player.setAudioSource(
      playlist!,
      initialIndex: initialIndex,
    );

    await player.play();
  }

  Future<void> playPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> playNext() async {
    if (player.hasNext) {
      await player.seekToNext();
    }
  }

  Future<void> playPrevious() async {
    if (player.hasPrevious) {
      await player.seekToPrevious();
    }
  }

  void seek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  List<Color> gradientForSurah() {
    final colors = [
      [const Color(0xFF0E3B2E), const Color(0xFF071A14)],
      [const Color(0xFF123F32), Colors.black],
      [const Color(0xFF1C4D3A), const Color(0xFF071A14)],
      [const Color(0xFF0B2F25), Colors.black],
    ];

    return colors[currentIndex.value % colors.length];
  }
  void stop() async {
    await player.stop();
    isPlaying.value = false;
    showMiniPlayer.value = false;
  }



  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
