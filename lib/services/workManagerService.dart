import 'package:quraan/services/audio_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    if (task == "azan_task") {
      final String prayer = inputData?["prayer"] ?? "العشاء";
      await playAdhan(prayer);
    }

    return Future.value(true);
  });
}

class WorkManagerService {

  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );
  }

  static Future<void> registerBackgroundTask(
      String prayer,
      Duration delay,
      ) async {
    await Workmanager().registerOneOffTask(
      "azan_$prayer",
      "azan_task",
      initialDelay: delay,
      inputData: {
        "prayer": prayer,
      },
    );
  }
}