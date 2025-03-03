import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../widgets/animated_background.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  bool _showLogo = false;
  bool _showText = false;
  bool _showWelcome = false;
  
  @override
  void initState() {
    super.initState();
    
    // 오디오 플레이어 초기화
    AudioManager().playBGM();
    
    // 로고 애니메이션 컨트롤러
    _logoAnimationController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2),
    );
    
    // 펄스 애니메이션 컨트롤러
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
    );
    
    // 스플래시 시퀀스 시작
    _startSplashSequence();
  }
  
  Future<void> _startSplashSequence() async {
    // 지연 시간 후 로고 표시
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showLogo = true);
    
    // 로고 애니메이션 시작
    _logoAnimationController.forward();
    
    // 추가 지연 후 텍스트 표시
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showText = true);
    
    // 환영 메시지 표시
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _showWelcome = true);
    
    // 애니메이션 완료 후 메인 화면으로 이동
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: const OnboardingScreen(),
            );
          },
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _logoAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // 애니메이션 배경
          AnimatedBackground(
            colors: const [
              AppColors.pastelPurple,
              AppColors.pastelBlue,
              AppColors.pastelPink,
            ],
          ),
          
          // 원형 그라데이션 효과
          Center(
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0),
                  ],
                  stops: const [0.2, 1.0],
                ),
              ),
            ),
          ),
          
          // 로고 애니메이션
          Center(
            child: AnimatedOpacity(
              opacity: _showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: Curves.elasticOut.transform(_logoAnimationController.value),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.mic,
                                size: 70,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 앱 타이틀 텍스트
          Positioned(
            bottom: size.height * 0.35,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: Column(
                children: [
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                      fontFamily: 'GmarketSans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.appTagline,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 환영 메시지와 캐릭터
          Positioned(
            bottom: size.height * 0.15,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showWelcome ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: Column(
                children: [
                  // 캐릭터 애니메이션
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Lottie.asset(
                      AppAssets.welcomeCharacter,
                      // 로티 파일이 없는 경우 아래 코드 주석 해제하고 사용
                      /*
                      frameBuilder: (context, child, composition) {
                        // 로티 에셋 없을 때 대체
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.pastelPurple.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.face,
                            size: 50,
                            color: Colors.white,
                          ),
                        );
                      },
                      */
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 환영 메시지
                  Text(
                    AppStrings.welcomeMessage('사용자'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 로딩 인디케이터
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Center(
                child: SizedBox(
                  width: 160,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary.withOpacity(0.8)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}