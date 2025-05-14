import 'package:flutter/material.dart';
// 'lumina'를 프로젝트 이름('ai_voice_dev')으로 변경
import 'package:ai_voice_dev/screens/friends_tab_screen.dart';
import 'package:ai_voice_dev/screens/stories_tab_screen.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FriendsTabScreen(),
    StoriesTabScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitleForIndex(int index, BuildContext context) {
    final theme = Theme.of(context);
    // AppBar 타이틀은 NovaRound를 사용하고 있으므로, 해당 스타일을 직접 적용하거나 테마에서 가져옵니다.
    // 여기서는 간단히 텍스트만 반환하고, AppBar에서 스타일을 적용합니다.
    switch (index) {
      case 0:
        return 'LUMINA'; // 또는 '친구와 대화하기'
      case 1:
        return '나만의 연애'; // 또는 '두근거리는 이야기'
      default:
        return 'LUMINA';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitleForIndex(_selectedIndex, context),
          // 테마의 AppBartitleTextStyle를 직접 사용하거나, 여기서 커스텀
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            tooltip: isDarkMode ? '라이트 모드로 변경' : '다크 모드로 변경',
            onPressed: () {
              // TODO: 테마 변경 로직 구현 (Provider, Riverpod 등 사용)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '테마 변경 기능 (${isDarkMode ? "라이트" : "다크"} 모드)은 추후 구현됩니다.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: '설정',
            onPressed: () {
              // TODO: 설정 화면으로 이동
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('설정 화면은 추후 구현됩니다.')),
              );
            },
          ),
        ],
        // backgroundColor: theme.appBarTheme.backgroundColor, // 이미 테마에서 설정됨
        // elevation: 0, // 이미 테마에서 설정됨
      ),
      body: IndexedStack( // 화면 전환 시 상태 유지를 위해 IndexedStack 사용
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined), // 아이콘 변경 제안
            activeIcon: Icon(Icons.forum),
            label: '친구',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), // 아이콘 변경 제안
            activeIcon: Icon(Icons.favorite),
            label: '연애',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // 스타일 대부분은 테마에서 설정됨
      ),
    );
  }
}