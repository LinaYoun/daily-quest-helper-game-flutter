import 'package:flutter/material.dart';
import 'models.dart';

// Color palette
const colorBackground = Color(0xFF6B5644);
const colorPaper = Color(0xFFF5F1E1);
const colorAccent = Color(0xFFC7A84A);
const colorText = Color(0xFF5A4632);

// UI spacing & radii (align closer to reference image)
const double kPaperRadius = 24;
const double kHeaderPillHeight = 44;
const double kQuestCardRadius = 24;
const double kQuestCardStroke = 2;
const double kQuestCardDash = 6;
const double kQuestCardGap = 4;
const double kQuestIconSize = 64;
const double kBadgeSize = 44;

// Colors used within cards (from reference tones)
const Color kCardFill = Color(0xFFF9F0D6);
const Color kCardStroke = Color(0xFFDEBE96);
const Color kChipFill = Color(0xFFEDE1BD);
const Color kChipFillAlt = Color(0xFFE6DCB5);

// Gameplay: Level & XP system
const int kBaseXpToLevel = 100; // XP required to reach level 2
const int kXpGrowthPerLevel = 25; // Additional XP needed per level
const int kXpPerQuestCompletion = 50; // XP awarded when completing a quest

// Placeholder asset URLs
const String kPlaceholderIcon = '';
const String kPlaceholderReward = '';

// Optional: reference image URL to guide icon style (can be overridden by REFERENCE_IMAGE_URL)
const String kReferenceImageUrl = '';

// Optional: reference image asset path bundled with the app
// Provide via --dart-define=REFERENCE_ASSET_PATH=assets/reference_icon_style.png or set here.
const String kReferenceAssetPath = 'assets/reference_icon_style.png';

// Initial quests, icon and reward urls will be attached at runtime
const List<Quest> initialQuests = <Quest>[
  Quest(
    id: 1,
    title: '설거지 (Dishes)',
    progress: 0,
    target: 35,
    status: QuestStatus.incomplete,
  ),
  Quest(
    id: 2,
    title: '영어 공부 (English Study)',
    progress: 0,
    target: 2,
    status: QuestStatus.incomplete,
  ),
  Quest(
    id: 3,
    title: '주문 완료 (Order Complete)',
    progress: 1,
    target: 1,
    status: QuestStatus.completed,
  ),
  Quest(
    id: 4,
    title: '문 수리 (Door Repair)',
    progress: 0,
    target: 4,
    status: QuestStatus.incomplete,
  ),
  Quest(
    id: 5,
    title: '물 주기 (Water Plants)',
    progress: 0,
    target: 5,
    status: QuestStatus.incomplete,
  ),
  Quest(
    id: 6,
    title: '독서(Read a Book)',
    progress: 0,
    target: 1,
    status: QuestStatus.incomplete,
  ),
];
