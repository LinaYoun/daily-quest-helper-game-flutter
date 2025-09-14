import 'package:flutter/material.dart';
import 'constants.dart';
import 'widgets.dart';
import 'models.dart';
import 'services/database_service.dart';
import 'badge_painters.dart';

class WeeklyHomeScreen extends StatefulWidget {
  const WeeklyHomeScreen({super.key});
  @override
  State<WeeklyHomeScreen> createState() => _WeeklyHomeScreenState();
}

class _WeeklyHomeScreenState extends State<WeeklyHomeScreen> {
  final DatabaseService _db = DatabaseService();
  final ValueNotifier<List<Quest>> _quests = ValueNotifier<List<Quest>>(
    <Quest>[],
  );
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<RewardInfo?> _activeReward = ValueNotifier<RewardInfo?>(
    null,
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _db.resetWeeklyIfNeeded();
    final items = await _db.getAllWeeklyQuests();
    _quests.value = items;
    _isLoading.value = false;
  }

  void _handleClaimReward() async {
    final (int itemId, String key) = await DatabaseService()
        .addRandomOwnedItem();
    _activeReward.value = null;
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Stack(
        children: <Widget>[
          ItemAwardDialog(
            itemId: itemId,
            itemKey: key,
            onClose: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop('refresh');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openRegister() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const WeeklyRegisterScreen()),
    );
    if (!mounted || result == null) return;
    final String? title = result['title'] as String?;
    final int? target = result['target'] as int?;
    if (title == null || target == null) return;

    final List<Quest> before = await _db.getAllWeeklyQuests();
    final int nextId =
        (before.map((q) => q.id).fold<int>(0, (a, b) => a > b ? a : b)) + 1;
    final Quest newQuest = Quest(
      id: nextId,
      title: title,
      progress: 0,
      target: target,
      status: QuestStatus.incomplete,
      iconUrl: 'builtin:weekly-calendar',
      rewardUrl: null,
    );
    await _db.insertWeeklyQuest(newQuest);
    _quests.value = await _db.getAllWeeklyQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: PatternBackground()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.88,
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
                                64,
                                16,
                                80,
                              ),
                              child: ValueListenableBuilder<List<Quest>>(
                                valueListenable: _quests,
                                builder: (context, quests, _) => QuestGridView(
                                  quests: quests,
                                  emptyMessage: '주간 임무를 등록하세요',
                                  onComplete: (id) async {
                                    final List<Quest> current = await _db
                                        .getAllWeeklyQuests();
                                    final Quest q = current.firstWhere(
                                      (e) => e.id == id,
                                    );
                                    if (q.status == QuestStatus.completed)
                                      return;

                                    final int newProgress = (q.progress + 1)
                                        .clamp(0, q.target);

                                    if (newProgress >= q.target) {
                                      _activeReward.value = RewardInfo(
                                        questName: q.title,
                                        imageUrl: q.rewardUrl ?? '',
                                      );
                                      // persist completion first
                                      final completed = q.copyWith(
                                        progress: newProgress,
                                        status: QuestStatus.completed,
                                      );
                                      await _db.updateWeeklyQuest(completed);
                                      final String? wbadge =
                                          await DatabaseService()
                                              .awardBadgeWeekly3IfNeeded();
                                      if (wbadge != null && mounted) {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierColor: Colors.black
                                              .withOpacity(0.35),
                                          builder: (_) => Stack(
                                            children: <Widget>[
                                              BadgeAwardDialog(
                                                title: '새로운 배지 획득! (weekly3)',
                                                child: CustomPaint(
                                                  painter:
                                                      Weekly3BadgePainter(),
                                                ),
                                                onClose: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      final updated = q.copyWith(
                                        progress: newProgress,
                                      );
                                      await _db.updateWeeklyQuest(updated);
                                    }
                                    _quests.value = await _db
                                        .getAllWeeklyQuests();
                                  },
                                ),
                              ),
                            ),
                            const HeaderBar(title: '주간 임무', showTimer: false),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(top: 16, left: 16, child: CornerDecoration()),
            Positioned(
              bottom: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop('refresh'),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6EED6),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFBE9E6A),
                      width: 6,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.home, color: colorText, size: 34),
                      SizedBox(height: 2),
                      Text(
                        'HOME',
                        style: TextStyle(
                          color: colorText,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 12,
              right: 12,
              child: TopRightCharacterBadge(),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: colorAccent,
                foregroundColor: Colors.white,
                onPressed: _openRegister,
                child: const Icon(Icons.add),
              ),
            ),
            ValueListenableBuilder<RewardInfo?>(
              valueListenable: _activeReward,
              builder: (context, reward, __) => reward == null
                  ? const SizedBox.shrink()
                  : RewardDialog(reward: reward, onClaim: _handleClaimReward),
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyRegisterScreen extends StatelessWidget {
  const WeeklyRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: PatternBackground()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.fromLTRB(24, 74, 24, 24),
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            child: const _WeeklyForm(),
                          ),
                        ),
                        const HeaderBar(title: '주간 임무 등록', showTimer: false),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(top: 16, left: 16, child: CornerDecoration()),
            Positioned(
              bottom: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop('refresh'),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6EED6),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFBE9E6A),
                      width: 6,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.home, color: colorText, size: 34),
                      SizedBox(height: 2),
                      Text(
                        'HOME',
                        style: TextStyle(
                          color: colorText,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 12,
              right: 12,
              child: TopRightCharacterBadge(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyForm extends StatefulWidget {
  const _WeeklyForm();
  @override
  State<_WeeklyForm> createState() => _WeeklyFormState();
}

class _WeeklyFormState extends State<_WeeklyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _target = TextEditingController(text: '1');

  @override
  void dispose() {
    _title.dispose();
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: const <Widget>[
              Icon(Icons.edit, color: colorText),
              SizedBox(width: 8),
              Text(
                '새 주간 임무 정보를 입력하세요',
                style: TextStyle(
                  color: colorText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PaperField(
            label: '제목',
            child: TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '예: 일주일 동안 3회 운동',
              ),
              style: const TextStyle(
                color: colorText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '제목을 입력하세요' : null,
            ),
          ),
          const SizedBox(height: 12),
          _PaperField(
            label: '목표 수치',
            child: TextFormField(
              controller: _target,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '예: 3',
              ),
              style: const TextStyle(
                color: colorText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              validator: (v) =>
                  (int.tryParse(v ?? '') == null) ? '숫자를 입력하세요' : null,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 6,
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final String title = _title.text.trim();
                  final int target = int.parse(_target.text.trim());
                  Navigator.of(
                    context,
                  ).pop(<String, dynamic>{'title': title, 'target': target});
                }
              },
              child: const Text(
                '등록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperField extends StatelessWidget {
  const _PaperField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: colorText, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        CustomPaint(
          painter: const DashedRRectPainter(
            strokeColor: kCardStroke,
            fillColor: kCardFill,
            radius: 18,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: child,
          ),
        ),
      ],
    );
  }
}
