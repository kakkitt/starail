import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_voice_dev/screens/main_scaffold.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // 텍스트 애니메이션 컨트롤러
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  
  // 로고 애니메이션 컨트롤러
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  
  // 파동 효과를 위한 컨트롤러
  late AnimationController _waveController;
  
  @override
  void initState() {
    super.initState();
    
    // 텍스트 애니메이션 (1초)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    
    // 로고 애니메이션 (1.2초)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    
    // 파동 애니메이션 (무한 반복)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    // 애니메이션 순서
    // 1. 텍스트 먼저 보여줌
    _textController.forward();
    
    // 2. 텍스트 애니메이션 완료 후 로고 등장
    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _logoController.forward();
      }
    });
    
    // 3. 로고 애니메이션 완료 후 파동 시작
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _waveController.repeat();
      }
    });
    
    // 메인 화면으로 전환
    Timer(const Duration(milliseconds: 4000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainScaffold(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _logoController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    const String logoAssetPath = 'assets/images/lumina.svg';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // 로고 (SVG 활용)
                AnimatedBuilder(
                  animation: Listenable.merge([_logoController, _waveController]),
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: SizedBox(
                          width: 250,  // 로고 크기 증가
                          height: 250,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 기본 SVG 로고
                              SvgPicture.asset(
                                logoAssetPath,
                                width: 250,
                                height: 250,
                                // 원본 색상 유지 (colorFilter 제거)
                              ),
                              
                              // 애니메이션 효과를 위한 오버레이 (선택적)
                              if (_waveController.value > 0)
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: WaveOverlayPainter(
                                      animationValue: _waveController.value,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // LUMINA 텍스트
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textOpacity.value,
                      child: Text(
                        'LUMINA',
                        style: TextStyle(
                          fontSize: 48,  // 텍스트 크기 증가
                          fontWeight: FontWeight.w300,
                          letterSpacing: 10,
                          // 그라데이션 적용
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFFEA6060),  // 핑크
                                Color(0xFF7117EA),  // 퍼플
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SVG 위에 추가 효과를 위한 오버레이 (선택적)
// 원하지 않으면 이 클래스와 관련 코드 삭제 가능
class WaveOverlayPainter extends CustomPainter {
  final double animationValue;
  
  WaveOverlayPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    // 이 부분은 SVG 위에 추가 효과를 그리고 싶을 때 사용
    // 예: 부드러운 글로우 효과나 미묘한 움직임
    
    // 간단한 글로우 효과
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final glowOpacity = (math.sin(animationValue * math.pi) * 0.3).abs();
    
    final paint = Paint()
      ..color = const Color(0xFF7117EA).withOpacity(glowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      
    canvas.drawCircle(center, radius, paint);
  }
  
  @override
  bool shouldRepaint(WaveOverlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}