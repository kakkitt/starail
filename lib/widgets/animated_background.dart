import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../utils/constants.dart';
import '../models/experience_card.dart';

class AnimatedBackground extends StatefulWidget {
  final List<Color> colors;
  final bool enableStars;
  
  const AnimatedBackground({
    Key? key,
    this.colors = const [
      AppColors.pastelPurple,
      AppColors.pastelBlue,
      AppColors.pastelPink,
    ],
    this.enableStars = true,
  }) : super(key: key);
  
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 그라데이션 배경 애니메이션
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(
                    math.cos(_controller.value * 2 * math.pi) * 0.2,
                    math.sin(_controller.value * 2 * math.pi) * 0.2,
                  ),
                  end: Alignment(
                    math.cos(_controller.value * 2 * math.pi + math.pi) * 0.2,
                    math.sin(_controller.value * 2 * math.pi + math.pi) * 0.2,
                  ),
                  colors: widget.colors,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),
        
        // 별 애니메이션
        if (widget.enableStars)
          const StarfieldAnimation(),
      ],
    );
  }
}

class StarfieldAnimation extends StatefulWidget {
  const StarfieldAnimation({Key? key}) : super(key: key);

  @override
  State<StarfieldAnimation> createState() => _StarfieldAnimationState();
}

class _StarfieldAnimationState extends State<StarfieldAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final math.Random _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    
    // 별 생성
    for (int i = 0; i < 100; i++) {
      _stars.add(Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 0.5,
        brightness: _random.nextDouble() * 0.6 + 0.4,
        speed: _random.nextDouble() * 0.005 + 0.001,
        offset: _random.nextDouble(),
      ));
    }
    
    // 애니메이션 컨트롤러
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // 별 애니메이션 업데이트
    _controller.addListener(() {
      for (var star in _stars) {
        star.update();
      }
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarfieldPainter(stars: _stars),
      size: Size.infinite,
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  
  StarfieldPainter({required this.stars});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.2 + star.brightness * 0.8)
        ..style = PaintingStyle.fill;
      
      // 별 그리기 - 크기와 밝기가 시간에 따라 변화
      final y = (star.y + star.offset) % 1.0 * size.height;
      
      canvas.drawCircle(
        Offset(star.x * size.width, y),
        star.size * (0.8 + star.brightness * 0.4),
        paint,
      );
      
      // 별 주변 글로우 효과
      canvas.drawCircle(
        Offset(star.x * size.width, y),
        star.size * 2.5,
        Paint()
          ..color = Colors.white.withOpacity(0.05 + star.brightness * 0.1)
          ..style = PaintingStyle.fill,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}