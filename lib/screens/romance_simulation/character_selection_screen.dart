import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/user_data.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/character_card.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final UserData userData;
  
  const CharacterSelectionScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String? _selectedCharacter;
  
  // 캐릭터 정보 - 실제 구현에서는 이미지 파일이 필요합니다.
  // assets/images/character1.jpg 와 assets/images/character2.jpg 파일을 추가하거나
  // 아래 경로를 실제 이미지 파일 경로로 변경하세요.
  final List<Map<String, String>> characters = [
    {
      'name': '미아',
      'image': 'assets/images/character1.png',
      'description': '다정하고 사려 깊은 성격의 대학생. 예술과 음악을 좋아하며, 감성적인 대화를 나누는 것을 즐깁니다.',
    },
    {
      'name': '시연',
      'image': 'assets/images/character2.png',
      'description': '활발하고 유머 감각이 뛰어난 회사원. 스포츠를 좋아하며, 모험적인 데이트를 즐깁니다.',
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        colors: const [
          Color(0xFFB19CD9), // 라벤더
          Color(0xFFDEB6D6), // 플럼
          Color(0xFFAAC9CE), // 파스텔 청록
        ],
        child: SafeArea(
          child: Column(
            children: [
              // 상단 타이틀
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Text(
                  "당신의 로맨스 파트너를 선택하세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
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
              
              // 캐릭터 선택 안내
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "${widget.userData.name}님, 함께 이야기를 만들어갈 캐릭터를 선택해주세요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 30),
              
              // 캐릭터 카드 목록
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    final isSelected = _selectedCharacter == character['name'];
                    
                    return CharacterCard(
                      name: character['name']!,
                      imageAsset: character['image']!,
                      description: character['description']!,
                      isSelected: isSelected,
                      accentColor: Colors.purple,
                      onTap: () {
                        setState(() {
                          _selectedCharacter = character['name'];
                          widget.userData.selectedCharacter = character['name'];
                        });
                      },
                    )
                    .animate()
                    .fadeIn(
                      duration: 600.ms, 
                      delay: Duration(milliseconds: 300 + (index * 200)),
                      curve: Curves.easeOut,
                    )
                    .slideX(
                      begin: 0.2, 
                      end: 0, 
                      duration: 600.ms, 
                      delay: Duration(milliseconds: 300 + (index * 200)),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ),
              
              // 시작하기 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                child: AnimatedOpacity(
                  opacity: _selectedCharacter != null ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: _selectedCharacter != null ? _startRomanceJourney : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        "로맨스 시작하기",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1000.ms, curve: Curves.easeOut)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 1000.ms, curve: Curves.easeOut),
            ],
          ),
        ),
      ),
    );
  }
  
  void _startRomanceJourney() {
    if (_selectedCharacter == null) return;
    
    // 여기에 시뮬레이션 시작 로직을 추가
    // 예: Navigator.push(context, MaterialPageRoute(builder: (_) => RomanceGameScreen(userData: widget.userData)));
    
    // 현재는 선택만 알려주는 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${_selectedCharacter}와의 로맨스가 시작됩니다!"),
        backgroundColor: Colors.purple.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}