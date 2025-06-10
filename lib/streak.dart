import 'package:flutter/material.dart';
import 'UserService.dart';   // your Isar DB helper
import 'user_model.dart';
import 'main_page.dart';
class Streak extends StatefulWidget {
  final String userId;
  Streak(this.userId, {Key? key}) : super(key: key);

  @override
  _StreakState createState() => _StreakState();
}

class _StreakState extends State<Streak> {
  int streak = 0;
  String babyName = "Brian";
  String username = "Sahaab";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final fetchedStreak   = await getStreaks(widget.userId);
    final fetchedUsername = await getUserName(widget.userId);
    final fetchedBabyName = await getBabyname(widget.userId);

    setState(() {
      streak   = fetchedStreak;
      username = fetchedUsername;
      babyName = fetchedBabyName;
      isLoading = false;
    });
  }

  void renameBaby() {
    showDialog(
      context: context,
      builder: (context) {
        String newName = babyName;
        return AlertDialog(
          title: const Text("Rename Baby"),
          content: TextField(
            onChanged: (value) => newName = value,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                await setBabyname(widget.userId, newName);
                setState(() => babyName = newName);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE2E9),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── BACK ARROW (added) ────────────────────────
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.black87),
                        onPressed: () =>  Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>HomeScreen(this.widget.userId)),
        ),
                        splashRadius: 22,
                      ),

                      SizedBox(height: screenHeight * 0.03),
                      CircleAvatar(
                        radius: screenWidth * 0.1,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person,
                            size: screenWidth * 0.12, color: Colors.white),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2F2FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Streak!',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 6),
                                Text('🔥',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05)),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Image.asset(
                              streak <= 1
                                  ? 'assets/sad_emoji.png'
                                  : 'assets/happy_emoji.png',
                              height: screenHeight * 0.15,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Baby $babyName',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.045)),
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      size: screenWidth * 0.04),
                                  onPressed: renameBaby,
                                  padding: const EdgeInsets.only(left: 2),
                                  constraints: const BoxConstraints(),
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text('$streak DAYS OLD!',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
