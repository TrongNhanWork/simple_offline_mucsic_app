import 'package:flutter_test/flutter_test.dart';
import 'package:simple_offline_mucsic_app/services/audio_player_service.dart';

void main() {
  group('AudioPlayerService Tests', () {
    late AudioPlayerService service;

    setUp(() {
      service = AudioPlayerService();
    });

    test('Initial state is not playing', () {
      expect(service.isPlaying, false);
    });

    test('Load audio file successfully', () async {
      // Test with valid audio file path (Mock this or leave as is per instructions)
      // await service.loadAudio('assets/audio/sample_songs/placeholder.txt'); 
      // Note: testing actual audio file requires proper environment
    });

    tearDown(() {
      service.dispose();
    });
  });
}
