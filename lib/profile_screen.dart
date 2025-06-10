import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data - replace with your actual data
    final String userName = "Alex Johnson";
    final String userEmail = "alex.johnson@example.com";
    final String joinDate = "Member since June 2023";
    final String userBio = "Fitness enthusiast building healthy habits one day at a time!";
    final String photoUrl = "https://randomuser.me/api/portraits/men/1.jpg";

    final List<Map<String, dynamic>> achievements = [
      {"title": "7-Day Streak", "icon": Icons.local_fire_department, "color": Colors.orange},
      {"title": "Early Riser", "icon": Icons.wb_sunny, "color": Colors.yellow},
      {"title": "Book Worm", "icon": Icons.menu_book, "color": Colors.blue},
      {"title": "Hydration Hero", "icon": Icons.water_drop, "color": Colors.lightBlue},
    ];

    final List<Map<String, dynamic>> ongoingHabits = [
      {"name": "Morning Run", "emoji": "🏃‍♂️", "streak": 12, "progress": 0.75},
      {"name": "Read 30 mins", "emoji": "📚", "streak": 8, "progress": 0.6},
      {"name": "Drink Water", "emoji": "💧", "streak": 15, "progress": 0.9},
      {"name": "Meditation", "emoji": "🧘‍♀️", "streak": 5, "progress": 0.4},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFFECC7CE),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(photoUrl),
                    child: photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    joinDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5DA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userBio,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievements Section
            const Text(
              "My Achievements",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: achievements[index]["color"].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          achievements[index]["icon"],
                          size: 30,
                          color: achievements[index]["color"],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          achievements[index]["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Ongoing Habits Section
            const Text(
              "Ongoing Habits",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ongoingHabits.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Text(
                          ongoingHabits[index]["emoji"],
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ongoingHabits[index]["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${ongoingHabits[index]["streak"]} day streak",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: ongoingHabits[index]["progress"],
                                backgroundColor: Colors.grey[200],
                                color: const Color(0xFFECC7CE),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}