import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer bgmPlayer = AudioPlayer();
  final AudioPlayer sfxPlayer = AudioPlayer();
  
  Future<void> playBGM() async {
    // 실제 구현에서는 assets 폴더에 음악 파일 필요
    // await bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    // 음악 루프 설정
    // bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }
  
  Future<void> playSFX(String sfxName) async {
    // await sfxPlayer.play(AssetSource('audio/$sfxName.mp3'));
  }
  
  Future<void> stopBGM() async {
    await bgmPlayer.stop();
  }
  
  Future<void> pauseBGM() async {
    await bgmPlayer.pause();
  }
  
  Future<void> resumeBGM() async {
    await bgmPlayer.resume();
  }
  
  void dispose() {
    bgmPlayer.dispose();
    sfxPlayer.dispose();
  }
}