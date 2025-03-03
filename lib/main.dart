import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
// Rive 패키지를 특별한 접두사로 가져옵니다
import 'package:rive/rive.dart' as rive;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const AIPhoneApp());
}

class AIPhoneApp extends StatelessWidget {
  const AIPhoneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 전화',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6E44FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6E44FF),
          secondary: Color(0xFF00E1FF),
          tertiary: Color(0xFFFF44A1),
          background: Color(0xFF0A0C24),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0C24),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'GmarketSans'),
          titleLarge: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontFamily: 'Pretendard'),
          bodyMedium: TextStyle(fontFamily: 'Pretendard'),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// 오디오 관리 클래스
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer bgmPlayer = AudioPlayer();
  final AudioPlayer sfxPlayer = AudioPlayer();
  
  Future<void> playBGM() async {
    // 실제 구현에서는 assets 폴더에 음악 파일 필요
    // await bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    // 음악 루프 설정
    // bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }
  
  Future<void> playSFX(String sfxName) async {
    // await sfxPlayer.play(AssetSource('audio/$sfxName.mp3'));
  }
}

// 스플래시 스크린
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  bool _showLogo = false;
  bool _showText = false;
  
  @override
  void initState() {
    super.initState();
    
    // 오디오 플레이어 초기화
    AudioManager().playBGM();
    
    // 로고 애니메이션 컨트롤러
    _logoAnimationController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2),
    );
    
    // 배경 애니메이션 컨트롤러
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _backgroundAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_backgroundController);
    
    // 스플래시 시퀀스 시작
    _startSplashSequence();
  }
  
  Future<void> _startSplashSequence() async {
    // 지연 시간 후 로고 표시
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showLogo = true);
    
    // 로고 애니메이션 시작
    _logoAnimationController.forward();
    
    // 추가 지연 후 텍스트 표시
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _showText = true);
    
    // 애니메이션 완료 후 메인 화면으로 이동
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: const OnboardingScreen(),
            );
          },
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // 움직이는 그라데이션 배경
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.cos(_backgroundAnimation.value) * 0.2,
                      math.sin(_backgroundAnimation.value) * 0.2,
                    ),
                    end: Alignment(
                      math.cos(_backgroundAnimation.value + math.pi) * 0.2,
                      math.sin(_backgroundAnimation.value + math.pi) * 0.2,
                    ),
                    colors: const [
                      Color(0xFF0A0C24),
                      Color(0xFF1A1154),
                      Color(0xFF0A0C24),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // 빛나는 파티클 배경
          CustomPaint(
            size: Size(size.width, size.height),
            painter: StarfieldPainter(),
          ),
          
          // 원형 그라데이션 효과
          Center(
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6E44FF).withOpacity(0.3),
                    const Color(0xFF6E44FF).withOpacity(0),
                  ],
                  stops: const [0.2, 1.0],
                ),
              ),
            ),
          ),
          
          // 로고 애니메이션
          Center(
            child: AnimatedOpacity(
              opacity: _showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: Curves.elasticOut.transform(_logoAnimationController.value),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6E44FF).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.mic,
                          size: 70,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 앱 타이틀 텍스트
          Positioned(
            bottom: size.height * 0.25,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: Column(
                children: [
                  const Text(
                    "VOICE NEXUS",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                      fontFamily: 'GmarketSans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "몰입형 AI 음성 경험",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 로딩 인디케이터
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Center(
                child: SizedBox(
                  width: 160,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00E1FF).withOpacity(0.8)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 별빛 배경 페인터
class StarfieldPainter extends CustomPainter {
  final int starCount = 100;
  final List<Star> stars = [];
  final math.Random random = math.Random();
  
  StarfieldPainter() {
    for (int i = 0; i < starCount; i++) {
      stars.add(Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3,
        brightness: random.nextDouble(),
      ));
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.1 + star.brightness * 0.7)
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
      
      // 빛나는 효과 추가
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * 2,
        Paint()
          ..color = Colors.white.withOpacity(0.03 + star.brightness * 0.1)
          ..style = PaintingStyle.fill,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Star {
  final double x;
  final double y;
  final double size;
  final double brightness;
  
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.brightness,
  });
}

// 온보딩 화면
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: "초현실적 대화 경험",
      description: "AI와의 전화 통화가 실제처럼 자연스럽게.\n음성 톤과 감정까지 완벽하게 구현됩니다.",
      image: 'assets/images/onboarding_1.png',
      color: const Color(0xFF6E44FF),
    ),
    OnboardingItem(
      title: "다양한 음성 롤플레이",
      description: "중세 기사부터 미래 로봇까지.\n상상 속 캐릭터와 대화하세요.",
      image: 'assets/images/onboarding_2.png',
      color: const Color(0xFF00E1FF),
    ),
    OnboardingItem(
      title: "목소리로 떠나는 모험",
      description: "음성만으로 즐기는 몰입형 RPG.\n당신의 선택이 이야기를 만들어갑니다.",
      image: 'assets/images/onboarding_3.png',
      color: const Color(0xFFFF44A1),
    ),
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // 배경 그라데이션
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _items[_currentPage].color.withOpacity(0.8),
                  const Color(0xFF0A0C24),
                ],
                stops: const [0.0, 0.6],
              ),
            ),
          ),
          
          // 페이지 뷰
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              AudioManager().playSFX('swipe');
            },
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 이미지 플레이스홀더 (실제 앱에서는 이미지 에셋 사용)
                  SizedBox(
                    height: size.height * 0.4,
                    child: Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _items[index].color.withOpacity(0.2),
                          border: Border.all(
                            color: _items[index].color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          index == 0 ? Icons.phone_in_talk :
                          index == 1 ? Icons.theater_comedy : Icons.sports_esports,
                          size: 100,
                          color: _items[index].color,
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
              opacity: _currentPage == _items.length - 1 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () {
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
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6E44FF),
                        const Color(0xFFFF44A1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6E44FF).withOpacity(0.4),
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
              onPressed: () {
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
              },
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

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color color;
  
  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<ExperienceCard> _experienceCards = [
    ExperienceCard(
      title: "AI 전화",
      description: "현실같은 AI와의 자연스러운 대화",
      icon: Icons.phone_in_talk,
      color: const Color(0xFF6E44FF),
      highlightColor: const Color(0xFF9E80FF),
      gradient: const LinearGradient(
        colors: [Color(0xFF6E44FF), Color(0xFF9C6FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "음성 롤플레이",
      description: "중세 기사단 면접, 마법학교 입학시험 등",
      icon: Icons.theater_comedy,
      color: const Color(0xFF00E1FF),
      highlightColor: const Color(0xFF5EEDFF),
      gradient: const LinearGradient(
        colors: [Color(0xFF00A3FF), Color(0xFF00E1FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "AI 라디오",
      description: "당신만을 위한 맞춤형 라디오 쇼",
      icon: Icons.radio,
      color: const Color(0xFFFF6B9E),
      highlightColor: const Color(0xFFFF8EB5),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF4486), Color(0xFFFF6B9E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "음성 RPG",
      description: "목소리로 즐기는 몰입형 어드벤처",
      icon: Icons.sports_esports,
      color: const Color(0xFFFFB443),
      highlightColor: const Color(0xFFFFCF85),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF9620), Color(0xFFFFB443)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ExperienceCard(
      title: "연애 시뮬레이션",
      description: "감성적인 대화로 발전하는 관계",
      icon: Icons.favorite,
      color: const Color(0xFFFF44A1),
      highlightColor: const Color(0xFFFF7BBA),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF44A1), Color(0xFFFF7BBA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];
  
  bool _isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    // 홈 화면 로딩 효과
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
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
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // 애니메이션 배경
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.cos(_animationController.value * 2 * math.pi) * 0.2,
                      math.sin(_animationController.value * 2 * math.pi) * 0.2,
                    ),
                    end: Alignment(
                      math.cos(_animationController.value * 2 * math.pi + math.pi) * 0.2,
                      math.sin(_animationController.value * 2 * math.pi + math.pi) * 0.2,
                    ),
                    colors: const [
                      Color(0xFF0A0C24),
                      Color(0xFF1A1154),
                      Color(0xFF0A0C24),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // 움직이는 그라데이션 원 (추가 시각 효과)
          Positioned(
            top: -size.width * 0.5,
            right: -size.width * 0.5,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: size.width,
                  height: size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6E44FF).withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 메인 내용
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 앱바
                AnimatedOpacity(
                  opacity: _isLoaded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 프로필 아바타
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6E44FF), Color(0xFFFF44A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 텍스트 내용
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "안녕하세요!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "오늘은 어떤 음성 경험을 원하세요?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 설정 버튼
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Center(
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 메인 타이틀
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuint,
                  transform: Matrix4.translationValues(
                    0, 
                    _isLoaded ? 0 : 50, 
                    0,
                  ),
                  child: AnimatedOpacity(
                    opacity: _isLoaded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
                      child: Text(
                        "나만의 음성 경험",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontFamily: 'GmarketSans',
                        ),
                      ),
                    ),
                  ),
                ),
                
                // 경험 카드 리스트
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _experienceCards.length,
                    itemBuilder: (context, index) {
                      // 각 카드에 애니메이션 효과 적용
                      // delay 대신 staggered 효과를 직접 구현
                      Widget cardWidget = GestureDetector(
                        onTap: () {
                          AudioManager().playSFX('card_tap');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ExperienceDetailScreen(
                                    card: _experienceCards[index],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 120,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: _experienceCards[index].gradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: _experienceCards[index].color.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
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
                                      color: _experienceCards[index].highlightColor.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                
                                // 장식 아이콘
                                Positioned(
                                  right: -15,
                                  bottom: -15,
                                  child: Icon(
                                    _experienceCards[index].icon,
                                    size: 100,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                
                                // 카드 내용
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _experienceCards[index].icon,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _experienceCards[index].title,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _experienceCards[index].description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white.withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      
                      // Flutter Animate 패키지를 사용하여 순차적 애니메이션 구현
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutQuint,
                        transform: Matrix4.translationValues(
                          0, 
                          _isLoaded ? 0 : 100 + (index * 20), 
                          0,
                        ),
                        child: AnimatedOpacity(
                          opacity: _isLoaded ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: cardWidget,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 100 + (index * 100)),
                      );
                    },
                  ),
                ),
                
                // 하단 마이크 버튼
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  transform: Matrix4.translationValues(
                    0, 
                    _isLoaded ? 0 : 100, 
                    0,
                  ),
                  child: AnimatedOpacity(
                    opacity: _isLoaded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GestureDetector(
                        onTap: () {
                          AudioManager().playSFX('button');
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => const VoiceCommandSheet(),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6E44FF), Color(0xFFFF44A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6E44FF).withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceCard {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color highlightColor;
  final Gradient gradient;
  
  ExperienceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.highlightColor,
    required this.gradient,
  });
}

// 음성 경험 상세 화면
class ExperienceDetailScreen extends StatefulWidget {
  final ExperienceCard card;
  
  const ExperienceDetailScreen({Key? key, required this.card}) : super(key: key);
  
  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  bool _isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            AudioManager().playSFX('back');
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: Text(
          widget.card.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 배경 그라데이션
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.card.color,
                  const Color(0xFF0A0C24),
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          
          // 움직이는 원형 효과
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Positioned(
                top: 100,
                left: -size.width * 0.3,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.card.highlightColor.withOpacity(0.5),
                        widget.card.highlightColor.withOpacity(0),
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 메인 콘텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // 상단 공간 (앱바 아래)
                  const SizedBox(height: 40),
                  
                  // 큰 아이콘 표시
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 50, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.card.color,
                              widget.card.highlightColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: widget.card.color.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.card.icon,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 제목
                  // 순차 애니메이션을 위해 Flutter Animate 사용
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuint,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 50, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        "지금 바로 ${widget.card.title} 시작하기",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                  
                  const SizedBox(height: 20),
                  
                  // 설명
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuint,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 50, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        widget.card.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 100),
                  ),
                  
                  const Spacer(),
                  
                  // 시작하기 버튼
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    transform: Matrix4.translationValues(
                      0, 
                      _isLoaded ? 0 : 100, 
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            AudioManager().playSFX('start');
                            // 실제 경험 시작 화면으로 이동
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "시작하기",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.card.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 보이스 커맨드 시트
class VoiceCommandSheet extends StatefulWidget {
  const VoiceCommandSheet({Key? key}) : super(key: key);

  @override
  State<VoiceCommandSheet> createState() => _VoiceCommandSheetState();
}

class _VoiceCommandSheetState extends State<VoiceCommandSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _audioLevels = List.generate(30, (_) => 0.1);
  
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
            _audioLevels[i] = math.Random().nextDouble() * 0.8 + 0.2;
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
            Color(0xFF0A0C24),
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
                          const Color(0xFF6E44FF),
                          Color.lerp(
                            const Color(0xFF6E44FF),
                            const Color(0xFFFF44A1),
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
                    color: const Color(0xFF6E44FF),
                  ),
                  const SizedBox(height: 15),
                  _buildSuggestionCard(
                    title: "음성 롤플레이 시작",
                    description: "다양한 캐릭터와 대화해보세요",
                    icon: Icons.theater_comedy,
                    color: const Color(0xFF00E1FF),
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