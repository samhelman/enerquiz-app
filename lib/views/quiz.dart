import 'package:flutter/material.dart';

import 'package:EnerQuiz/views/home.dart';
import 'package:EnerQuiz/views/results.dart';
import 'package:EnerQuiz/models/questions.dart';

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  List questions;
  int score;

  QuizScreen(List questions, int score) {
    this.questions = questions;
    this.score = score;
  }

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff4682b4),
          title: Text('Quiz'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }),
                      (Route<dynamic> route) => false,
                );
              },
            )
          ]),
      body: ListView(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuestionCard(widget.questions, widget.score),
              ]),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AnswerButton extends StatefulWidget {
  List questions;
  String answer;
  int score;
  Color color = Colors.white70;
  bool isCorrect;

  AnswerButton(String answer, int score, List questions, isCorrect) {
    this.questions = questions;
    this.answer = answer;
    this.score = score;
    this.isCorrect = isCorrect;
  }

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  Color updateColor() {
    setState(() {
      if (widget.color == Colors.white70) {
        widget.color = Colors.yellow;
      } else {
        widget.color = Colors.white70;
      }
    });
    return widget.color;
  }

  int updateScore() {
    if (widget.isCorrect) {
      widget.score += 1;
    }
    return widget.score;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200.0,
      child: RaisedButton(
        color: widget.color,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Text(
            widget.answer,
            style: TextStyle(
              fontFamily: 'Raleway',
            ),
          ),),
        onPressed: () {
          updateColor();
          updateScore();
          if (widget.questions.isNotEmpty) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return QuizScreen(widget.questions, widget.score);
              }),
                  (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return ResultsScreen(widget.score);
              }),
                  (Route<dynamic> route) => false,
            );
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class QuestionCard extends StatefulWidget {
  List questions;
  Question question;
  int score;
  bool openSource = false;

  QuestionCard(List questions, int score) {
    this.question = questions[0];
    questions.remove(questions[0]);
    this.questions = questions;
    this.score = score;
  }

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.question.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                AnswerButton(
                    widget.question.answer_1,
                    this.widget.score,
                    this.widget.questions,
                    widget.question.answer_1 == widget.question.correctAnswer),
                SizedBox(height: 10.0),
                AnswerButton(
                    widget.question.answer_2,
                    this.widget.score,
                    this.widget.questions,
                    widget.question.answer_2 == widget.question.correctAnswer),
                SizedBox(height: 10.0),
                AnswerButton(
                    widget.question.answer_3,
                    this.widget.score,
                    this.widget.questions,
                    widget.question.answer_3 == widget.question.correctAnswer),
                SizedBox(height: 10.0),
                AnswerButton(
                    widget.question.answer_4,
                    this.widget.score,
                    this.widget.questions,
                    widget.question.answer_4 == widget.question.correctAnswer),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Q${widget.question.id}/10',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: (widget.openSource)
                          ? Icon(Icons.close)
                          : Icon(Icons.help),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          widget.openSource = !widget.openSource;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (widget.openSource)
          Card(
            margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            color: Colors.yellow,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                children: [
                  Text(
                    'You can find the answer here:',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    widget.question.source,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}