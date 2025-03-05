import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final bool showStars;

  const AnimatedBackground({
    Key? key,
    required this.child,
    this.colors = const [
      Color(0xFFFFC0CB), // 파스텔 핑크
      Color(0xFFD8BFD8), // 파스텔 퍼플
      Color(0xFFADD8E6), // 파스텔 블루
    ],
    this.showStars = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 그라데이션 배경
        Positioned.fill(
          child: AnimatedGradientBackground(colors: colors),
        ),
        
        // 별 효과
        if (showStars) 
          Positioned.fill(
            child: StarfieldAnimation(
              starsCount: 100,
              maxStarSize: 2.0,
            ),
          ),
        
        // 메인 콘텐츠
        Positioned.fill(child: child),
      ],
    );
  }
}

class AnimatedGradientBackground extends StatelessWidget {
  final List<Color> colors;

  const AnimatedGradientBackground({
    Key? key,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MirrorAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 2 * math.pi),
      duration: const Duration(seconds: 20),
      curve: Curves.linear,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(value) * 0.2, 
                math.sin(value) * 0.2
              ),
              end: Alignment(
                math.cos(value + math.pi) * 0.2, 
                math.sin(value + math.pi) * 0.2
              ),
              colors: colors,
            ),
          ),
        );
      },
    );
  }
}

class StarfieldAnimation extends StatefulWidget {
  final int starsCount;
  final double maxStarSize;

  const StarfieldAnimation({
    Key? key,
    this.starsCount = 100,
    this.maxStarSize = 3.0,
  }) : super(key: key);

  @override
  State<StarfieldAnimation> createState() => _StarfieldAnimationState();
}

class _StarfieldAnimationState extends State<StarfieldAnimation> with SingleTickerProviderStateMixin {
  late List<Star> stars;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    // 별 생성
    stars = List.generate(widget.starsCount, (_) => _createRandomStar());
    
    // 애니메이션 컨트롤러
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    
    // 별 애니메이션 업데이트
    _controller.addListener(() {
      for (var star in stars) {
        star.twinkle();
      }
      if (mounted) setState(() {});
    });
  }
  
  Star _createRandomStar() {
    final random = math.Random();
    return Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * widget.maxStarSize,
      twinkleSpeed: random.nextDouble() * 0.05 + 0.01,
      twinkleFactor: random.nextDouble() * 0.6 + 0.4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarfieldPainter(stars: stars),
      size: Size.infinite,
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double twinkleSpeed;
  final double twinkleFactor;
  
  double opacity = 0.0;
  double _progress = 0.0;
  bool _increasing = true;
  
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleSpeed,
    required this.twinkleFactor,
  }) {
    // 초기 불투명도 랜덤 설정
    opacity = math.Random().nextDouble() * 0.5 + 0.1;
  }
  
  void twinkle() {
    // 반짝임 효과 진행
    if (_increasing) {
      _progress += twinkleSpeed;
      if (_progress >= 1.0) {
        _progress = 1.0;
        _increasing = false;
      }
    } else {
      _progress -= twinkleSpeed;
      if (_progress <= 0.0) {
        _progress = 0.0;
        _increasing = true;
      }
    }
    
    // 불투명도 업데이트
    opacity = 0.1 + _progress * twinkleFactor;
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  
  StarfieldPainter({required this.stars});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity)
        ..style = PaintingStyle.fill;
      
      // 별 그리기
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
      
      // 별 글로우 효과
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * 2,
        Paint()
          ..color = Colors.white.withOpacity(star.opacity * 0.3)
          ..style = PaintingStyle.fill,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => true;
}