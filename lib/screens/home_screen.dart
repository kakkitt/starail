import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../models/experience_card.dart';
import '../widgets/animated_background.dart';
import '../widgets/experience_card_widget.dart';
import '../widgets/voice_command_sheet.dart';
import 'experience_detail_screen.dart';

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
      icon: Icons.phone_in_talk,
      color: AppColors.primary,
      highlightColor: const Color(0xFF9E80FF),
      gradient: const LinearGradient(
        colors: [AppColors.primary, Color(0xFF9C6FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      animationAsset: AppAssets.phoneAnimation,
    ),
    ExperienceCard(
      title: "음성 롤플레이",
      description: "중세 기사단 면접, 마법학교 입학시험 등",
      icon: Icons.theater_comedy,
      color: AppColors.secondary,
      highlightColor: const Color(0xFF5EEDFF),
      gradient: const LinearGradient(
        colors: [Color(0xFF00A3FF), AppColors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      animationAsset: AppAssets.knightAnimation,
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
      animationAsset: AppAssets.radioAnimation,
    ),
    ExperienceCard(
      title: "음성 RPG",
      description: "목소리로 즐기는 몰입형 어드벤처",
      icon: Icons.sports_esports,
      color: AppColors.quaternary,
      highlightColor: const Color(0xFFFFCF85),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF9620), AppColors.quaternary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      animationAsset: AppAssets.gameAnimation,
    ),
    ExperienceCard(
      title: "연애 시뮬레이션",
      description: "감성적인 대화로 발전하는 관계",
      icon: Icons.favorite,
      color: AppColors.tertiary,
      highlightColor: const Color(0xFFFF7BBA),
      gradient: const LinearGradient(
        colors: [AppColors.tertiary, Color(0xFFFF7BBA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      animationAsset: AppAssets.heartAnimation,
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
  
  void _navigateToExperienceDetail(ExperienceCard card) {
    AudioManager().playSFX('card_tap');
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ExperienceDetailScreen(card: card),
          );
        },
      ),
    );
  }
  
  void _showVoiceCommandSheet() {
    AudioManager().playSFX('button');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const VoiceCommandSheet(),
    );
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
              AppColors.background,
              AppColors.darkBlue,
              AppColors.background,
            ],
          ),
          
          // 움직이는 그라데이션 원 (추가 시각 효과)
          Positioned(
            top: -size.width * 0.5,
            right: -size.width * 0.5,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: size.width,
                  height: size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                );
              },
            ),
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
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                              colors: [AppColors.primary, AppColors.tertiary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              AppAssets.welcomeCharacter,
                              fit: BoxFit.cover,
                              // 이미지가 없는 경우 아이콘으로 대체
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.face,
                                  color: Colors.white,
                                  size: 30,
                                );
                              },
                            ),
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
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "오늘은 어떤 음성 경험을 원하세요?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
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
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Center(
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.white.withOpacity(0.7),
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
                          color: Colors.white,
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
                      return ExperienceCardWidget(
                        card: _experienceCards[index],
                        onTap: () => _navigateToExperienceDetail(_experienceCards[index]),
                        isVisible: _isLoaded,
                        index: index,
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
                        onTap: _showVoiceCommandSheet,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.tertiary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
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