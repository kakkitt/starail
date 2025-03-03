import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

import '../models/experience_card.dart';

class ExperienceCardWidget extends StatefulWidget {
  final ExperienceCard card;
  final VoidCallback onTap;
  final bool isVisible;
  final int index;
  
  const ExperienceCardWidget({
    Key? key,
    required this.card,
    required this.onTap,
    this.isVisible = false,
    required this.index,
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
    // 애니메이션 지연 계산
    final animationDelay = Duration(milliseconds: 150 + (widget.index * 100));
    
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          left: widget.isVisible ? 0 : 50,
          bottom: 16
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
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
            onTap: () {
              widget.onTap();
            },
            child: AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                // 호버 애니메이션
                return Transform.translate(
                  offset: Offset(
                    5 * _hoverController.value,
                    0,
                  ),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: widget.card.gradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: widget.card.color.withOpacity(0.3 + 0.2 * _hoverController.value),
                          blurRadius: 15 + 5 * _hoverController.value,
                          spreadRadius: 2 + 2 * _hoverController.value,
                          offset: Offset(0, 5 - 2 * _hoverController.value),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
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
                                  color: widget.card.highlightColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                            
                            // 카드 내용
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  // 아이콘 컨테이너
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15 + 0.05 * _hoverController.value),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Lottie.asset(
                                          widget.card.animationAsset,
                                          frameBuilder: (context, child, composition) {
                                            // 로티 에셋이 없는 경우, 기본 아이콘 표시
                                            return child ?? Icon(
                                              widget.card.icon,
                                              size: 30,
                                              color: Colors.white,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // 텍스트 내용
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.card.title,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.card.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.8),
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}