import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

import 'package:EnerQuiz/views/home.dart';
import 'package:EnerQuiz/views/quiz.dart';
import 'package:EnerQuiz/models/questions.dart';

// ignore: must_be_immutable
class ResultsScreen extends StatefulWidget {
  int score;

  ResultsScreen(int score) {
    this.score = score;
  }

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff4682b4),
            title: Text('Results'),
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
        body: Column(children: <Widget>[
          Card(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        'Results',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'You Scored:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${widget.score}/10',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  Column(
                    children: [
                      ButtonTheme(
                        minWidth: 200.0,
                        child: RaisedButton(
                          color: Colors.yellow,
                          child: Text(
                            'Take Again...',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return QuizScreen(new Questions().questions, 0);
                              }),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 200.0,
                        child: RaisedButton(
                          color: Color(0xff4682b4),
                          child: Text(
                            'Become an Energuy',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () =>
                              launch('https://www.energuy.ca/careers'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            color: Colors.white,
            shadowColor: Colors.black,
          ),
        ]));
  }
}
