import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

import '../../models/user_data.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/fancy_text_field.dart';
import 'character_selection_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  String? _selectedGender;
  bool _isNameEntered = false;
  bool _isGenderSelected = false;
  bool _showWelcome = false;
  late UserData userData;
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    
    userData = UserData();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _nameFocusNode.requestFocus();
    
    // 사용자의 입력 상태 감지
    _nameController.addListener(_checkNameInput);
  }
  
  void _checkNameInput() {
    setState(() {
      _isNameEntered = _nameController.text.isNotEmpty;
    });
  }
  
  void _proceedToWelcome() {
    if (_isNameEntered && _isGenderSelected) {
      // 사용자 데이터 저장
      userData.name = _nameController.text;
      userData.gender = _selectedGender;
      
      // 키보드 닫기
      FocusScope.of(context).unfocus();
      
      // 환영 메시지 표시
      setState(() {
        _showWelcome = true;
      });
      
      // 2초 후 캐릭터 선택 화면으로 이동
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: CharacterSelectionScreen(userData: userData),
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

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
          child: _showWelcome ? _buildWelcomeScreen() : _buildInputScreen(),
        ),
      ),
    );
  }
  
  Widget _buildInputScreen() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 타이틀
              Text(
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
              )
              .animate()
              .fadeIn(duration: 600.ms, curve: Curves.easeOut)
              .slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 10),
              
              // 부제목
              Text(
                "당신만의 특별한 로맨스 여행을 시작합니다",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOut)
              .slideY(begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 60),
              
              // 이름 입력 필드
              FancyTextField(
                hintText: "당신의 이름을 말해주세요",
                controller: _nameController,
                focusNode: _nameFocusNode,
                autofocus: true,
                accentColor: Colors.purple,
                onSubmitted: (value) {
                  if (_isNameEntered) {
                    _proceedToWelcome();
                  }
                },
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 400.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 20),
              
              // 성별 선택 드롭다운
              FancyDropdown<String>(
                hintText: "당신의 성별을 말해주세요",
                items: const [
                  DropdownMenuItem(
                    value: "남성",
                    child: Text("남성"),
                  ),
                  DropdownMenuItem(
                    value: "여성",
                    child: Text("여성"),
                  ),
                  DropdownMenuItem(
                    value: "기타",
                    child: Text("기타"),
                  ),
                ],
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    _isGenderSelected = value != null;
                  });
                  
                  if (_isNameEntered && _isGenderSelected) {
                    _proceedToWelcome();
                  }
                },
                accentColor: Colors.purple,
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms, curve: Curves.easeOut)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 600.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 50),
              
              // 계속하기 버튼
              AnimatedOpacity(
                opacity: _isNameEntered && _isGenderSelected ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: _proceedToWelcome,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.8),
                          Colors.blue.withOpacity(0.6),
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
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 환영 아이콘
          Icon(
            Icons.favorite,
            size: 80,
            color: Colors.pink.withOpacity(0.8),
          )
          .animate(controller: _animationController)
          .scale(duration: 600.ms, curve: Curves.elasticOut)
          .fadeIn(duration: 300.ms),
          
          const SizedBox(height: 40),
          
          // 환영 메시지
          Text(
            "반갑습니다, ${_nameController.text}님!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
              shadows: [
                Shadow(
                  color: Colors.purple.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          )
          .animate(controller: _animationController)
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),
          
          const SizedBox(height: 20),
          
          // 로딩 인디케이터
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.withOpacity(0.8)),
            ),
          )
          .animate(controller: _animationController)
          .fadeIn(duration: 600.ms, delay: 300.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}