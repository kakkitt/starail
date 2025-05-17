import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_voice_dev/screens/main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _heartRiseController;
  late Animation<double> _heartRiseAnimation;
  late Animation<double> _heartScaleAnimation;
  
  bool _showHeart = false;
  final String _logoAssetPath = 'assets/images/heart_logo.svg';

  @override
  void initState() {
    super.initState();
    
    // 하트 상승 애니메이션 컨트롤러
    _heartRiseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // 상승 애니메이션 (아래에서 위로 부드럽게)
    _heartRiseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartRiseController, curve: Curves.easeOutCubic),
    );
    
    // 약간의 스케일 애니메이션 추가 (살짝 커졌다가 원래 크기로)
    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.05),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 40,
      ),
    ]).animate(
      CurvedAnimation(parent: _heartRiseController, curve: Curves.easeOut),
    );
    
    // 스플래시 시퀀스 시작
    _startSplashSequence();
  }
  
  Future<void> _startSplashSequence() async {
    // 약간의 지연 후 하트 표시
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showHeart = true);
    _heartRiseController.forward();
    
    // 애니메이션 완료 후 메인 화면으로 이동
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: const MainScaffold(),
            );
          },
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _heartRiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      // 순수한 흰색 배경 (다크 모드에서는 어두운 배경)
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _showHeart ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          child: AnimatedBuilder(
            animation: _heartRiseController,
            builder: (context, child) {
              // 아래에서 위로 상승하는 애니메이션
              return Transform.translate(
                offset: Offset(0, 100 * (1 - _heartRiseAnimation.value)),
                child: Transform.scale(
                  scale: _heartScaleAnimation.value,
                  child: Container(
                    width: size.width * 0.65, // 화면 너비의 65%
                    height: size.width * 0.65, // 1:1 비율 유지
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3F7F).withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      _logoAssetPath,
                      width: size.width * 0.65,
                      height: size.width * 0.65,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}