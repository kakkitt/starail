// lib/screens/calling_screen.dart

import 'dart:async';
import 'dart:ui'; // For ImageFilter
import 'package:ai_voice_dev/models/character_model.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AI의 현재 상태를 나타내는 enum
enum AiCallState { idle, listening, thinking, speaking }

class CallingScreen extends StatefulWidget {
  final Character character;
  final bool isFriendMode; // 현재는 사용하지 않지만, 모드별 UI 차별화 시 활용 가능

  const CallingScreen({
    super.key,
    required this.character,
    this.isFriendMode = true,
  });

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> with TickerProviderStateMixin {
  Timer? _callTimer;
  int _callDurationInSeconds = 0;
  AiCallState _aiState = AiCallState.idle; // 초기 상태

  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  // 임시 대화 로그 (실제로는 STT/TTS 결과에 따라 동적으로 추가)
  final List<Map<String, String>> _conversationLog = [];

  // AI 상태 변경 및 대화 로그 추가 테스트용 변수
  int _debugStateCounter = 0;
  Timer? _debugStateTimer;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    _initializePulseAnimation();
    _startAiStateSimulation(); // AI 상태 변화 시뮬레이션 시작

    // 화면 진입 시 상태 표시줄 스타일 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 통화 화면은 어두운 계열이므로 밝은 아이콘
  }

  void _initializePulseAnimation() {
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
    );
    // 특정 상태에서만 애니메이션 반복 (예: 듣는 중, 생각 중)
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDurationInSeconds++;
        });
      }
    });
  }

  // AI 상태 변화 및 애니메이션 제어 로직
  void _setAiState(AiCallState newState) {
    if (!mounted) return;
    setState(() {
      _aiState = newState;
      if (_aiState == AiCallState.listening || _aiState == AiCallState.thinking) {
        _pulseAnimationController.repeat(reverse: true);
      } else {
        _pulseAnimationController.stop();
        // 말하기 시작할 때 _pulseAnimationController.forward() 등으로 다른 효과 줄 수도 있음
      }
    });
  }

  // AI 상태 변화 및 대화 로그 시뮬레이션 (테스트용)
  void _startAiStateSimulation() {
    _addMessage("user", "안녕 ${widget.character.name.split(" ").first}, 오늘 날씨 정말 좋다!"); // 사용자의 첫 마디
    _setAiState(AiCallState.thinking); // 사용자가 말했으니 AI는 생각 중

    _debugStateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _debugStateCounter++;
      switch (_debugStateCounter % 4) {
        case 0: // AI 말하기
          _setAiState(AiCallState.speaking);
          _addMessage("ai", "정말 그러네! 이런 날엔 공원에서 산책이라도 하고 싶어. 넌 어때?");
          break;
        case 1: // 사용자 말하기 (AI는 듣는 중)
          _setAiState(AiCallState.listening);
           // 실제로는 STT가 활성화되는 시점입니다.
          // 다음 타이머 틱에서 사용자가 말을 끝내고 AI가 생각하는 것으로 가정합니다.
          break;
        case 2: // AI 생각하기
           _addMessage("user", "산책 좋지! 맛있는 커피라도 한 잔 하면서 걸으면 더 좋을 것 같아."); // 사용자가 말을 끝냈다고 가정
          _setAiState(AiCallState.thinking);
          break;
        case 3: // AI 다시 말하기
          _setAiState(AiCallState.speaking);
          _addMessage("ai", "완벽한 계획인데? 근처에 새로 생긴 카페가 있는데 거기 커피가 그렇게 맛있대!");
          break;
      }
    });
  }

  void _addMessage(String speaker, String text) {
     if (!mounted) return;
    setState(() {
      _conversationLog.insert(0, {"speaker": speaker, "text": text}); // 새 메시지를 맨 위에 추가
    });
  }


  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _pulseAnimationController.dispose();
    _debugStateTimer?.cancel(); // 시뮬레이션 타이머 취소
    // 화면 나갈 때 원래 상태 표시줄 스타일로 복원 (필요하다면)
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  Widget _buildAiStateIndicator() {
    String stateText;
    Color indicatorColor;

    switch (_aiState) {
      case AiCallState.listening:
        stateText = "듣는 중...";
        indicatorColor = Colors.blueAccent.shade100;
        break;
      case AiCallState.thinking:
        stateText = "생각 중...";
        indicatorColor = Colors.amberAccent.shade100;
        break;
      case AiCallState.speaking:
        stateText = "${widget.character.name} 말하는 중...";
        indicatorColor = AppTheme.luminaPink.withOpacity(0.7);
        break;
      default: // AiCallState.idle
        stateText = "연결됨"; // 또는 "잠시만요..."
        indicatorColor = Colors.grey.shade400;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: indicatorColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: (_aiState == AiCallState.listening || _aiState == AiCallState.thinking)
                ? [
                    BoxShadow(
                      color: indicatorColor.withOpacity(0.5),
                      blurRadius: _pulseAnimation.value,
                      spreadRadius: _pulseAnimation.value / 3,
                    ),
                  ]
                : [],
          ),
          child: Text(
            stateText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontFamily: AppTheme.pretendardFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = theme.brightness == Brightness.dark; // 현재 테마 모드 확인

    return WillPopScope( // 뒤로가기 버튼 제어 (통화 중 실수로 나가는 것 방지)
      onWillPop: () async {
        // 여기에 통화 종료 확인 다이얼로그를 띄울 수 있습니다.
        // 예: return await _showExitConfirmationDialog() ?? false;
        return true; // 지금은 그냥 뒤로가기 허용
      },
      child: Scaffold(
        body: Stack(
          children: [
            // 1. 배경 (블러 처리된 캐릭터 이미지 또는 그라데이션)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.character.imageAssetPath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), // 블러 강도 조절
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDarkMode
                            ? [
                                AppTheme.darkPrimaryBackground.withOpacity(0.6),
                                AppTheme.luminaPurple.withOpacity(0.4),
                                AppTheme.darkPrimaryBackground.withOpacity(0.9),
                              ]
                            : [
                                AppTheme.luminaPink.withOpacity(0.3),
                                AppTheme.luminaPurple.withOpacity(0.4),
                                AppTheme.lightPrimaryBackground.withOpacity(0.7),
                              ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      // color: Colors.black.withOpacity(0.5), // 블러 위에 어두운 오버레이
                    ),
                  ),
                ),
              ),
            ),

            // 2. 콘텐츠 영역
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                child: Column(
                  children: [
                    // 상단: 캐릭터 이름, 통화 시간, AI 상태 표시기
                    Column(
                      children: [
                        Text(
                          widget.character.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: AppTheme.novaRoundFontFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDuration(_callDurationInSeconds),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: AppTheme.pretendardFontFamily
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAiStateIndicator(), // AI 상태 표시기 (듣는 중, 생각 중, 말하는 중)
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 캐릭터 이미지 (또는 애니메이션되는 비주얼라이저)
                    Expanded(
                      flex: 3, // 화면 비율 조정
                      child: Center(
                        child: Hero( // 프로필 화면에서 이어지는 Hero 애니메이션
                          tag: 'character_image_${widget.character.id}',
                          child: Container(
                            width: screenWidth * 0.6, // 이미지 크기
                            height: screenWidth * 0.6 * (4/3), // 이미지 비율 (세로가 약간 길게)
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              image: DecorationImage(
                                image: AssetImage(widget.character.imageAssetPath),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            // TODO: 여기에 캐릭터의 감정/발화 상태에 따라 변하는
                            // 짧은 영상 루프 또는 Rive 애니메이션을 넣으면 훨씬 좋습니다.
                          ),
                        ),
                      ),
                    ),
                    
                    // 대화 로그 (선택 사항)
                    // 지금은 간결함을 위해 주석 처리. 필요시 활성화.
                    /*
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: ListView.builder(
                          reverse: true, // 최신 메시지가 하단에 오도록
                          itemCount: _conversationLog.length,
                          itemBuilder: (context, index) {
                            final log = _conversationLog[index];
                            bool isUser = log["speaker"] == "user";
                            return Align(
                              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                decoration: BoxDecoration(
                                  color: isUser 
                                      ? theme.colorScheme.primary.withOpacity(0.8) 
                                      : theme.colorScheme.surface.withOpacity(isDarkMode ? 0.5:0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  log["text"]!,
                                  style: TextStyle(
                                    color: isUser 
                                        ? theme.colorScheme.onPrimary 
                                        : theme.colorScheme.onSurface,
                                    fontFamily: AppTheme.pretendardFontFamily
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    */
                    const Spacer(flex: 1), // 버튼 전 여백


                    // 하단: 컨트롤 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 음소거 버튼 (토글)
                        _buildControlButton(
                          context,
                          icon: Icons.mic_off_outlined, // 예시 (실제로는 토글 상태에 따라 아이콘 변경)
                          label: "음소거",
                          onTap: () {
                            // TODO: 음소거 로직
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('음소거 기능 (구현 예정)')),
                            );
                          },
                        ),
                        // 통화 종료 버튼
                        _buildControlButton(
                          context,
                          icon: Icons.call_end,
                          label: "종료",
                          backgroundColor: Colors.redAccent.shade400,
                          iconColor: Colors.white,
                          onTap: () {
                            Navigator.of(context).pop(); // 현재 화면 닫기
                          },
                          isHangUp: true,
                        ),
                        // 스피커 버튼 (토글)
                        _buildControlButton(
                          context,
                          icon: Icons.volume_up_outlined, // 예시
                          label: "스피커",
                          onTap: () {
                            // TODO: 스피커 전환 로직
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('스피커 전환 기능 (구현 예정)')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
    bool isHangUp = false,
  }) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface.withOpacity(0.2);
    final fgColor = iconColor ?? Colors.white.withOpacity(0.85);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isHangUp ? 40 : 30), // 종료 버튼은 더 크게
          child: Container(
            width: isHangUp ? 72 : 60, // 종료 버튼은 더 크게
            height: isHangUp ? 72 : 60,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0,2)
                )
              ]
            ),
            child: Icon(icon, color: fgColor, size: isHangUp ? 32 : 26),
          ),
        ),
        if (!isHangUp) ...[ // 종료 버튼에는 레이블 생략 가능 또는 다른 스타일 적용
            const SizedBox(height: 8),
            Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontFamily: AppTheme.pretendardFontFamily,
              ),
            ),
        ]
      ],
    );
  }
}