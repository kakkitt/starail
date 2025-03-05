import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6E44FF);
  static const Color secondary = Color(0xFF00E1FF);
  static const Color tertiary = Color(0xFFFF44A1);
  static const Color quaternary = Color(0xFFFFB443);
  
  // 배경색을 어두운색에서 밝은 파스텔 하늘색으로 변경
  static const Color background = Color(0xFFD4F1FF);  // 파스텔 하늘색
  static const Color darkBlue = Color(0xFF1A1154);
  
  // 파스텔 컬러
  static const Color pastelPurple = Color(0xFFD4BFFF);
  static const Color pastelBlue = Color(0xFFADD8FF);
  static const Color pastelPink = Color(0xFFFFBFD8);
  static const Color pastelYellow = Color(0xFFFFE9AD);
  static const Color pastelGreen = Color(0xFFBFFFC8);
}

class AppTheme {
  static final ThemeData themeData = ThemeData(
    brightness: Brightness.light,  // 다크에서 라이트로 변경
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(  // 다크에서 라이트로 변경
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      background: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'GmarketSans'),
      titleLarge: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontFamily: 'Pretendard'),
      bodyMedium: TextStyle(fontFamily: 'Pretendard'),
    ),
  );
}

class AppAssets {
  // 애니메이션 에셋
  static const String welcomeCharacter = 'assets/lottie/welcome_character.json';
  static const String phoneAnimation = 'assets/lottie/phone_animation.json';
  static const String knightAnimation = 'assets/lottie/knight_animation.json';
  static const String heartAnimation = 'assets/lottie/heart_animation.json';
  static const String radioAnimation = 'assets/lottie/radio_animation.json';
  static const String gameAnimation = 'assets/lottie/game_animation.json';
  
  // 이미지 에셋
  static const String backgroundImage = 'assets/images/background.png';
}

class AppStrings {
  // 앱 제목과 부제목 - 이 부분을 수정하면 됩니다
  static const String appName = 'Project StarRail';
  static const String appTagline = '지금, 가장 설레는 AI와의 대화가 시작됩니다';
  
  static String welcomeMessage(String username) => '오늘도 만나서 반가워요, $username님!';
  
  // 온보딩 메시지
  static const List<Map<String, String>> onboardingItems = [
    {
      'title': '초현실적 대화 경험',
      'description': 'AI와의 전화 통화가 실제처럼 자연스럽게.\n음성 톤과 감정까지 완벽하게 구현됩니다.',
    },
    {
      'title': '다양한 음성 롤플레이',
      'description': '중세 기사부터 미래 로봇까지.\n상상 속 캐릭터와 대화하세요.',
    },
    {
      'title': '목소리로 떠나는 모험',
      'description': '음성만으로 즐기는 몰입형 RPG.\n당신의 선택이 이야기를 만들어갑니다.',
    },
  ];
}