import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math; // 이 import가 올바르게 사용되도록 수정

import 'romance_simulation/romance_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoaded = false;

  // 단 두 가지 모드만 사용
  final List<ExperienceCard> _experienceCards = [
    ExperienceCard(
      title: "AI 컴패니언",
      description: "친밀한 대화와 교감을 나누는 시간",
      icon: Icons.chat_bubble_outline_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "연애 시뮬레이션",
      description: "감성적인 대화로 발전하는 로맨스",
      icon: Icons.favorite_border_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B9E), Color(0xFFFF8CAF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // 홈 화면 로딩 효과
    Future.delayed(const Duration(milliseconds: 300), () {
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

  void _navigateToExperienceDetail(int index) {
    if (index == 1) { // 연애 시뮬레이션 인덱스
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: const RomanceMainScreen(),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      // AI 컴패니언 모드 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_experienceCards[index].title} 준비 중입니다"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF9D50BB).withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 새로운 그라데이션 배경
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0C3FC),  // 밝은 라벤더
                  Color(0xFFFBC2EB),  // 소프트 핑크
                ],
              ),
            ),
          ),

          // 배경 효과 - 작은 빛나는 요소들
          CustomPaint(
            size: Size(size.width, size.height),
            painter: BackgroundShimmerPainter(
              animation: _animationController,
            ),
          ),

          // 메인 콘텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 상단 헤더
                  AnimatedOpacity(
                    opacity: _isLoaded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: _buildProfileHeader(),
                  ),

                  const SizedBox(height: 30),
                  
                  // 메인 타이틀
                  AnimatedSlide(
                    offset: _isLoaded ? Offset.zero : const Offset(0, 0.2),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuint,
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "목소리로 열리는",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6A4B96),
                                letterSpacing: 0.5,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "새로운 관계",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A4B96),
                                letterSpacing: 0.5,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  // 경험 카드 리스트
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _experienceCards.length,
                        itemBuilder: (context, index) {
                          return AnimatedSlide(
                            offset: _isLoaded 
                                ? Offset.zero 
                                : Offset(0, 0.2 * (index + 1)),
                            duration: Duration(milliseconds: 800 + (index * 100)),
                            curve: Curves.easeOutQuint,
                            child: ExperienceCardWidget(
                              experienceCard: _experienceCards[index],
                              onTap: () => _navigateToExperienceDetail(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // 하단 마이크 버튼
                  AnimatedSlide(
                    offset: _isLoaded ? Offset.zero : const Offset(0, 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("음성 인식 준비중입니다"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: const Color(0xFF9D50BB).withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9D50BB), Color(0xFFFF6B9E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9D50BB).withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mic_rounded,
                              color: Colors.white,
                              size: 30,
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

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              // 프로필 이미지
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D50BB), Color(0xFFFF6B9E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              
              // 환영 메시지
              const Expanded(
                child: Text(
                  "당신만을 위한 특별한 순간",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A4B96),
                  ),
                ),
              ),
              
              // 설정 버튼
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF6A4B96),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 경험 카드 데이터 모델
class ExperienceCard {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;

  ExperienceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}

// 배경 효과 페인터
class BackgroundShimmerPainter extends CustomPainter {
  final Animation<double> animation;
  final List<ShimmerDot> dots = [];

  BackgroundShimmerPainter({required this.animation}) : super(repaint: animation) {
    final random = math.Random();
    
    // 30개의 반짝이는 점 생성
    for (int i = 0; i < 30; i++) {
      dots.add(ShimmerDot(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 4 + 1,
        opacity: random.nextDouble() * 0.5 + 0.1,
        speed: random.nextDouble() * 0.001 + 0.0005,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var dot in dots) {
      final paint = Paint()
        ..color = const Color(0xFFFFFFFF).withOpacity(
          (dot.opacity + (animation.value * 0.2)) % 1
        )
        ..style = PaintingStyle.fill;

      // 애니메이션 값에 따라 위치 변경
      final x = (dot.x + animation.value * dot.speed) % 1.0 * size.width;
      final y = (dot.y - animation.value * dot.speed) % 1.0 * size.height;

      // 원 그리기
      canvas.drawCircle(
        Offset(x, y),
        dot.size,
        paint,
      );
      
      // 블러 효과
      canvas.drawCircle(
        Offset(x, y),
        dot.size * 2,
        Paint()
          ..color = const Color(0xFFFFFFFF).withOpacity(dot.opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ShimmerDot {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;

  ShimmerDot({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
  });
}

// 경험 카드 위젯
class ExperienceCardWidget extends StatefulWidget {
  final ExperienceCard experienceCard;
  final VoidCallback onTap;

  const ExperienceCardWidget({
    Key? key,
    required this.experienceCard,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ExperienceCardWidget> createState() => _ExperienceCardWidgetState();
}

class _ExperienceCardWidgetState extends State<ExperienceCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  8 * _hoverController.value,
                  0,
                ),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: widget.experienceCard.gradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: widget.experienceCard.gradient.colors.first.withOpacity(0.2 + 0.2 * _hoverController.value),
                        blurRadius: 15 + 10 * _hoverController.value,
                        spreadRadius: 1 + 2 * _hoverController.value,
                        offset: Offset(0, 5 - 2 * _hoverController.value),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        // 빛나는 효과
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        
                        // 카드 내용
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              // 아이콘 컨테이너
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15 + 0.05 * _hoverController.value),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.experienceCard.icon,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              
                              // 텍스트 내용
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.experienceCard.title,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.experienceCard.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.9),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // 화살표 아이콘
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                transform: Matrix4.translationValues(
                                  10 * _hoverController.value,
                                  0,
                                  0,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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