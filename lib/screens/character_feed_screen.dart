// lib/screens/character_feed_screen.dart

import 'package:ai_voice_dev/models/character_model.dart';
import 'package:ai_voice_dev/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 캐릭터 피드에 표시될 이미지 아이템 모델
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

class CharacterFeedScreen extends StatefulWidget {
  final Character character;

  const CharacterFeedScreen({
    super.key,
    required this.character,
  });

  @override
  State<CharacterFeedScreen> createState() => _CharacterFeedScreenState();
}

class _CharacterFeedScreenState extends State<CharacterFeedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  
  // 임시 피드 데이터
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

  final ScrollController _scrollController = ScrollController();
  bool _showTitleInAppBar = false;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scrollController.addListener(() {
      if (_scrollController.hasClients && _scrollController.offset > 50 && !_showTitleInAppBar) {
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
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 해시태그를 강조 표시하는 함수
  List<TextSpan> _buildCaption(String caption, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final RegExp hashtagRegExp = RegExp(r'#\w+');
    
    // 캡션에서 해시태그 찾기
    final matches = hashtagRegExp.allMatches(caption);
    int lastIndex = 0;
    
    for (final match in matches) {
      // 해시태그 이전 텍스트
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: caption.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }
      
      // 해시태그를 다른 스타일로 추가
      spans.add(TextSpan(
        text: caption.substring(match.start, match.end),
        style: baseStyle.copyWith(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ));
      
      lastIndex = match.end;
    }
    
    // 마지막 해시태그 이후 텍스트
    if (lastIndex < caption.length) {
      spans.add(TextSpan(
        text: caption.substring(lastIndex),
        style: baseStyle,
      ));
    }
    
    return spans;
  }

  // 시간 경과 표시 (예: "2시간 전", "3일 전")
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}년 전';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}개월 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
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
      appBar: AppBar(
        title: Text(
          "${widget.character.name}의 피드",
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontFamily: AppTheme.pretendardFontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(1.0), // 인스타그램 스타일의 작은 패딩
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
        ),
        itemCount: _feedItems.length,
        itemBuilder: (BuildContext context, int index) {
          final feedItem = _feedItems[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on feed item: ${feedItem.id}');
              _showFeedItemDetail(context, feedItem);
            },
            child: Image.asset(
              feedItem.imageAssetPath,
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                print('Error loading feed image: $exception');
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(Icons.broken_image, color: Colors.grey[400], size: 24),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showFeedItemDetail(BuildContext context, FeedItem feedItem) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: screenSize.height * 0.9,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // 헤더 (사용자 프로필)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // 프로필 이미지
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(widget.character.imageAssetPath),
                    ),
                    const SizedBox(width: 8),
                    
                    // 사용자 이름
                    Text(
                      widget.character.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: AppTheme.pretendardFontFamily,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // 더보기 아이콘
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ],
                ),
              ),
              
              // 이미지와 콘텐츠
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 피드 이미지
                      Image.asset(
                        feedItem.imageAssetPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      
                      // 액션 버튼 (좋아요, 댓글, 공유 등)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {},
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      
                      // 좋아요 수
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '좋아요 ${feedItem.likeCount}개',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTheme.pretendardFontFamily,
                          ),
                        ),
                      ),
                      
                      // 캡션
                      if (feedItem.caption != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${widget.character.name} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.bodyLarge?.color,
                                    fontFamily: AppTheme.pretendardFontFamily,
                                  ),
                                ),
                                ..._buildCaption(
                                  feedItem.caption!,
                                  TextStyle(
                                    color: theme.textTheme.bodyLarge?.color,
                                    fontFamily: AppTheme.pretendardFontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      // 날짜
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Text(
                          _getTimeAgo(feedItem.timestamp ?? DateTime.now()),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontFamily: AppTheme.pretendardFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}