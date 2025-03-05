import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../models/experience_card.dart';

class ExperienceDetailScreen extends StatefulWidget {
  final ExperienceCard card;
  
  const ExperienceDetailScreen({Key? key, required this.card}) : super(key: key);
  
  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            AudioManager().playSFX('back');
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: Text(
          widget.card.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 배경 그라데이션
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.card.color,
                  AppColors.background,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          
          // 움직이는 원형 효과
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: 100,
                left: -size.width * 0.3,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.card.highlightColor.withOpacity(0.5),
                        widget.card.highlightColor.withOpacity(0),
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 움직이는 별 효과
          Positioned.fill(
            child: CustomPaint(
              painter: _DetailStarPainter(
                color: widget.card.highlightColor,
                animation: _animationController,
              ),
            ),
          ),
          
          // 메인 콘텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // 상단 공간 (앱바 아래)
                  const SizedBox(height: 40),
                  
                  // 큰 아이콘 표시 (Lottie 대신 기본 아이콘 사용)
                  Hero(
                    tag: "hero_${widget.card.title}",
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      transform: Matrix4.translationValues(
                        0, 
                        _isLoaded ? 0 : 50, 
                        0,
                      ),
                      child: AnimatedOpacity(
                        opacity: _isLoaded ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.card.color,
                                widget.card.highlightColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: widget.card.color.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.card.icon,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 제목
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuint,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 50, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        "지금 바로 ${widget.card.title} 시작하기",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 설명
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuint,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 50, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        widget.card.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 시작하기 버튼
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 100, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            AudioManager().playSFX('start');
                            // 실제 경험 시작 화면으로 이동
                            
                            // 진동 피드백 (선택사항)
                            // HapticFeedback.mediumImpact();
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "시작하기",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.card.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 상세 화면 배경 별 효과 페인터
class _DetailStarPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;
  final List<_MiniStar> stars = [];
  
  _DetailStarPainter({
    required this.color,
    required this.animation,
  }) {
    // 별 초기화
    final random = math.Random();
    for (int i = 0; i < 30; i++) {
      stars.add(_MiniStar(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.001 + 0.0005,
      ));
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // 별 그리기
    for (var star in stars) {
      // 애니메이션 적용
      final x = (star.x + animation.value * star.speed) % 1.0 * size.width;
      final y = (star.y - animation.value * star.speed) % 1.0 * size.height;
      
      // 별 그리기
      canvas.drawCircle(
        Offset(x, y),
        star.size,
        paint,
      );
      
      // 별 주변 글로우 효과
      canvas.drawCircle(
        Offset(x, y),
        star.size * 2,
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MiniStar {
  final double x;
  final double y;
  final double size;
  final double speed;
  
  _MiniStar({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}