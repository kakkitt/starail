import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../widgets/animated_background.dart';
import 'romance_simulation/romance_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoaded = false;
  
  final List<ExperienceCard> _experienceCards = [
    ExperienceCard(
      title: "AI 전화",
      description: "현실같은 AI와의 자연스러운 대화",
      icon: Icons.phone_rounded,
      color: const Color(0xFF6E44FF),
      highlightColor: const Color(0xFF9E80FF),
      gradient: const LinearGradient(
        colors: [Color(0xFF6E44FF), Color(0xFF9C6FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "음성 롤플레이",
      description: "중세 기사단 면접, 마법학교 입학시험 등",
      icon: Icons.psychology,
      color: const Color(0xFF00E1FF),
      highlightColor: const Color(0xFF5EEDFF),
      gradient: const LinearGradient(
        colors: [Color(0xFF00A3FF), Color(0xFF00E1FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "AI 라디오",
      description: "당신만을 위한 맞춤형 라디오 쇼",
      icon: Icons.radio,
      color: const Color(0xFFFF6B9E),
      highlightColor: const Color(0xFFFF8EB5),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF4486), Color(0xFFFF6B9E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "음성 RPG",
      description: "목소리로 즐기는 몰입형 어드벤처",
      icon: Icons.sports_esports,
      color: const Color(0xFFFFB443),
      highlightColor: const Color(0xFFFFCF85),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF9620), Color(0xFFFFB443)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "연애 시뮬레이션",
      description: "감성적인 대화로 발전하는 관계",
      icon: Icons.favorite,
      color: const Color(0xFFFF44A1),
      highlightColor: const Color(0xFFFF7BBA),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF44A1), Color(0xFFFF7BBA)],
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
    if (index == 4) { // 연애 시뮬레이션 인덱스
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
      // 다른 메뉴 카드 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_experienceCards[index].title} 준비 중입니다."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }
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
              Color(0xFFB5E8FF),  // 밝은 하늘색
              Color(0xFFD4F1FF),  // 매우 연한 하늘색
              Color(0xFFE8F8FF),  // 거의 흰색에 가까운 연한 하늘색
            ],
            child: Container(), // 빈 컨테이너
          ),
          
          // 메인 내용
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 앱바 - 환영 메시지와 캐릭터
                AnimatedOpacity(
                  opacity: _isLoaded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),  // 더 밝은 배경으로 변경
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),  // 그림자도 밝게 변경
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 프로필 캐릭터 애니메이션
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6E44FF), Color(0xFFFF44A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.face,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 환영 텍스트
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "안녕하세요!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF505050),  // 어두운 텍스트 색상
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "오늘은 어떤 음성 경험을 원하세요?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.6),  // 어두운 텍스트 색상
                                ),
                              ),
                            ],
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
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: const Center(
                                child: Icon(
                                  Icons.settings,
                                  color: Color(0xFF505050),  // 어두운 아이콘 색상
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 메인 타이틀
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
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
                      child: Text(
                        "나만의 음성 경험",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF505050),  // 어두운 텍스트 색상
                          letterSpacing: 0.5,
                          fontFamily: 'GmarketSans',
                        ),
                      ),
                    ),
                  ),
                ),
                
                // 경험 카드 리스트
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _experienceCards.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutQuint,
                        transform: Matrix4.translationValues(
                          0, 
                          _isLoaded ? 0 : 100 + (index * 20), 
                          0,
                        ),
                        child: AnimatedOpacity(
                          opacity: _isLoaded ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: ExperienceCardWidget(
                            experienceCard: _experienceCards[index],
                            onTap: () => _navigateToExperienceDetail(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // 하단 마이크 버튼
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
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("음성 인식 준비중입니다."),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6E44FF), Color(0xFFFF44A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6E44FF).withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mic,
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
        ],
      ),
    );
  }
}

// 경험 카드 데이터 모델
class ExperienceCard {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color highlightColor;
  final Gradient gradient;
  
  ExperienceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.highlightColor,
    required this.gradient,
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
    return MouseRegion(
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
                5 * _hoverController.value,
                0,
              ),
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: widget.experienceCard.gradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.experienceCard.color.withOpacity(0.3 + 0.2 * _hoverController.value),
                      blurRadius: 15 + 5 * _hoverController.value,
                      spreadRadius: 2 + 2 * _hoverController.value,
                      offset: Offset(0, 5 - 2 * _hoverController.value),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // 빛나는 강조 효과
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.experienceCard.highlightColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                      
                      // 카드 내용
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15 + 0.05 * _hoverController.value),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  widget.experienceCard.icon,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.experienceCard.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.experienceCard.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              transform: Matrix4.translationValues(
                                10 * _hoverController.value,
                                0,
                                0,
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 30,
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
    );
  }
}