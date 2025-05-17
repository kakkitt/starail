// lib/screens/calling_screen.dart

import 'dart:async';
import 'dart:convert'; // For jsonEncode, jsonDecode, utf8
import 'dart:ui'; // For ImageFilter
import 'package:ai_voice_dev/models/character_model.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

enum AiCallState { idle, listening, thinking, speaking, error }

class CallingScreen extends StatefulWidget {
  final Character character;
  final bool isFriendMode;

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
  AiCallState _aiState = AiCallState.idle;

  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _conversationLog = [];
  final TextEditingController _textEditingController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _serverUrl = "http://127.0.0.1:8000/chat";

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    _initializePulseAnimation();

    _addMessage(
      "system",
      "${widget.character.name}와(과)의 통화가 시작되었습니다.\n"
      "캐릭터 이미지를 탭하여 메시지를 입력하세요."
    );
    _setAiState(AiCallState.listening);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed && mounted) {
        _setAiState(AiCallState.listening);
      }
    });
  }

  void _initializePulseAnimation() {
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
    );
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _callDurationInSeconds++);
      }
    });
  }

  void _setAiState(AiCallState newState) {
    if (!mounted) return;
    setState(() {
      _aiState = newState;
      if (_aiState == AiCallState.listening) {
        _pulseAnimationController.repeat(reverse: true);
      } else {
        _pulseAnimationController.stop();
      }
    });
  }

  void _addMessage(String speaker, String text) {
    if (!mounted) return;
    setState(() {
      _conversationLog.insert(0, {"speaker": speaker, "text": text});
    });
  }

  Future<void> _sendMessageToServer(String userMessage) async {
    print("[Flutter] Attempting to send message: '$userMessage'");
    if (userMessage.trim().isEmpty) return;

    _addMessage("user", userMessage);
    _setAiState(AiCallState.thinking);

    // 연결 테스트
    try {
      final testGet = await http.get(Uri.parse("http://127.0.0.1:8000/docs"));
      print("[Flutter] TEST: GET to /docs - Status: ${testGet.statusCode}");
    } catch (e) {
      print("[Flutter] TEST: GET to /docs error: $e");
    }

    print("[Flutter] Making HTTP POST request to $_serverUrl...");
    try {
      final response = await http.post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'user_message': userMessage,
          'character_id': 'character_${widget.character.name}',
        }),
      ).timeout(const Duration(seconds: 60));

      print("[Flutter] Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiText = data['ai_message'] as String;
        final audioUrl = data['audio_url'] as String?;
        print("[Flutter] AI: $aiText, Audio: $audioUrl");

        _addMessage("ai", aiText);
        _setAiState(AiCallState.speaking);
        if (audioUrl != null && audioUrl.isNotEmpty) {
          await _audioPlayer.play(UrlSource(audioUrl));
        } else {
          _setAiState(AiCallState.listening);
        }
      } else {
        final err = utf8.decode(response.bodyBytes);
        print("[Flutter] Server error ${response.statusCode}: $err");
        _addMessage("system", "서버 오류: ${response.statusCode}");
        _setAiState(AiCallState.error);
        Future.delayed(const Duration(seconds: 3), () => _setAiState(AiCallState.listening));
      }
    } catch (e) {
      print("[Flutter] POST /chat error: $e");
      _addMessage("system", "통신 오류: $e");
      _setAiState(AiCallState.error);
      Future.delayed(const Duration(seconds: 3), () => _setAiState(AiCallState.listening));
    }
  }

  void _showTextInputDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.darkSurfaceColor.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "${widget.character.name}에게 메시지 보내기",
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppTheme.pretendardFontFamily
          ),
        ),
        content: TextField(
          controller: _textEditingController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "할 말을 입력하세요...",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.luminaPink)
            ),
          ),
          onSubmitted: (val) {
            if (val.isNotEmpty) {
              _sendMessageToServer(val);
              _textEditingController.clear();
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            child: Text("취소", style: TextStyle(color: Colors.white70)),
            onPressed: () {
              _textEditingController.clear();
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.luminaPink.withOpacity(0.8)
            ),
            child: Text("전송", style: TextStyle(color: Colors.white)),
            onPressed: () {
              final txt = _textEditingController.text;
              if (txt.isNotEmpty) {
                _sendMessageToServer(txt);
                _textEditingController.clear();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(int sec) {
    final m = (sec / 60).floor().toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _pulseAnimationController.dispose();
    _textEditingController.dispose();
    _audioPlayer.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  Widget _buildAiStateIndicator() {
    switch (_aiState) {
      case AiCallState.thinking:
        return const Text("생각 중...", style: TextStyle(color: Colors.white, fontSize: 13));
      case AiCallState.listening:
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.shade100.withOpacity(0.5),
                  blurRadius: _pulseAnimation.value,
                  spreadRadius: _pulseAnimation.value / 3
                )
              ],
            ),
            child: const Text(
              "듣는 중...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        );
      case AiCallState.speaking:
        return _stateContainer("${widget.character.name.split(" ").first} 말하는 중...");
      case AiCallState.error:
        return _stateContainer("오류 발생", color: Colors.red.shade300);
      default:
        return _stateContainer("연결됨", color: Colors.grey.shade400);
    }
  }

  Widget _stateContainer(String text, {Color? color}) {
    final bg = (color ?? AppTheme.luminaPink).withOpacity(0.2);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.of(context).size.width;
    final isDark = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 배경
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.character.imageAssetPath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
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
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 화면 내용
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      // 상단 타이틀 & 상태
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
                              fontFamily: AppTheme.pretendardFontFamily,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildAiStateIndicator(),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 캐릭터 이미지 영역
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_aiState == AiCallState.listening ||
                                  _aiState == AiCallState.error ||
                                  _aiState == AiCallState.idle) {
                                _showTextInputDialog();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('AI가 응답 중이거나 생각 중일 때는 메시지를 보낼 수 없습니다.'),
                                  ),
                                );
                              }
                            },
                            child: Hero(
                              tag: 'character_image_${widget.character.id}',
                              child: Container(
                                width: w * 0.6,
                                height: w * 0.6 * 4 / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
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
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // ↓ 여기부터 수정된 Row ↓
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildControlButton(
                              context,
                              icon: Icons.mic_off_outlined,
                              label: "음소거",
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('음소거 기능 (구현 예정)')),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildControlButton(
                              context,
                              icon: Icons.call_end,
                              label: "종료",
                              backgroundColor: Colors.redAccent.shade400,
                              iconColor: Colors.white,
                              onTap: () => Navigator.of(context).pop(),
                              isHangUp: true,
                            ),
                          ),
                          Expanded(
                            child: _buildControlButton(
                              context,
                              icon: Icons.volume_up_outlined,
                              label: "스피커",
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('스피커 전환 기능 (구현 예정)')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // ↑ 수정된 Row 끝 ↑
                    ],
                  ),
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
          borderRadius: BorderRadius.circular(isHangUp ? 40 : 30),
          child: Container(
            width: isHangUp ? 72 : 60,
            height: isHangUp ? 72 : 60,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: fgColor, size: isHangUp ? 32 : 26),
          ),
        ),
        if (!isHangUp) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }
}
