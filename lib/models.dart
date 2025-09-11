import 'package:flutter/material.dart';

// Domain models and enums

enum QuestStatus { incomplete, completed }

enum CharacterState { idle, happy, thinking }

@immutable
class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.progress,
    required this.target,
    required this.status,
    this.iconUrl,
    this.rewardUrl,
  });

  final int id;
  final String title;
  final int progress;
  final int target;
  final QuestStatus status;
  final String? iconUrl;
  final String? rewardUrl;

  bool get isCompleted => status == QuestStatus.completed;

  Quest copyWith({
    int? id,
    String? title,
    int? progress,
    int? target,
    QuestStatus? status,
    String? iconUrl,
    String? rewardUrl,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      status: status ?? this.status,
      iconUrl: iconUrl ?? this.iconUrl,
      rewardUrl: rewardUrl ?? this.rewardUrl,
    );
  }
}

@immutable
class RewardInfo {
  const RewardInfo({required this.questName, required this.imageUrl});
  final String questName;
  final String imageUrl;
}

