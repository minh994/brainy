import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();

  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  bool get isPlaying => _isPlaying;

  Future<void> playAudio(String? audioUrl) async {
    if (_isPlaying || audioUrl == null || audioUrl.isEmpty) return;

    _isPlaying = true;

    try {
      debugPrint('Playing audio: $audioUrl');

      // Dispose previous player to avoid resource leaks
      await _audioPlayer?.dispose();
      _audioPlayer = AudioPlayer();

      await _audioPlayer?.setUrl(audioUrl);
      await _audioPlayer?.play();

      // Listen for playback completion
      _audioPlayer?.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
        }
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _isPlaying = false;
    }
  }

  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _isPlaying = false;
  }
}
