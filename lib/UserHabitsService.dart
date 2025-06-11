import 'package:isar/isar.dart';
import 'habit_model.dart';
import 'UserHabits.dart';
import 'user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'UserService.dart';
late Isar isar;

Future<void> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [UserHabitsSchema, UserSchema], // include all schemas here
    directory: dir.path,
  );
  
  // Clear habits on initialization // Add default habits if none exist
}



Future<bool> addHabit(String userId, String habitName, List<String> tasks, String? emoji) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();

  if (userHabits == null) {
    return false;
  }

  for (final habit in userHabits.habits) {
    if (habit.habitName == habitName) {
      return false;
    }
  }

  final newHabit = Habit(
    habitName: habitName,
    tasks: tasks,
    emoji: emoji ?? '😊',
  );

  userHabits.habits = List<Habit>.from(userHabits.habits);
  userHabits.habits.add(newHabit);

  await isar.writeTxn(() async {
    await isar.userHabits.put(userHabits);
  });

  return true;


  return true;
}

Future<String?> getTask(String userId, int index) async {
final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || index < 0 || index >= userHabits.habits.length) {
    return null;
  }

  final habit = userHabits.habits[index];
  return habit.getTask();
}


Future<List<String>> getHabitNames(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return [];
  }
  return userHabits.habits.map((habit) => habit.habitName).toList();
}

Future<List<String>> getEmojiList(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return [];
  }
  return userHabits.habits.map((habit) => habit.emoji).toList();
}

Future<int> getIndex(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return -1;
  }
  return userHabits.habits[habitIndex].index;
}

Future<void> updateHabit(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return;
  }

  final habit = userHabits.habits[habitIndex];
  habit.updateStreak();
  await isar.writeTxn(() async {
    await isar.userHabits.put(userHabits);
  });
}

Future<bool> isCompleted(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return false;
  }
  return userHabits.habits[habitIndex].isCompleted;
}

Future<String> getEmoji(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return '😊'; // Default emoji
  }
  return userHabits.habits[habitIndex].emoji;
}

Future<void> resetHabits(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return;
  }

  for (final habit in userHabits.habits) {
    habit.index = 0;
    habit.isCompleted = false;
    habit.lastCompleted = null;
  }

  await isar.writeTxn(() async {
    await isar.userHabits.put(userHabits);
  });
}

Future<List<Map<String,String>>> CompletedHabits(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return [];
  }
  for(int i=0;i<userHabits.habits.length;i++){
    print("habits ${userHabits.habits[i].habitName}");
    print("habits ${userHabits.habits[i].emoji}");
    print("habits ${userHabits.habits[i].isCompleted}");
    print("habits ${userHabits.habits[i].index}");
  }

  return userHabits.habits
      .where((habit) => habit.isCompleted)
      .map((habit) => {
            'habitName': habit.habitName,
            'emoji': habit.emoji,
          })
      .toList();
}


Future<List<Map<Map<String, dynamic>,String>>> getHabitsWithStreaksNotZero(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null) {
    return [];
  }
  return userHabits.habits
      .where((habit) => habit.index >0 && habit.isCompleted==false)
      .map((habit) => {
            { 'habitName': habit.habitName, 'streak': habit.index }: habit.emoji
          })
      .toList();
}

Future<int> no_of_tasks(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return 0;
  }
  return userHabits.habits[habitIndex].noOfTasks;
}

Future<String>GetHabitName(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return '';
  }
  return userHabits.habits[habitIndex].habitName;
}

Future<void> ResetHabit(String userId, int habitIndex) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();
  if (userHabits == null || habitIndex < 0 || habitIndex >= userHabits.habits.length) {
    return;
  }

  final habit = userHabits.habits[habitIndex];
  habit.index = 0;
  habit.isCompleted = false;
  habit.lastCompleted = null;

  await isar.writeTxn(() async {
    await isar.userHabits.put(userHabits);
  });
}


Future<void> addDefaultHabits(String userId) async {
  final userHabits = await isar.userHabits.where().filter().userIdEqualTo(userId).findFirst();

  if (userHabits != null && userHabits.habits.isNotEmpty) {
    return; // Default habits already exist
  }

  final defaultHabits = [
    Habit(
      habitName: 'Reading',
      emoji: '📖',
      tasks: [
        'Read for 5 minutes.',
        'Choose a book you want to finish.',
        'Read 1 chapter or 10 pages.',
        'Highlight one quote or insight.',
        'Read for 10 minutes.',
        'Summarize what you read in 2-3 lines.',
        'Read a different genre or article.',
        'Read for 15 minutes without distraction.',
        'Share a quote you liked with someone.',
        'Try reading first thing in the morning.',
        'Read a chapter before bed.',
        'Reflect: Is your book still engaging?',
        'Explore a related article or blog post.',
        'Read for 20 minutes.',
        'Pick a new reading spot today.',
        'Write down 3 takeaways from today’s reading.',
        'Read a short story.',
        'Read and explain it to a friend or journal.',
        'Pick 3 vocabulary words and learn them.',
        'Read during lunch or break time.',
        'Try reading something difficult or new.',
        'Read aloud for 5 minutes.',
        'Finish a chapter you’ve been stuck on.',
        'Reflect on the main theme so far.',
        'Try reading in silence with no devices around.',
        'Read while sipping tea/coffee — make it cozy.',
        'Finish your book or reach 80%.',
        'Write a short review or summary.',
        'Plan your next book.',
        'Finish a complete book.',
      ],
    ),
    Habit(
      habitName: 'Sketching',
      emoji: '🎨',
      tasks: [
        'Draw a simple shape or object (apple, cube).',
        'Doodle for 5 minutes without stopping.',
        'Draw your hand or foot.',
        'Copy a simple cartoon character.',
        'Sketch your favorite item in your room.',
        'Watch a 5-min drawing tutorial.',
        'Draw something from memory.',
        'Sketch using only one line.',
        'Shade a simple object.',
        'Sketch your breakfast.',
        'Try blind contour drawing (no looking at paper).',
        'Draw something in nature.',
        'Re-draw your day as 3-panel comic.',
        'Practice drawing eyes or facial features.',
        'Draw using a reference photo.',
        'Sketch a scene from a book or movie.',
        'Use color for the first time (markers, pencils).',
        'Draw with your non-dominant hand.',
        'Try a 10-minute timed drawing.',
        'Copy a piece of art you admire.',
        'Draw an imaginary creature.',
        'Sketch outdoors (or through a window).',
        'Pick 3 objects and draw a still life.',
        'Practice shading and depth.',
        'Revisit an earlier drawing and improve it.',
        'Try drawing emotions or moods.',
        'Make a mini sketchbook (folded paper).',
        'Fill a page with random shapes or designs.',
        'Post or share your best drawing.',
        'Draw fanart of a favourite fandom.',
      ],
    ),
    Habit(
      habitName: 'Journaling',
      emoji: '📝',
      tasks: [
        "Write 3 things you're grateful for.",
        'Describe your day in 5 sentences.',
        'Write about someone you admire.',
        'Reflect on a recent challenge.',
        'Free-write for 5 minutes.',
        'What made you smile today?',
        'Describe your dream life.',
        'Write a letter to your future self.',
        'Journal a recent decision and its impact.',
        'What’s your biggest current goal?',
        'Record a vivid memory from childhood.',
        'Reflect on a fear you’ve overcome.',
        'What does success mean to you?',
        'List your values and why they matter.',
        'Describe your ideal weekend.',
        'Write about something you\'re learning.',
        'What’s one change you want to make?',
        'Reflect on a quote that resonates with you.',
        'Describe your mood without using the word “happy” or “sad.”',
        'Write a mini-story from your day.',
        'Jot down 5 things you love about yourself.',
        'If today were your last day, what would you do?',
        'Reflect on your personal growth this month.',
        'Describe your workspace or favorite place.',
        'What drains your energy? What restores it?',
        'Plan your next week or goal in detail.',
        'Write a poem or haiku.',
        'Reflect on your relationships.',
        'Describe your personal philosophy or belief.',
        'Final reflection: what changed in 30 days?',
      ],
    ),
    Habit(
      habitName: 'Exercise',
      emoji: '🏋️',
      tasks: [
        'Do 5 minutes of stretching.',
        'Walk for 10 minutes.',
        'Try 10 jumping jacks and 5 squats.',
        'Follow a 5-minute YouTube workout.',
        'Take stairs instead of the elevator.',
        'Try yoga or mobility drills.',
        'Do a short walk post meals.',
        'Try a beginner core workout.',
        'Dance to 1 full song.',
        'Walk 5,000 steps today.',
        'Do a balance exercise (stand on one leg).',
        'Stretch your neck, shoulders, and back.',
        'Try a 10-minute home workout.',
        'Try a new movement (kick, crawl, skip).',
        'Do wall sits or planks for 30 seconds.',
        'Take a mindful walk – no phone.',
        'Practice deep breathing + light movement.',
        'Repeat your favorite day’s workout.',
        'Do light cardio for 10-15 minutes.',
        'Try a quick HIIT circuit.',
        'Walk a different route than usual.',
        'Go outside and move (park, stairs, etc.).',
        'Stretch full body before bed.',
        'Do push-ups (wall, knee, or standard).',
        'Try a 10-minute flexibility video.',
        'Practice posture & alignment.',
        'Dance/move freely for 5 minutes.',
        'Mix 2 types of movement (walk + stretch).',
        'Reflect on what movement felt best.',
        'Design your own 10–15 minute workout using the moves you\'ve learned. Do it and note how it feels.',
      ],

    ),
    Habit(
      habitName: 'Meditation',
      emoji: '🧘',
      tasks: [
        'Sit quietly for 5 minutes.',
        'Focus on your breath for 5 minutes.',
        'Try a guided meditation app.',
        'Practice mindfulness while eating.',
        'Do a body scan meditation.',
        'Reflect on your thoughts for 5 minutes.',
        'Try loving-kindness meditation.',
        'Meditate while walking slowly.',
        'Focus on sounds around you for 5 minutes.',
        'Practice gratitude meditation.',
        'Visualize a peaceful place for 5 minutes.',
        'Try a mantra meditation (repeat a word).',
        'Reflect on your day with mindfulness.',
        'Practice mindful breathing for 10 minutes.',
        'Meditate with eyes closed and focus on sensations.',
        'Try a 10-minute guided meditation video.',
        'Reflect on your emotions without judgment.',
        'Practice mindful listening to music or nature sounds.',
        'Do a short meditation before bed.',
        'Reflect on your meditation experience today.',
      ],
    ),
    Habit(emoji: '🛠️', habitName: 'Generic Skills',
      tasks: [
        'Learn a new word and use it in a sentence.',
        'Watch a 5-minute tutorial on a new skill.',
        'Practice a skill you want to improve.',
        'Read an article on a topic of interest.',
        'Try a new recipe or cooking technique.',
        'Learn about a historical event or figure.',
        'Practice a new language for 10 minutes.',
        'Write down 3 things you learned today.',
        'Explore a new hobby or interest online.',
        'Reflect on your learning process today.',
        'Watch a TED talk on a topic you like.',
        'Try a new exercise or fitness routine.',
        'Read a chapter from a book on personal development.',
        'Practice a creative skill (drawing, writing, etc.).',
        'Learn about a different culture or tradition.',
        'Try a new app or tool that interests you.',
        'Reflect on a skill you want to master.',
        'Watch a documentary on a topic you find intriguing.',
        'Practice a skill for 15 minutes without distractions.',
        'Write down your goals for skill-building.',
        'Explore a new area of knowledge (science, art, etc.).',
        'Try a new form of exercise (yoga, dance, etc.).',
      ],
    ),

    Habit(
      habitName: 'Organization',
      emoji: '📅',
      tasks: [
        'Organize your workspace for 10 minutes.',
        'Declutter one small area (desk, drawer).',
        'Create a to-do list for the day.',
        'Sort through old emails or files.',
        'Plan your week ahead in a planner.',
        'Organize your digital files (photos, documents).',
        'Set up reminders for important tasks.',
        'Clean out your fridge or pantry.',
        'Organize your closet (donate unused items).',
        'Create a system for tracking tasks.',
        'Spend 10 minutes tidying up a room.',
        'Plan meals for the week ahead.',
        'Organize your books or media collection.',
        'Create a budget or financial plan.',
        'Set up a calendar for upcoming events.',
        'Organize your notes or study materials.',
        'Spend 5 minutes decluttering your mind (write down thoughts).',
        'Create a filing system for important documents.',
        'Reflect on what organization means to you.',
        'Spend 10 minutes organizing your digital workspace.',
        'Create a vision board for your goals.',
        'Spend 10 minutes organizing your email inbox.',
      ],
    ),

    Habit(emoji: '📵', habitName: "Digital Detox",
      tasks: [
        'Spend 1 hour without screens (phone, computer, TV).',
        'Unsubscribe from unnecessary emails.',
        'Delete unused apps from your phone.',
        'Spend 30 minutes reading a physical book.',
        'Reflect on your screen time habits.',
        'Try a day without social media.',
        'Spend time outdoors without your phone.',
        'Organize your digital photos (delete duplicates).',
        'Practice mindful technology use for 10 minutes.',
        'Reflect on how technology affects your life.',
        'Spend 15 minutes journaling without distractions.',
        'Create a plan for reducing screen time.',
        'Try a new hobby that doesn’t involve screens.',
        'Spend 30 minutes meditating or practicing mindfulness.',
        'Reflect on how you feel after a digital detox day.',
        'Spend 10 minutes organizing your digital files.',
        'Practice gratitude for offline experiences.',
        'Spend time with friends or family without screens.',
      ],
    ),
    Habit(emoji: '💻', habitName: "Coding",
      tasks: [
        'Spend 30 minutes on a coding tutorial.',
        'Build a small project using a new programming language.',
        'Contribute to an open-source project on GitHub.',
        'Practice coding problems on LeetCode or HackerRank.',
        'Read a chapter from a book on software development.',
        'Watch a tech talk or webinar on a relevant topic.',
        'Join a coding community or forum to discuss ideas.',
        'Pair program with a friend or colleague.',
        'Reflect on your coding journey and set goals.',
        'Spend time debugging a challenging issue.',
        'Learn about a new framework or library.',
        'Create a personal website or portfolio.',
        'Explore a new coding language or paradigm.',
        'Attend a local coding meetup or online event.',
        'Spend 30 minutes coding without distractions.',
        'Write a blog post about a coding topic you enjoy.',
        'Create a simple game or interactive project.',
      ],
    ),

    Habit(emoji: '🎸', habitName: "Guitar Playing",
      tasks: [
        'Practice basic chords for 10 minutes.',
        'Learn a new song or riff.',
        'Spend 5 minutes tuning your guitar.',
        'Practice finger exercises or scales.',
        'Watch a guitar tutorial on YouTube.',
        'Play along with a backing track.',
        'Experiment with different strumming patterns.',
        'Record yourself playing and listen back.',
        'Learn about music theory basics (notes, scales).',
        'Practice transitioning between chords smoothly.',
        'Spend 10 minutes improvising on the guitar.',
        'Explore different genres of music on the guitar.',
        'Join an online guitar community or forum.',
        'Reflect on your progress and set goals for improvement.',
        'Try playing a song by ear without looking at tabs.',
        'Spend time learning about guitar maintenance and care.',
        'Experiment with different guitar tones and effects.',
        'Practice playing with a metronome for timing.',
        'Learn a new technique (hammer-ons, pull-offs).'
      ],
    ),
    Habit(emoji: '🎹', habitName: "Piano Playing",
      tasks: [
        'Practice basic scales for 10 minutes.',
        'Learn a new song or piece on the piano.',
        'Spend 5 minutes warming up with finger exercises.',
        'Watch a piano tutorial on YouTube.',
        'Practice playing chords and inversions.',
        'Experiment with different dynamics (loud/soft).',
        'Record yourself playing and listen back.',
        'Learn about music theory basics (notes, intervals).',
        'Practice sight-reading a simple piece.',
        'Spend 10 minutes improvising on the piano.',
        'Explore different genres of music on the piano.',
        'Join an online piano community or forum.',
        'Reflect on your progress and set goals for improvement.',
        'Try playing a song by ear without looking at sheet music.',
        'Spend time learning about piano maintenance and care.',
        'Experiment with different piano sounds and effects.',
        'Practice playing with a metronome for timing.',
      ],
    ),

    Habit(emoji: '🧩', habitName: "Puzzle Solving",
      tasks: [
        'Solve a simple crossword puzzle.',
        'Complete a Sudoku puzzle.',
        'Try a jigsaw puzzle for 10 minutes.',
        'Play a logic puzzle game online.',
        'Reflect on your problem-solving approach.',
        'Solve a brain teaser or riddle.',
        'Work on a Rubik’s Cube or similar puzzle.',
        'Join an online puzzle-solving community.',
        'Spend time learning about different types of puzzles.',
        'Create your own puzzle for someone to solve.',
        'Practice solving puzzles under time constraints.',
        'Explore puzzle books or magazines.',
        'Reflect on how puzzles challenge your thinking.',
        'Try a new type of puzzle you haven’t done before.',
        'Spend 10 minutes brainstorming solutions to a problem.',
      ],
    ),

   Habit(emoji:"💄",habitName: "Makeup",
      tasks: [
        'Practice a simple makeup look for 10 minutes.',
        'Watch a makeup tutorial on YouTube.',
        'Experiment with different lipstick shades.',
        'Try a new eyeshadow technique.',
        'Reflect on your favorite makeup products.',
        'Practice blending techniques with foundation.',
        'Create a makeup look inspired by a celebrity.',
        'Spend time organizing your makeup collection.',
        'Learn about skincare basics before applying makeup.',
        'Experiment with different eyeliner styles.',
        'Try a bold or creative makeup look.',
        'Reflect on how makeup makes you feel confident.',
        'Join an online beauty community or forum.',
        'Practice applying false lashes or extensions.',
        'Spend 10 minutes practicing contouring techniques.',
      ],
    ),    
    Habit(emoji: "🧵", habitName: "Sewing",
      tasks: [
        'Practice basic stitches for 10 minutes.',
        'Sew a simple patch or hem.',
        'Watch a sewing tutorial on YouTube.',
        'Experiment with different fabrics and textures.',
        'Reflect on your favorite sewing projects.',
        'Practice threading a needle and tying knots.',
        'Create a small fabric swatch book.',
        'Spend time organizing your sewing supplies.',
        'Learn about different types of stitches and their uses.',
        'Experiment with sewing patterns or templates.',
        'Try sewing a small accessory (pouch, headband).',
        'Reflect on how sewing helps you relax and focus.',
        'Join an online sewing community or forum.',
        'Practice sewing buttons or zippers.',
        'Spend 10 minutes practicing hand-sewing techniques.',
      ],
    ),
    Habit(emoji: "🎥", habitName: "Video Editing",
      tasks: [
        'Watch a video editing tutorial for beginners.',
        'Practice cutting and trimming clips in a video editor.',
        'Experiment with adding text overlays to a video.',
        'Try color correction on a short video clip.',
        'Reflect on your favorite video editing techniques.',
        'Create a simple montage using existing footage.',
        'Spend time organizing your video files and assets.',
        'Learn about different video formats and resolutions.',
        'Experiment with adding music or sound effects to a video.',
        'Try creating a short intro or outro for a video.',
        'Reflect on how video editing enhances storytelling.',
        'Join an online video editing community or forum.',
        'Practice using transitions between clips in a video.',
        'Spend 10 minutes experimenting with special effects.',
      ],
    ),

    Habit(emoji:"🎮",habitName: "Gaming",
      tasks: [
        'Play a new game for 30 minutes.',
        'Try a different genre of game (puzzle, strategy).',
        'Reflect on your favorite gaming experiences.',
        'Join an online gaming community or forum.',
        'Watch a gaming tutorial or walkthrough.',
        'Experiment with different game settings or modes.',
        'Practice a specific skill in a game (aiming, strategy).',
        'Spend time organizing your gaming setup.',
        'Learn about game development basics.',
        'Try playing a game with friends or family.',
        'Reflect on how gaming helps you relax and unwind.',
        'Create a list of games you want to play next.',
        'Spend 10 minutes practicing a specific game mechanic.',
        'Explore a new game you haven’t played before.',
        'Reflect on how gaming challenges your problem-solving skills.',
      ],
    ),

    Habit(emoji: "👩🏻‍🍳",habitName: "cooking",
      tasks: [
        'Try a new recipe for dinner.',
        'Experiment with a new cooking technique.',
        'Reflect on your favorite dishes to cook.',
        'Watch a cooking tutorial on YouTube.',
        'Practice knife skills with vegetables.',
        'Create a meal plan for the week.',
        'Spend time organizing your kitchen pantry.',
        'Learn about different cuisines and their ingredients.',
        'Experiment with plating and presentation of food.',
        'Try cooking a dish from a different culture.',
        'Reflect on how cooking helps you relax and be creative.',
        'Join an online cooking community or forum.',
        'Practice baking a simple dessert.',
        'Spend 10 minutes experimenting with spices and flavors.',
      ],
    ),

    Habit(emoji:"🫶🏻",habitName: "SelfLove",
      tasks: [
        'Write down 3 things you love about yourself.',
        'Spend 5 minutes practicing self-affirmations.',
        'Reflect on your achievements and successes.',
        'Create a list of things that make you happy.',
        'Spend time doing something you enjoy.',
        'Practice mindfulness for 10 minutes.',
        'Write a letter to your future self with encouragement.',
        'Reflect on how you can practice self-care today.',
        'Spend time in nature and appreciate its beauty.',
        'Try a new hobby or activity that interests you.',
        'Reflect on your personal growth journey.',
        'Join an online community focused on self-love and positivity.',
        'Practice gratitude by writing down what you’re thankful for.',
        'Spend 10 minutes meditating or practicing deep breathing.',
        'Reflect on how you can be kinder to yourself.',
        'Create a vision board of your goals and dreams.',
        'Spend time journaling about your feelings and thoughts.',
      ],
    ),
    // Continue similarly for: Meditation, Generic Skill-Building, Organization, Digital Detox, Guitar Playing...
  ];

  final newUserHabits = UserHabits()
    ..userId = userId
    ..habits = defaultHabits;

  await isar.writeTxn(() async {
    await isar.userHabits.put(newUserHabits);
  });
}
