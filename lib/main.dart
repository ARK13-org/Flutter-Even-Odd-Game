import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const EvenOddApp());
}

// --------------------------------------------------
// APP
// --------------------------------------------------

class EvenOddApp extends StatelessWidget {
  const EvenOddApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Even or Odd',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

// --------------------------------------------------
// HOME PAGE
// --------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colors
  static const Color background = Color(0xFF110D20);
  static const Color surface = Color(0xFF211A35);
  static const Color primary = Color(0xFF9B7BFF);
  static const Color green = Color(0xFF42D6A4);
  static const Color red = Color(0xFFFF6485);

  // Game settings
  static const int totalRounds = 5;
  static const int maxMistakes = 3;

  final Random _random = Random();

  // Game state
  late List<int> numbers;

  int currentIndex = 0;
  int wrongMoves = 0;
  int score = 0;

  bool isGameOver = false;
  bool hasWon = false;

  int get currentNumber => numbers[currentIndex];

  @override
  void initState() {
    super.initState();
    numbers = generateNumbers();
  }

  // --------------------------------------------------
  // GAME LOGIC
  // --------------------------------------------------

  List<int> generateNumbers() {
    final Set<int> uniqueNumbers = {};

    while (uniqueNumbers.length < totalRounds) {
      uniqueNumbers.add(_random.nextInt(100));
    }

    return uniqueNumbers.toList();
  }

  void resetGame() {
    setState(() {
      numbers = generateNumbers();
      currentIndex = 0;
      wrongMoves = 0;
      score = 0;
      isGameOver = false;
      hasWon = false;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void checkAnswer(bool selectedEven) {
    if (isGameOver) return;

    final bool numberIsEven = currentNumber % 2 == 0;
    final bool isCorrect = numberIsEven == selectedEven;

    if (isCorrect) {
      setState(() {
        score += 10;

        if (currentIndex == totalRounds - 1) {
          isGameOver = true;
          hasWon = true;
        } else {
          currentIndex++;
        }
      });

      showMessage(
        hasWon ? 'Perfect! You completed the game!' : 'Correct! +10 points',
        green,
      );
    } else {
      setState(() {
        wrongMoves++;

        if (wrongMoves >= maxMistakes) {
          isGameOver = true;
          hasWon = false;
        }
      });

      showMessage(
        isGameOver ? 'Game over! Try again.' : 'Incorrect! Try again.',
        red,
      );
    }
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                color == green
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: color == green
              ? const Color(0xFF167D61)
              : const Color(0xFFB83F61),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
  }

  // --------------------------------------------------
  // MAIN BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF211735), Color(0xFF110D20), Color(0xFF17132A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 32),
                    buildWelcome(),
                    const SizedBox(height: 25),
                    buildStats(),
                    const SizedBox(height: 25),
                    buildProgress(),
                    const SizedBox(height: 35),
                    buildNumberSection(),
                    const SizedBox(height: 35),
                    buildDropZones(),
                    const SizedBox(height: 30),
                    buildRestartButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.bolt_rounded, color: primary, size: 28),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BRAIN GAMES',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Even or Odd',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton.filledTonal(
          onPressed: resetGame,
          tooltip: 'Restart',
          style: IconButton.styleFrom(
            backgroundColor: surface,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // WELCOME
  // --------------------------------------------------

  Widget buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ready to play?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Drag the number into the correct category.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // STATS
  // --------------------------------------------------

  Widget buildStats() {
    final int displayedRound = isGameOver && hasWon
        ? totalRounds
        : currentIndex + 1;

    return Row(
      children: [
        Expanded(
          child: buildStatCard(
            icon: Icons.favorite_rounded,
            label: 'MISTAKES',
            value: '$wrongMoves / $maxMistakes',
            color: red,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: buildStatCard(
            icon: Icons.flag_rounded,
            label: 'ROUND',
            value: '$displayedRound / $totalRounds',
            color: primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: buildStatCard(
            icon: Icons.stars_rounded,
            label: 'SCORE',
            value: '$score',
            color: green,
          ),
        ),
      ],
    );
  }

  Widget buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 9),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // PROGRESS
  // --------------------------------------------------

  Widget buildProgress() {
    final double progress = isGameOver
        ? (hasWon ? 1.0 : currentIndex / totalRounds)
        : currentIndex / totalRounds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'YOUR PROGRESS',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 11,
                letterSpacing: 1.3,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation(primary),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(maxMistakes, (index) {
            final bool used = index < wrongMoves;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                used ? Icons.cancel_rounded : Icons.circle_outlined,
                color: used ? red : Colors.white30,
                size: 18,
              ),
            );
          }),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // NUMBER CARD
  // --------------------------------------------------

  Widget buildNumberSection() {
    return Column(
      children: [
        const Text(
          'DRAG THIS NUMBER',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),

        if (isGameOver)
          buildGameOver()
        else
          LayoutBuilder(
            builder: (context, constraints) {
              return Draggable<int>(
                data: currentNumber,
                maxSimultaneousDrags: 1,

                feedback: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: buildNumberCard(isDragging: true),
                  ),
                ),

                childWhenDragging: Opacity(
                  opacity: 0.25,
                  child: buildNumberCard(),
                ),

                child: buildNumberCard(),
              );
            },
          ),

        const SizedBox(height: 12),

        if (!isGameOver)
          Text(
            'Hold and drag the number below',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget buildNumberCard({bool isDragging = false}) {
    return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF55408D), Color(0xFF30234F)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: primary.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDragging ? 0.3 : 0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.touch_app_rounded, color: Colors.white54, size: 25),
          const SizedBox(height: 8),
          Text(
            '$currentNumber',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 65,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'DRAG ME',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // GAME OVER
  // --------------------------------------------------

  Widget buildGameOver() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: (hasWon ? green : red).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(
            hasWon
                ? Icons.emoji_events_rounded
                : Icons.sentiment_dissatisfied_rounded,
            color: hasWon ? green : red,
            size: 65,
          ),
          const SizedBox(height: 15),
          Text(
            hasWon ? 'YOU DID IT!' : 'GAME OVER',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasWon
                ? 'You completed all $totalRounds rounds!'
                : 'You made $maxMistakes mistakes. Keep practicing!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Text(
            'FINAL SCORE: $score',
            style: const TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // DROP ZONES
  // --------------------------------------------------

  Widget buildDropZones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHOOSE THE CATEGORY',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: buildDropZone(
                label: 'EVEN',
                subtitle: '2, 4, 6, 8...',
                icon: Icons.check_circle_outline_rounded,
                color: green,
                isEven: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: buildDropZone(
                label: 'ODD',
                subtitle: '1, 3, 5, 7...',
                icon: Icons.bolt_rounded,
                color: red,
                isEven: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDropZone({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isEven,
  }) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (_) => !isGameOver,

      onAcceptWithDetails: (_) {
        checkAnswer(isEven);
      },

      builder: (context, candidateData, rejectedData) {
        final bool isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 145,
          decoration: BoxDecoration(
            color: isHovering
                ? color.withValues(alpha: 0.22)
                : color.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovering ? color : color.withValues(alpha: 0.35),
              width: isHovering ? 2.5 : 1.2,
            ),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isHovering ? 'DROP HERE!' : subtitle,
                style: TextStyle(
                  color: color.withValues(alpha: 0.75),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // RESTART BUTTON
  // --------------------------------------------------

  Widget buildRestartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: resetGame,
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.refresh_rounded),
        label: Text(
          isGameOver ? 'PLAY AGAIN' : 'RESTART GAME',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
