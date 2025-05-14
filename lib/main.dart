// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // ScrollBehavior를 위해 추가
import 'package:ai_voice_dev/screens/splash_screen.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';

// 모든 포인터 장치에서 드래그 스크롤을 지원하는 ScrollBehavior 클래스
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown, // 필요한 경우 추가
      };
}

void main() {
  runApp(const LuminaApp());
}

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUMINA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(), // 이 부분 추가
      home: const SplashScreen(),
    );
  }
}