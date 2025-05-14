import 'package:flutter/material.dart';

class StoriesTabScreen extends StatelessWidget {
  const StoriesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '연애 시뮬레이션 모드 화면 (스토리 목록 표시 예정)',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}