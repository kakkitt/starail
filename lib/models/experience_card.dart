import 'package:flutter/material.dart';

class ExperienceCard {
  final String title;
  final String description;
  
  final IconData icon;
  final Color color;
  final Color highlightColor;
  final Gradient gradient;
  final String animationAsset;
  
  ExperienceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.highlightColor,
    required this.gradient,
    required this.animationAsset,
  });
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

class Star {
  final double x;
  final double y;
  final double size;
  final double brightness;
  final double speed;
  double offset;
  
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.brightness,
    required this.speed,
    this.offset = 0.0,
  });
  
  void update() {
    offset += speed;
    if (offset > 1.0) {
      offset = 0.0;
    }
  }
}