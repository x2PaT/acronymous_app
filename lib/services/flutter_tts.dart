import 'package:flutter_tts/flutter_tts.dart';

final TTSService ttsService = TTSService();

class TTSService {
  FlutterTts flutterTts = FlutterTts();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  String langCode = "en-US";

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }

  void speakTTS(String text) async {
    initSetting();
    await flutterTts.speak(text);
  }

  void stop() async {
    await flutterTts.stop();
  }
}
