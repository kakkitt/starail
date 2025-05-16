// lib/screens/character_feed_screen.dart

import 'package:ai_voice_dev/models/character_model.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';
// import 'package:ai_voice_dev/screens/calling_screen.dart'; // 필요시 통화 화면 경로
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // For ImageFilter

// 캐릭터 피드에 표시될 이미지 아이템 모델 (임시)
// 이 클래스는 character_profile_screen.dart 에도 동일하게 정의되어 있으므로,
// lib/models/feed_item_model.dart 와 같이 별도의 파일로 분리하여 공용으로 사용하는 것이 좋습니다.
class FeedItem {
  final String id;
  final String imageAssetPath;
  final String? caption;
  final int? likeCount;
  final DateTime? timestamp;

  FeedItem({
    required this.id,
    required this.imageAssetPath,
    this.caption,
    this.likeCount,
    this.timestamp,
  });
}

// 클래스 이름을 CharacterFeedScreen 으로 변경
class CharacterFeedScreen extends StatefulWidget {
  final Character character;
  // isFriendMode는 이 화면에서는 직접적으로 사용되지 않을 수 있으나,
  // 추후 피드 아이템 클릭 시 동작을 다르게 하고 싶다면 활용 가능합니다.
  // final bool isFriendMode;

  const CharacterFeedScreen({
    super.key,
    required this.character,
    // this.isFriendMode = true,
  });

  @override
  State<CharacterFeedScreen> createState() =>
      _CharacterFeedScreenState();
}

class _CharacterFeedScreenState extends State<CharacterFeedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  // 임시 피드 데이터 (character_profile_screen.dart 와 동일한 구조)
  // 실제로는 widget.character.id 등을 이용해 해당 캐릭터의 피드 데이터를 가져와야 합니다.
  // C:\Users\PC\\Starail\ai_voice_dev\assets\images\nayeon\character1_feed_1.png
  final List<FeedItem> _feedItems = [
    FeedItem(id: 'feed1', imageAssetPath: 'assets/images/nayeon/character1_feed_1.png', caption: "오늘 날씨 최고! ☀️ #산책 #기분좋아", likeCount: 123, timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    FeedItem(id: 'feed2', imageAssetPath: 'assets/images/nayeon/character1_feed_2.png', caption: "새로 산 옷 어떤가요? 😉 #데일리룩 #OOTD", likeCount: 256, timestamp: DateTime.now().subtract(const Duration(hours: 5))),
    FeedItem(id: 'feed3', imageAssetPath: 'assets/images/nayeon/character1_feed_3.png', caption: "퇴근 후엔 역시 맛있는 거지! 🍕 #저녁메뉴 #행복", likeCount: 189, timestamp: DateTime.now().subtract(const Duration(days: 1))),
    FeedItem(id: 'feed4', imageAssetPath: 'assets/images/nayeon/character1_feed_4.png', caption: "주말엔 역시 집에서 뒹굴뒹굴 뒹구르르...", likeCount: 301, timestamp: DateTime.now().subtract(const Duration(days: 2))),
    FeedItem(id: 'feed5', imageAssetPath: 'assets/images/nayeon/character1_feed_5.png', caption: "오랜만에 만난 친구랑 수다 삼매경! ☕️", likeCount: 220, timestamp: DateTime.now().subtract(const Duration(days: 3))),
    FeedItem(id: 'feed6', imageAssetPath: 'assets/images/nayeon/character1_feed_6.png', caption: "새로운 취미 발견! #베이킹 #꿀잼", likeCount: 175, timestamp: DateTime.now().subtract(const Duration(days: 4))),
    FeedItem(id: 'feed7', imageAssetPath: 'assets/images/nayeon/character1_feed_7.png', caption: "밤하늘이 너무 예뻐서 한 컷 🌙", likeCount: 190, timestamp: DateTime.now().subtract(const Duration(days: 5))),
    FeedItem(id: 'feed8', imageAssetPath: 'assets/images/nayeon/character1_feed_8.png', caption: "오늘의 플레이리스트 🎶", likeCount: 155, timestamp: DateTime.now().subtract(const Duration(days: 6))),
    FeedItem(id: 'feed9', imageAssetPath: 'assets/images/nayeon/character1_feed_9.png', caption: "독서의 계절, 마음의 양식 쌓기 📚", likeCount: 130, timestamp: DateTime.now().subtract(const Duration(days: 7))),
  ];

  // 캐릭터 정보 (실제로는 widget.character에서 가져옴)
  // 이 화면에서는 헤더에 표시될 정보가 이전 프로필 화면과 다를 수 있습니다.
  // 여기서는 간단히 캐릭터 이름만 AppBar에 표시하는 것을 목표로 합니다.
  final int postCount = 28; // 예시
  final String engagementRate = "98%"; // 예시
  final String lastActive = "방금 전"; // 예시

  final ScrollController _scrollController = ScrollController();
  bool _showTitleInAppBar = false;

  @override
  void initState() {
    super.initState();
    // 이 화면에서는 별도의 헤더 애니메이션이 필요 없을 수 있으나,
    // AppBar 타이틀 표시 로직 등을 위해 컨트롤러는 유지할 수 있습니다.
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // 간결한 애니메이션
    );
    // 이 화면에서는 헤더가 고정된 AppBar 형태이므로, 복잡한 Fade/Slide는 불필요할 수 있습니다.
    // _headerFadeAnimation, _headerSlideAnimation은 필요시 커스텀 AppBar에 활용 가능.

    _scrollController.addListener(() {
      // AppBar에 캐릭터 이름을 표시할지 여부를 결정 (예: 특정 스크롤 지점)
      // 이 화면에서는 AppBar가 항상 고정되어 이름이 보이므로, 이 로직은 다르게 활용되거나 제거될 수 있습니다.
      if (_scrollController.hasClients && _scrollController.offset > 50 && !_showTitleInAppBar) { // 예시 임계값
        if(mounted) {
          setState(() {
            _showTitleInAppBar = true;
          });
        }
      } else if (_scrollController.hasClients && _scrollController.offset <= 50 && _showTitleInAppBar) {
         if(mounted) {
          setState(() {
            _showTitleInAppBar = false;
          });
        }
      }
    });
    // 초기 상태에서 AppBar 타이틀을 바로 보여주기 위함 (선택적)
    // _showTitleInAppBar = true;
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light.copyWith(statusBarColor: theme.appBarTheme.backgroundColor) 
                 : SystemUiOverlayStyle.dark.copyWith(statusBarColor: theme.appBarTheme.backgroundColor),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 이 화면은 CustomScrollView 대신 일반 AppBar와 GridView를 사용할 수 있습니다.
      // 또는 SliverAppBar를 사용하되, expandedHeight를 최소화하고 바로 Grid가 나오도록 합니다.
      appBar: AppBar(
        title: Text(
          "${widget.character.name}의 피드", // AppBar 타이틀
          style: theme.appBarTheme.titleTextStyle?.copyWith(fontFamily: AppTheme.pretendardFontFamily), // Pretendard 적용
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0.8, // 약간의 구분선
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // 피드 화면에서는 별도의 actions이 필요 없을 수 있음
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(3.0), // 그리드 전체 패딩
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
        ),
        itemCount: _feedItems.length,
        itemBuilder: (BuildContext context, int index) {
          final feedItem = _feedItems[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on feed item: ${feedItem.id}');
              // TODO: 이미지 상세 보기 또는 피드 아이템 상세 보기 화면으로 이동
              // 이때, 상세 보기 화면은 새로운 화면으로 만들거나 간단한 다이얼로그를 사용할 수 있습니다.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                          child: Image.asset(feedItem.imageAssetPath, fit: BoxFit.contain),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            feedItem.caption ?? "멋진 순간!",
                            style: theme.textTheme.bodyMedium?.copyWith(fontFamily: AppTheme.pretendardFontFamily),
                            textAlign: TextAlign.center,
                          ),
                        ),
                         TextButton(
                           child: Text("닫기", style: TextStyle(color: theme.colorScheme.primary, fontFamily: AppTheme.pretendardFontFamily)),
                           onPressed: () => Navigator.of(context).pop(),
                         ),
                         const SizedBox(height: 8),
                      ],
                    ),
                  );
                }
              );
            },
            child: Hero(
              tag: 'feed_image_${feedItem.id}_from_feed_screen', // Hero 태그는 고유해야 함
              child: Image.asset(
                feedItem.imageAssetPath,
                fit: BoxFit.cover,
                // 이미지 로딩 중 플레이스홀더 (선택 사항)
                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Container(color: Colors.grey[200], child: Icon(Icons.broken_image_outlined, color: Colors.grey[400]));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}