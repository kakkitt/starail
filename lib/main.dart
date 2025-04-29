import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

// Supabase 클라이언트 전역 인스턴스
final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // SystemChrome 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Supabase 초기화
  await Supabase.initialize(
    url: 'https://your-project-url.supabase.co', // Supabase 프로젝트 URL로 변경
    anonKey: 'your-anon-key', // Supabase 프로젝트의 anon key로 변경
  );
  
  runApp(const AIPhoneApp());
}

class AIPhoneApp extends StatelessWidget {
  const AIPhoneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 전화',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}