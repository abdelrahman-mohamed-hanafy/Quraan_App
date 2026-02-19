import 'package:just_audio/just_audio.dart';

final AudioPlayer player = AudioPlayer();
Future<void> playAdhan (String prayer) async {
  if (prayer == "الفجر") {
   await player.setAsset('assets/sounds/fajr.mp3');
  }
  else if(prayer == "الشروق")
  {
    print('لا يوجد اذان للضحى');
     return;
  }
  else {
    await player.setAsset('assets/sounds/main.mp3');
  }
  await player.play();
}
