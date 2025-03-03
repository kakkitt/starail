import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../utils/audio_manager.dart';
import '../utils/constants.dart';

class VoiceCommandSheet extends StatefulWidget {
  const VoiceCommandSheet({Key? key}) : super(key: key);

  @override
  State<VoiceCommandSheet> createState() => _VoiceCommandSheetState();
}

class _VoiceCommandSheetState extends State<VoiceCommandSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _audioLevels = List.generate(30, (_) => 0.1);
  final math.Random _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
    
    // 오디오 레벨 시뮬레이션
    _simulateAudioLevels();
  }
  
  void _simulateAudioLevels() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _audioLevels.length; i++) {
            _audioLevels[i] = _random.nextDouble() * 0.8 + 0.2;
          }
        });
        _simulateAudioLevels();
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF272B57),
            AppColors.background,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Column(
          children: [
            // 드래그 핸들
            Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(top: 15, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            
            // 타이틀
            const Text(
              "무엇을 도와드릴까요?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 음성 시각화
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  30,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 8,
                    height: 20 + 100 * _audioLevels[index],
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary,
                          Color.lerp(
                            AppColors.primary,
                            AppColors.tertiary,
                            _audioLevels[index],
                          )!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            
            // 제안 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _buildSuggestionCard(
                    title: "AI 전화 걸기",
                    description: "AI와 자연스러운 대화를 나누세요",
                    icon: Icons.phone_in_talk,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 15),
                  _buildSuggestionCard(
                    title: "음성 롤플레이 시작",
                    description: "다양한 캐릭터와 대화해보세요",
                    icon: Icons.theater_comedy,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // 취소 버튼
            GestureDetector(
              onTap: () {
                AudioManager().playSFX('cancel');
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "취소",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSuggestionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.4),
            size: 16,
          ),
        ],
      ),
    );
  }
}