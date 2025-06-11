import 'package:flutter/material.dart';
import 'package:habit_builder/habit_model.dart';
import 'package:habit_builder/main_page.dart';
import 'UserHabits.dart';
import 'UserHabitsService.dart';
import 'habit_model.dart';
import 'package:scratcher/scratcher.dart';
import 'package:flutter/services.dart';
import 'package:habit_builder/UserService.dart';
import 'grid.dart';

class TaskPage extends StatefulWidget {
  final String userId;
  final int index;

  const TaskPage(this.userId, {super.key, required this.index});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  static const _bgBlue = Color(0xFFD4E7F5);
  static const _pillBlue = Color(0xFFB0D0E7);
  static const _mint = Color(0xFFE1F5DA);
  static const _pinkBtn = Color(0xFFECC7CE);
  static const _headerPink = Color(0xFFFFD1DC); // Light pink header

  String? task = "";
  double _scratch = 0;
  bool _isLoading = true;
  int? streak = 0;
  String? emoji = "";
  String? habitName = "";
  bool _taskRevealed = false;

  @override
  void initState() {
    super.initState();
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    final st = await getTask(widget.userId, widget.index);
    final em = await getEmoji(widget.userId, widget.index);
    final na = await GetHabitName(widget.userId, widget.index);
    setState(() {
      emoji = em;
      task = st;
      habitName = na;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlue,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            double wp(double pct) => w * pct;
            double hp(double pct) => h * pct;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: hp(.03)),
              child: Column(
                children: [
                  // ✅ Light Pink Header with Back Button and Title
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: wp(.04), vertical: hp(.016)),
                    decoration: BoxDecoration(
                      color: _headerPink,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomeScreen(widget.userId)),
                              );
                            },
                          ),
                        ),
                        const Center(
                          child: Text(
                            "TodayTask",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: wp(.06)),
                    child: Column(
                      children: [
                        SizedBox(height: hp(.05)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: wp(.07), vertical: hp(.015)),
                          decoration: BoxDecoration(
                            color: _pillBlue,
                            borderRadius: BorderRadius.circular(26),
                            border:
                                Border.all(color: Colors.black87, width: 1.2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                (habitName ?? 'Habit') + ' ' + (emoji ?? '😊'),
                                style: TextStyle(
                                  fontSize: wp(.05),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: hp(.05)),

                        if (_isLoading) ...[
                          const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Text(
                            task ?? 'Loading task...',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ] else if (task?.isEmpty ?? true) ...[
                          const Text('You have completed all tasks!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Scratcher(
                                brushSize: 45,
                                threshold: 50,
                                color: const Color.fromARGB(255, 229, 166, 187),
                                onChange: (v) =>
                                    setState(() => _scratch = v),
                                onThreshold: () {
                                  HapticFeedback.mediumImpact();
                                  setState(() {
                                    _taskRevealed = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Task revealed!')),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(50),
                                  decoration: BoxDecoration(
                                    color: _mint,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    task!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (_taskRevealed) ...[
                            ElevatedButton(
                              onPressed: () {
                                updateHabit(widget.userId, widget.index);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen(widget.userId)),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Task marked as done!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 229, 166, 187),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Task Done'),

                            ),
                            SizedBox(height: hp(.04)),
                          ]
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
