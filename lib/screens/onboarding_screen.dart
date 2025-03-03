import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../widgets/animated_background.dart';
import '../models/experience_card.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _backgroundAnimController;
  late AnimationController _itemAnimController;
  int _currentPage = 0;
  bool _isLastPage = false;
  
  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: AppStrings.onboardingItems[0]['title']!,
      description: AppStrings.onboardingItems[0]['description']!,
      image: AppAssets.phoneAnimation,
      color: AppColors.primary,
    ),
    OnboardingItem(
      title: AppStrings.onboardingItems[1]['title']!,
      description: AppStrings.onboardingItems[1]['description']!,
      image: AppAssets.knightAnimation,
      color: AppColors.secondary,
    ),
    OnboardingItem(
      title: AppStrings.onboardingItems[2]['title']!,
      description: AppStrings.onboardingItems[2]['description']!,
      image: AppAssets.gameAnimation,
      color: AppColors.quaternary,
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _itemAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _pageController.addListener(() {
      if (_pageController.page!.round() != _currentPage) {
        _itemAnimController.forward(from: 0.0);
        setState(() {
          _currentPage = _pageController.page!.round();
          _isLastPage = _currentPage == _items.length - 1;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimController.dispose();
    _itemAnimController.dispose();
    super.dispose();
  }
  
  void _navigateToHome() {
    AudioManager().playSFX('button');
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const HomeScreen(),
          );
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // 배경 그라데이션
          AnimatedBuilder(
            animation: _backgroundAnimController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _items[_currentPage].color.withOpacity(0.6),
                      AppColors.background,
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              );
            },
          ),
          
          // 별 애니메이션
          const StarfieldAnimation(),
          
          // 페이지 뷰
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              AudioManager().playSFX('swipe');
            },
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _itemAnimController,
                builder: (context, child) {
                  // 페이지 전환 시 애니메이션 효과
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _itemAnimController,
                    curve: Curves.easeOutCubic,
                  ));
                  
                  final fadeAnimation = Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _itemAnimController,
                    curve: Curves.easeOut,
                  ));
                  
                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 애니메이션 이미지
                    SizedBox(
                      height: size.height * 0.4,
                      child: Center(
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _items[index].color.withOpacity(0.1),
                            border: Border.all(
                              color: _items[index].color.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Lottie.asset(
                            _items[index].image,
                            // 로티 에셋이 없을 경우 대체 아이콘
                            frameBuilder: (context, child, composition) {
                              return child ?? Icon(
                                index == 0 ? Icons.phone_in_talk :
                                index == 1 ? Icons.theater_comedy : Icons.sports_esports,
                                size: 100,
                                color: _items[index].color,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      _items[index].title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'GmarketSans',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _items[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // 페이지 인디케이터
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? _items[index].color : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          
          // 시작하기 버튼
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: AnimatedOpacity(
              opacity: _isLastPage ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: _navigateToHome,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "시작하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 건너뛰기 버튼
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _navigateToHome,
              child: Text(
                "건너뛰기",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}