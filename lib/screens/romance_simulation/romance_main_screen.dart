import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/animated_background.dart';
import 'user_info_screen.dart';

class RomanceMainScreen extends StatelessWidget {
  const RomanceMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        colors: const [
          Color(0xFFFFC0CB), // 파스텔 핑크
          Color(0xFFD8BFD8), // 파스텔 퍼플  
          Color(0xFFADD8E6), // 파스텔 블루
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 뒤로가기 버튼
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms),
                
                const Spacer(flex: 1),
                
                // 메인 타이틀
                Center(
                  child: Text(
                    "연애 시뮬레이션",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                      shadows: [
                        Shadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                .slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),
                
                const SizedBox(height: 20),
                
                // 부제목
                Center(
                  child: Text(
                    "당신만의 특별한 로맨스 여행",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOut)
                .slideY(begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms, curve: Curves.easeOut),
                
                const Spacer(flex: 2),
                
                // 중앙 일러스트
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.6),
                          Colors.pink.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms, curve: Curves.easeOut)
                .scale(duration: 800.ms, delay: 400.ms, curve: Curves.easeOut),
                
                const Spacer(flex: 2),
                
                // 시작하기 버튼
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const UserInfoScreen(),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.8),
                            Colors.pink.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        "시작하기",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 800.ms, curve: Curves.easeOut)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 800.ms, curve: Curves.easeOut),
                
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}