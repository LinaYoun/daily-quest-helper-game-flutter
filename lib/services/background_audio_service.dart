import 'package:audioplayers/audioplayers.dart';

class BackgroundAudioService {
  BackgroundAudioService._internal();
  static final BackgroundAudioService _instance =
      BackgroundAudioService._internal();
  factory BackgroundAudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool _initialized = false;

  Future<void> initializeAndPlay() async {
    if (_initialized) return;
    _initialized = true;
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.5);
    await _player.play(AssetSource('routine_helper_background.mp3'));
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> dispose() async {
    await _player.stop();
    await _player.dispose();
  }
}
