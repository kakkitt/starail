import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/audio_manager.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _heartRiseController;
  late AnimationController _textAnimationController;
  late Animation<double> _heartRiseAnimation;
  late Animation<double> _textFadeAnimation;
  
  bool _showText = false;
  bool _showHeart = false;
  
  @override
  void initState() {
    super.initState();
    
    // 오디오 플레이어 초기화
    AudioManager().playBGM();
    
    // 텍스트 페이드인 애니메이션
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );
    
    // 하트 상승 애니메이션
    _heartRiseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _heartRiseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartRiseController, curve: Curves.easeOutCubic),
    );
    
    // 스플래시 시퀀스 시작
    _startSplashSequence();
  }
  
  Future<void> _startSplashSequence() async {
    // 텍스트 먼저 표시
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showText = true);
    _textAnimationController.forward();
    
    // 텍스트 애니메이션 후 하트 표시
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showHeart = true);
    _heartRiseController.forward();
    
    // 애니메이션 완료 후 메인 화면으로 이동
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
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
    _heartRiseController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  // SVG 문자열을 직접 사용하는 메서드
  Widget _buildHeartSvg() {
    // 제공된 SVG 코드를 사용
    String svgCode = '''
    <svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="heartGradient" x1="0%" y1="100%" x2="0%" y2="0%">
          <stop offset="0%" stop-color="#FF3F7F"/>
          <stop offset="100%" stop-color="#FFB3C9"/>
        </linearGradient>
        <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
          <feGaussianBlur stdDeviation="4" result="blur"/>
          <feComposite in="SourceGraphic" in2="blur" operator="over"/>
        </filter>
      </defs>

      <g opacity="0.1">
        <path d="M0 0 L400 0 L400 400 L0 400 Z" fill="#f9f9f9"/>
        <g stroke="#ccc" stroke-width="0.5">
          <path d="M25 0 L25 400"/><path d="M50 0 L50 400"/><path d="M75 0 L75 400"/>
          <path d="M100 0 L100 400"/><path d="M125 0 L125 400"/><path d="M150 0 L150 400"/>
          <path d="M175 0 L175 400"/><path d="M200 0 L200 400"/><path d="M225 0 L225 400"/>
          <path d="M250 0 L250 400"/><path d="M275 0 L275 400"/><path d="M300 0 L300 400"/>
          <path d="M325 0 L325 400"/><path d="M350 0 L350 400"/><path d="M375 0 L375 400"/>
        </g>
        <g stroke="#ccc" stroke-width="0.5">
          <path d="M0 25 L400 25"/><path d="M0 50 L400 50"/><path d="M0 75 L400 75"/>
          <path d="M0 100 L400 100"/><path d="M0 125 L400 125"/><path d="M0 150 L400 150"/>
          <path d="M0 175 L400 175"/><path d="M0 200 L400 200"/><path d="M0 225 L400 225"/>
          <path d="M0 250 L400 250"/><path d="M0 275 L400 275"/><path d="M0 300 L400 300"/>
          <path d="M0 325 L400 325"/><path d="M0 350 L400 350"/><path d="M0 375 L400 375"/>
        </g>
      </g>

      <g transform="translate(200, 165) scale(0.9)">
        <path
          d="M0 30
             C-40 -25, -80 0, -80 30
             C-80 60, -40 85, 0 100
             C40 85, 80 60, 80 30
             C80 0, 40 -25, 0 30"
          fill="url(#heartGradient)"
          filter="url(#glow)"
        />
        <circle cx="-60" cy="-25" r="15" fill="#FFB3C9" opacity="0.9"/>
        <circle cx="60"  cy="-25" r="12" fill="#FFB3C9" opacity="0.9"/>
      </g>
    </svg>
    ''';
    
    return SvgPicture.string(
      svgCode,
      width: 230,
      height: 230,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      // 순수한 흰색 배경
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // LUMINA 텍스트 애니메이션 (먼저 나타남)
          Positioned(
            bottom: size.height * 0.28,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: AnimatedBuilder(
                animation: _textFadeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
                    child: const Text(
                      "LUMINA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nova Round',
                        fontSize: 42,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 5,
                        color: Color(0xFFFF3F7F),
                        shadows: [
                          Shadow(
                            color: Color(0xFFFF3F7F),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 부가 설명 텍스트
          Positioned(
            bottom: size.height * 0.22,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              child: AnimatedBuilder(
                animation: _textFadeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 15 * (1 - _textFadeAnimation.value)),
                    child: const Text(
                      "당신의 마음을 연결합니다",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        color: Color(0xFFFF3F7F),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 하트 로고 (상승 애니메이션)
          Center(
            child: AnimatedOpacity(
              opacity: _showHeart ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: AnimatedBuilder(
                animation: _heartRiseAnimation,
                builder: (context, child) {
                  // 아래에서 위로 상승하는 애니메이션
                  return Transform.translate(
                    offset: Offset(0, 100 * (1 - _heartRiseAnimation.value)),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF3F7F).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: _buildHeartSvg(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}