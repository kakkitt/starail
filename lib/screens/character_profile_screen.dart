// lib/screens/character_profile_screen.dart

import 'dart:ui'; // For ImageFilter.blur
import 'package:ai_voice_dev/models/character_model.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'package:ai_voice_dev/screens/calling_screen.dart'; // CallingScreen import

class CharacterProfileScreen extends StatefulWidget {
  final Character character;
  final bool isFriendMode;

  const CharacterProfileScreen({
    super.key,
    required this.character,
    this.isFriendMode = true,
  });

  @override
  State<CharacterProfileScreen> createState() => _CharacterProfileScreenState();
}

class _CharacterProfileScreenState extends State<CharacterProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heroImageFadeAnimation;
  late Animation<double> _detailsContainerFadeAnimation;
  late Animation<Offset> _detailsContainerSlideAnimation;
  late Animation<double> _buttonsFadeAnimation;

  // 예시 데이터 (실제로는 모델 또는 API에서 가져옴)
  final String mbti = "ENFP";
  final String hobby = "밤 산책, 인디 음악 감상, 길고양이랑 놀기";
  final String likes = "달콤한 마카롱, 뜻밖의 선물, 별 헤는 밤";
  final int relationshipLevel = 3; // 1~5
  final String relationshipStatus = "두근두근 썸타는 중 💖";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _heroImageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _detailsContainerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutQuad),
      ),
    );
    _detailsContainerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.35, 0.90, curve: Curves.easeOutQuint),
      ),
    );

    _buttonsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutQuad),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startCall(BuildContext context) {
    print('Starting call with ${widget.character.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallingScreen(
          character: widget.character,
          isFriendMode: widget.isFriendMode,
        ),
      ),
    );
  }

  void _startSimulation(BuildContext context) {
    print('Starting simulation with ${widget.character.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallingScreen(
          character: widget.character,
          isFriendMode: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = theme.brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return Scaffold(
      body: Stack(
        children: [
          // 1. 배경 그라데이션
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [
                          AppTheme.darkPrimaryBackground.withOpacity(0.8),
                          AppTheme.luminaPurple.withOpacity(0.3),
                          AppTheme.darkPrimaryBackground,
                        ]
                      : [
                          AppTheme.luminaPink.withOpacity(0.1),
                          AppTheme.luminaPurple.withOpacity(0.2),
                          AppTheme.lightPrimaryBackground,
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // 2. 캐릭터 Hero 이미지
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.65,
            child: Hero(
              tag: 'character_image_${widget.character.id}',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.character.imageAssetPath),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.65),
                      ],
                      stops: const [0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. 세부 정보 컨테이너
          Positioned.fill(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: screenHeight * 0.58),
                child: SlideTransition(
                  position: _detailsContainerSlideAnimation,
                  child: FadeTransition(
                    opacity: _detailsContainerFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0.0),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                                isDarkMode ? 0.35 : 0.12),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, -15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이름 & 온라인 상태
                          FadeTransition(
                            opacity: _heroImageFadeAnimation,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.character.name,
                                    style: theme.textTheme.displaySmall
                                        ?.copyWith(
                                      fontFamily:
                                          AppTheme.novaRoundFontFamily,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          theme.colorScheme.onBackground,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.circle,
                                          color: Colors.greenAccent
                                              .shade700,
                                          size: 10),
                                      const SizedBox(width: 6),
                                      Text(
                                        "온라인",
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: Colors.greenAccent
                                              .shade700,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: AppTheme
                                              .pretendardFontFamily,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),

                          // 짧은 소개
                          FadeTransition(
                            opacity: _heroImageFadeAnimation,
                            child: Text(
                              widget.character.shortBio,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.75),
                                height: 1.5,
                                fontFamily:
                                    AppTheme.pretendardFontFamily,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28.0),

                          // About Me 섹션
                          _buildSectionTitle(context, "About Me"),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: [
                              _buildInfoPill(
                                  context,
                                  Icons.psychology_outlined,
                                  "MBTI",
                                  mbti),
                              _buildInfoPill(
                                  context,
                                  Icons.interests_outlined,
                                  "취미",
                                  hobby),
                              _buildInfoPill(
                                  context,
                                  Icons.favorite_border_rounded,
                                  "좋아하는 것",
                                  likes),
                            ],
                          ),
                          const SizedBox(height: 28.0),

                          // 시뮬레이션 모드일 때만 보여줄 추가 정보
                          if (!widget.isFriendMode) ...[
                            _buildSectionTitle(
                                context, "AI와의 교감도"),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: relationshipLevel / 5.0,
                                    backgroundColor: theme
                                        .colorScheme.surface
                                        .withOpacity(0.5),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            theme.colorScheme.primary),
                                    minHeight: 10,
                                    borderRadius:
                                        BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  relationshipStatus,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme
                                        .pretendardFontFamily,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 32.0),
                          ],

                          // 액션 버튼
                          FadeTransition(
                            opacity: _buttonsFadeAnimation,
                            child: Column(
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(
                                    widget.isFriendMode
                                        ? Icons.phone_in_talk_outlined
                                        : Icons.play_arrow_rounded,
                                    size: 22,
                                  ),
                                  label: Text(widget.isFriendMode
                                      ? '음성으로 대화하기'
                                      : '스토리 시작하기'),
                                  onPressed: widget.isFriendMode
                                      ? () => _startCall(context)
                                      : () =>
                                          _startSimulation(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    minimumSize: const Size(
                                        double.infinity, 52),
                                    textStyle: theme
                                        .textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontFamily: AppTheme
                                          .pretendardFontFamily,
                                      letterSpacing: 0.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              16.0),
                                    ),
                                    elevation: 4,
                                    shadowColor: theme
                                        .colorScheme.primary
                                        .withOpacity(0.3),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  icon: Icon(
                                    Icons.sms_outlined,
                                    size: 20,
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.7),
                                  ),
                                  label: Text(
                                    '텍스트로 메시지 보내기',
                                    style: theme
                                        .textTheme.bodyMedium
                                        ?.copyWith(
                                      color: theme.colorScheme
                                          .onBackground
                                          .withOpacity(0.7),
                                      fontWeight:
                                          FontWeight.w500,
                                      fontFamily: AppTheme
                                          .pretendardFontFamily,
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              '텍스트 채팅 기능 (구현 예정)')),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(
                                        double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              12.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          // 하단 여백
                          SizedBox(
                              height: MediaQuery.of(context)
                                      .padding
                                      .bottom +
                                  24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. 상단 AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // 추가 옵션
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.more_horiz_rounded,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
              systemOverlayStyle: isDarkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
            ),
          ),
        ],
      ),
    );
  }

  // 섹션 타이틀 빌더
  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontFamily: AppTheme.novaRoundFontFamily,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onBackground,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // 정보 Pill 빌더
  Widget _buildInfoPill(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface
            .withOpacity(isDarkMode ? 0.8 : 1.0),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isDarkMode
              ? theme.dividerColor.withOpacity(0.25)
              : theme.dividerColor.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
                isDarkMode ? 0.12 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10.0),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.pretendardFontFamily,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
