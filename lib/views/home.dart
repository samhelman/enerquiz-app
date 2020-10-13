import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

import 'package:EnerQuiz/views/quiz.dart';

import 'package:EnerQuiz/models/questions.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1b6183),
        title: Text(
          'EnerQuiz',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('static/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Think you have what it takes?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 50.0,
                ),
              ),
              ButtonTheme(
                minWidth: 200.0,
                child: RaisedButton(
                  color: Colors.yellow,
                  child: Text(
                    'Take the Quiz',
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
                  onPressed: () => launch('https://www.energuy.ca/careers'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}