// lib/screens/friends_tab_screen.dart

import 'dart:ui'; // For ImageFilter
import 'package:ai_voice_dev/models/character_model.dart';
import 'package:ai_voice_dev/screens/character_profile_screen.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FriendsTabScreen extends StatefulWidget {
  const FriendsTabScreen({super.key});

  @override
  State<FriendsTabScreen> createState() => _FriendsTabScreenState();
}

class _FriendsTabScreenState extends State<FriendsTabScreen> {
  // 페이지 컨트롤러 (스와이프로 캐릭터 넘기기)
  late PageController _pageController;
  int _currentPage = 0;

  // "친구" 모드 캐릭터 데이터 (수아 캐릭터 정보 수정)
  final List<Character> _friendCharacters = [
    Character(
      id: 'friend_female_01',
      name: '정연우',
      imageAssetPath: 'assets/images/character1.png', // 실제 파일 경로
      shortBio: '언제나 네 편이 되어줄게. 힘든 일 있으면 나한테 다 털어놔도 괜찮아. 같이 맛있는 거 먹으면서 수다 떨자!',
      statusMessage: '오늘 저녁엔 뭐하고 놀까? 😊',
    ),
    Character(
      id: 'friend_female_02', // ID 변경
      name: '이채은', // 이름 변경
      imageAssetPath: 'assets/images/character2.png', // 실제 파일 경로
      shortBio: '새로운 경험을 좋아해! 맛집 탐방이나 예쁜 카페 찾아다니는 거 어때? 같이 재밌는 추억 많이 만들자!', // 소개 변경
      statusMessage: '새로 나온 디저트 맛집 같이 갈래? 🍰', // 대사 변경
    ),
    // 필요하다면 여기에 더 많은 "친구" 캐릭터 추가
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85, // 한 화면에 양옆 캐릭터 살짝 보이도록
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToCharacterProfile(BuildContext context, Character character) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            CharacterProfileScreen(character: character, isFriendMode: true),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeOutQuint; // 부드러운 전환 효과
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_friendCharacters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_outlined, size: 80, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4)),
            const SizedBox(height: 20),
            Text(
              '새로운 친구들을 준비 중이에요.\n곧 만날 수 있을 거예요!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                 color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                 fontFamily: AppTheme.pretendardFontFamily,
                 height: 1.5
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // MainScaffold의 배경색을 사용하거나, 여기서 그라데이션 배경 적용
      body: Container( // 그라데이션 배경 적용
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    AppTheme.darkPrimaryBackground,
                    AppTheme.luminaPurple.withOpacity(0.25),
                    AppTheme.darkPrimaryBackground,
                  ]
                : [
                    AppTheme.luminaPink.withOpacity(0.05),
                    AppTheme.luminaPurple.withOpacity(0.1),
                    AppTheme.lightPrimaryBackground.withOpacity(0.7),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _friendCharacters.length,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            final character = _friendCharacters[index];
            // 현재 페이지의 카드는 크게, 양옆 카드는 작게 표시 (애니메이션 효과)
            final double scale = index == _currentPage ? 1.0 : 0.9;
            final double opacity = index == _currentPage ? 1.0 : 0.7;
            final double yOffset = index == _currentPage ? 0 : 30;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutQuint, // 부드러운 애니메이션 커브
              transform: Matrix4.identity()
                ..translate(0.0, yOffset)
                ..scale(scale),
              margin: EdgeInsets.only(
                top: screenHeight * 0.08, // 상단 여백
                bottom: screenHeight * 0.12, // 하단 여백 (탭바 고려)
              ),
              child: Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onTap: () => _navigateToCharacterProfile(context, character),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // 캐릭터 이미지 (Hero 애니메이션 적용)
                      Positioned.fill(
                        child: Hero(
                          tag: 'character_image_${character.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.0),
                              image: DecorationImage(
                                image: AssetImage(character.imageAssetPath),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 20.0,
                                  spreadRadius: -5.0,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 캐릭터 정보 오버레이 (이미지 하단)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(28.0),
                              bottomRight: Radius.circular(28.0),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.9),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                character.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontFamily: AppTheme.novaRoundFontFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8.0,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                character.statusMessage,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.85),
                                  fontFamily: AppTheme.pretendardFontFamily,
                                  height: 1.4
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // "대화 시작" 또는 "프로필 보기" 프롬프트 (선택 사항)
                      if (index == _currentPage)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                             decoration: BoxDecoration(
                               color: theme.colorScheme.primary.withOpacity(0.85),
                               borderRadius: BorderRadius.circular(12),
                               boxShadow: [
                                 BoxShadow(
                                   color: theme.colorScheme.primary.withOpacity(0.3),
                                   blurRadius: 8,
                                   offset: Offset(0,2)
                                 )
                               ]
                             ),
                            child: Icon(Icons.open_in_full_rounded, color: Colors.white, size: 20),
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