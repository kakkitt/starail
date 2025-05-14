// lib/models/character_model.dart

class Character {
  final String id;
  final String name;
  final String imageAssetPath; // 로컬 애셋 경로
  final String shortBio;
  final String statusMessage; // 캐릭터의 현재 상태 또는 한 줄 소개

  Character({
    required this.id,
    required this.name,
    required this.imageAssetPath,
    required this.shortBio,
    required this.statusMessage,
  });
}