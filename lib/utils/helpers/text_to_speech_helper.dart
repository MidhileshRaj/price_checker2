import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechHelper {
  final FlutterTts _flutterTts = FlutterTts();

  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;
  String _language = "en";

  TextToSpeechHelper() {
    _initializeTts();
  }


  Future<void> _initializeTts() async {
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setLanguage(_language);
  }

  /// Retrieves the list of available languages
  Future<List<String>> getAvailableLanguages() async {
    return await _flutterTts.getLanguages;
  }

  /// Updates the language for text-to-speech
  Future<void> updateLanguage(String languageCode) async {
    _language = languageCode;
    await _flutterTts.setLanguage(_language);
  }

  /// Updates the speech rate
  Future<void> updateSpeechRate(double rate) async {
    _speechRate = rate;
    await _flutterTts.setSpeechRate(_speechRate);
  }

  /// Updates the volume
  Future<void> updateVolume(double volume) async {
    _volume = volume;
    await _flutterTts.setVolume(_volume);
  }

  /// Updates the pitch
  Future<void> updatePitch(double pitch) async {
    _pitch = pitch;
    await _flutterTts.setPitch(_pitch);
  }

  /// Speaks the given text
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  /// Stops the current speech
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Pauses the current speech (if supported on the platform)
  Future<void> pause() async {
    await _flutterTts.pause();
  }

  /// Gets the current language
  String get currentLanguage => _language;

  /// Gets the current speech rate
  double get currentSpeechRate => _speechRate;

  /// Gets the current volume
  double get currentVolume => _volume;

  /// Gets the current pitch
  double get currentPitch => _pitch;
}