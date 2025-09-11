import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'widgets.dart';
import 'services/gemini_service.dart';
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'dart:typed_data';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Quest> _quests;
  bool _isLoading = true;
  String _loadingMessage = 'Waking up the hamster...';
  String? _characterUrl;
  CharacterState _characterState = CharacterState.idle;
  RewardInfo? _activeReward;
  late final GeminiService _gemini;
  late final String _referenceUrl;
  late final String _referenceAssetPath;
  Uint8List? _referenceBytes;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with secure storage/env
    _gemini = GeminiService(
      apiKey: const String.fromEnvironment('GEMINI_API_KEY', defaultValue: ''),
      functionUrl: const String.fromEnvironment(
        'ICON_FUNCTION_URL',
        defaultValue: '',
      ),
    );
    _referenceUrl = const String.fromEnvironment(
      'REFERENCE_IMAGE_URL',
      defaultValue: kReferenceImageUrl,
    );
    _referenceAssetPath = const String.fromEnvironment(
      'REFERENCE_ASSET_PATH',
      defaultValue: kReferenceAssetPath,
    );
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    setState(() => _loadingMessage = 'Preparing your daily quests...');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _characterUrl = null; // Add local asset if available
    // Try load reference bytes from bundled asset
    if (_referenceAssetPath.isNotEmpty) {
      try {
        final ByteData bd = await rootBundle.load(_referenceAssetPath);
        _referenceBytes = bd.buffer.asUint8List();
      } catch (_) {
        _referenceBytes = null;
      }
    }
    _quests = initialQuests
        .map(
          (q) => q.copyWith(
            iconUrl: kPlaceholderIcon,
            rewardUrl: kPlaceholderReward,
          ),
        )
        .toList();

    // Generate reward icon once via Cloud Function / Gemini
    final String rewardPrompt =
        'Golden gift box icon, flat, minimal, no background, 2D vector style.';
    final String? rewardUrl = await _gemini
        .generateIconImageDataUrlWithReference(
          rewardPrompt,
          referenceUrl: _referenceBytes == null && _referenceUrl.isNotEmpty
              ? _referenceUrl
              : null,
          referenceBytes: _referenceBytes,
          referenceMimeType: 'image/png',
        );
    if (rewardUrl != null && rewardUrl.isNotEmpty) {
      _quests = _quests.map((q) => q.copyWith(rewardUrl: rewardUrl)).toList();
      setState(() {});
    }

    // Generate quest icons using Nano Banana model
    final List<Quest> updated = <Quest>[];
    for (final Quest q in _quests) {
      final String prompt =
          'Minimal, flat, consistent icon for: ${q.title}. '
          'Single subject, simple 2D vector style, centered on a white rounded square background, no outer background beyond the white square, soft edges, no drop shadow.';
      final String? dataUrl = await _gemini
          .generateIconImageDataUrlWithReference(
            prompt,
            referenceUrl: _referenceBytes == null && _referenceUrl.isNotEmpty
                ? _referenceUrl
                : null,
            referenceBytes: _referenceBytes,
            referenceMimeType: 'image/png',
          );
      updated.add(q.copyWith(iconUrl: dataUrl ?? q.iconUrl));
      setState(
        () =>
            _quests = List<Quest>.from(updated)
              ..addAll(_quests.skip(updated.length)),
      );
    }
    setState(() => _isLoading = false);
  }

  void _handleCompleteQuest(int id) {
    setState(() {
      _quests = _quests.map((quest) {
        if (quest.id == id && quest.status == QuestStatus.incomplete) {
          final int newProgress = (quest.progress + 1).clamp(0, quest.target);
          if (newProgress >= quest.target) {
            _activeReward = RewardInfo(
              questName: quest.title,
              imageUrl: quest.rewardUrl ?? '',
            );
            _characterState = CharacterState.happy;
            Future<void>.delayed(const Duration(seconds: 2)).then((_) {
              if (mounted)
                setState(() => _characterState = CharacterState.idle);
            });
            return quest.copyWith(
              status: QuestStatus.completed,
              progress: quest.target,
            );
          }
          return quest.copyWith(progress: newProgress);
        }
        return quest;
      }).toList();
    });
  }

  void _handleClaimReward() => setState(() => _activeReward = null);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return LoadingScreen(message: _loadingMessage);

    // Render background asset + overlay interactive UI
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (_characterUrl != null)
                        SizedBox(
                          width: 256,
                          height: 256,
                          child: CharacterView(
                            imageUrl: _characterUrl!,
                            state: _characterState,
                          ),
                        ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorPaper.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  56,
                                  16,
                                  16,
                                ),
                                child: QuestGridView(
                                  quests: _quests,
                                  onComplete: _handleCompleteQuest,
                                ),
                              ),
                              const HeaderBar(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(top: 16, left: 16, child: CornerDecoration()),
            const Positioned(
              top: 12,
              right: 12,
              child: TopRightCharacterBadge(),
            ),
            if (_activeReward != null)
              RewardDialog(reward: _activeReward!, onClaim: _handleClaimReward),
          ],
        ),
      ),
    );
  }
}
