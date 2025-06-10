import 'package:flutter/material.dart';
import 'package:habit_builder/habit_model.dart';
import 'package:habit_builder/main_page.dart';
import 'UserHabits.dart';
import 'UserHabitsService.dart'; // Import your HomeScreen
import 'habit_model.dart'; // Make sure this has GetHabitNames()
import 'package:scratcher/scratcher.dart';
import 'package:flutter/services.dart';
import 'package:habit_builder/UserService.dart';

class TaskPage extends StatefulWidget {
  final String userId;
  final String habitName;
  final int index;

  const TaskPage(this.userId,
      {super.key, required this.habitName, required this.index});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  static const _bgBlue = Color(0xFFD4E7F5);
  static const _pillBlue = Color(0xFFB0D0E7);
  static const _mint = Color(0xFFE1F5DA);
  static const _pinkBtn = Color(0xFFECC7CE);

  String? task = "";
  double _scratch = 0;
  bool _isLoading = true;
  int? streak = 0;

  bool _taskRevealed = false; // ✅ New state variable

  @override
  void initState() {
    super.initState();

    fetchHabits();
  }


  Future<void> fetchHabits() async {
    final st = await getTask(widget.userId,widget.index);
    setState(() {
      task = st;
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
                  // Header (unchanged)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: wp(.04), vertical: hp(.016)),
                    decoration: BoxDecoration(
                      color: _mint,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => HomeScreen(widget.userId)),
                            );
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/logo.png',
                              height: hp(.045),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department,
                                color: Colors.red),
                            SizedBox(width: wp(.02)),
                            CircleAvatar(
                              radius: hp(.026),
                              backgroundColor: Colors.lightBlueAccent,
                              child: const Icon(Icons.person,
                                  color: Colors.white),
                            ),
                          ],
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
                              Text(widget.habitName,
                                  style: TextStyle(
                                      fontSize: hp(.024),
                                      fontWeight: FontWeight.w600)),
                              SizedBox(width: wp(.02)),
                              const Icon(Icons.edit, size: 20),
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
                          const Text('No task found.'),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
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
                                    _taskRevealed = true; // ✅ Reveal state
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Task revealed!')),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
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

                          // ✅ "Task Done" Button
                          if (_taskRevealed) ...[
                            ElevatedButton(
                              onPressed: () {
                                // Here you would typically call a function to mark the task as done
                                updateHabit(widget.userId,widget.index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Task marked as done!')),
                                );
                                // TODO: Add actual logic here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 229, 166, 187), // same as scratcher
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
