class UserData {
  String? name;
  String? gender;
  String? selectedCharacter;

  UserData({this.name, this.gender, this.selectedCharacter});

  // 데이터 복사본 생성 메서드
  UserData copyWith({
    String? name,
    String? gender,
    String? selectedCharacter,
  }) {
    return UserData(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
    );
  }
}