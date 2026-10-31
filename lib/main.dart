import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyPage());

class MyPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          title: Text(
            'EVEN or ODD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  void showSnakBar(String text , BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 500,
        ),
      )
    );
  }

  List<int> numbersList = UnicNumbersGenerator._getNumbers(5);
  int i = 0;
  late int listLength = numbersList.length;
  bool myChecker = false;
  int wrongMoves = 0;

  void resetGame() {
    setState(() {
    i = 0;
    numbersList = UnicNumbersGenerator._getNumbers(5);
    myChecker = false;
    wrongMoves = 0;
    });
  }

  void gameOver() {
    setState(() {
      if (i == numbersList.length - 1) {
        myChecker = true;
      } else {
        i++;
      }
    });
  }

  void wrongAnswer() {
  setState(() {
    wrongMoves++;

    if (wrongMoves >= 3) {
      myChecker = true;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Wrong',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$wrongMoves',
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Round',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${myChecker ? numbersList.length : i + 1} of ${numbersList.length}',
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Draggable<int>(
            data: numbersList[i],
            maxSimultaneousDrags: myChecker ? 0 : 1,
            feedback: Opacity(
              opacity: 0.6,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey,
                alignment: Alignment.center,
                child: Text(
                  numbersList[i].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.6,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey,
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text(
                numbersList[i].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          myChecker 
          ? Column(
            children: [
              Text(
                'G A M E  O V E R',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
          :
          Text(
            '',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DragTarget<int>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text(
                      'EVEN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                    fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                onWillAcceptWithDetails: (details) {
                  return !myChecker;
                },
                onAcceptWithDetails: (DragTargetDetails<int?> details) {
                  if (details.data! % 2 == 0) {
                    showSnakBar('Correct', context);
                    gameOver();
                  } else {
                    showSnakBar('Wrong', context);
                    wrongAnswer();
                  }
                },
              ),
              DragTarget<int>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(
                      'ODD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                    fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                onWillAcceptWithDetails: (details) {
                  return !myChecker;
                },
                onAcceptWithDetails: (DragTargetDetails<int?> details) {
                  if (details.data! % 2 == 0) {
                    showSnakBar('Wrong', context);
                    wrongAnswer();
                  } else {
                    showSnakBar('Correct', context);
                    gameOver();
                  }
                },
              ),
            ],
          ),
          TextButton(
            onPressed: resetGame, 
            child: Text(
              'Reset Game',
            ),
          ),
        ],
      ),
    );
  }
}

class UnicNumbersGenerator {
  static final Random random = Random();
  static List<int> _getNumbers(int count) {
    return List.generate(count, (index) => random.nextInt(100));
  }
}