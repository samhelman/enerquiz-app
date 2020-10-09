import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launch;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnerQuiz',
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff4682b4)),
      home: HomeScreen(),
    );
  }
}

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

class Question {
  var id;
  var question;
  var answer_1;
  var answer_2;
  var answer_3;
  var answer_4;
  var correctAnswer;
  var source;

  Question(
      {
        this.id,
        this.question,
      this.answer_1,
      this.answer_2,
      this.answer_3,
      this.answer_4,
      this.correctAnswer,
      this.source});

  factory Question.fromJson(Map<String, dynamic> data, int id) {
    return Question(
      id: id,
      question: data['question'],
      answer_1: data['answer_1'],
      answer_2: data['answer_2'],
      answer_3: data['answer_3'],
      answer_4: data['answer_4'],
      correctAnswer: data['correctAnswer'],
      source: data['source'],
    );
  }
}

class Questions {
  List questions = [];

  Questions() {
    var data = jsonData;
    var parsedJson = json.decode(data);
    parsedJson.shuffle();
    var tenQuestions = parsedJson.take(10);
    int i = 1;
    for (var question in tenQuestions) {
      this.questions.add(Question.fromJson(question, i));
      i++;
    }
    //this.questions = tenQuestions.map((i) => Question.fromJson(i)).toList();
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

var jsonData =
    '''
    [
    {
        "question_type": "Multiple Choice",
        "category": "Foundations",
        "question_image": "No Image",
        "answer_4": "Open cell spray foam insulation ",
        "question": "Which of the following insulation materials is most suitable for installation on the gravel before a concrete basement floor is poured?",
        "answer_1": "Mineral wool insulation ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.48",
        "answer_2": "Fibreglass batts insulation ",
        "answer_3": "Extruded polystyrene insulation ",
        "correctAnswer": "Extruded polystyrene insulation "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "2816 cubic ft per minute ",
        "question": "What is the volume of a gable attic that is 22 ft long by 16 ft wide by 8 ft high?",
        "answer_1": "352 sq ft ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.122",
        "answer_2": "2816 cubic ft ",
        "answer_3": "1408 cubic ft ",
        "correctAnswer": "1408 cubic ft "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "Cannot exceed 10. ",
        "question": "How many of the same window can you model at the same time in H2K?",
        "answer_1": "Only 1 at a time. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.6",
        "answer_2": "As many as needed. ",
        "answer_3": "Cannot exceed 9. ",
        "correctAnswer": "Cannot exceed 9. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Combo systems using an oil boiler ",
        "question": "Identify the types of systems that can be modelled in the heat/DHW combination screen? ",
        "answer_1": "Propane, gas and oil, and storage tank water heater combo systems (condensing or non-condensing) ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.7",
        "answer_2": "Gas and tankless water heater combo systems without a secondary storage tank (condensing or non-condensing) ",
        "answer_3": "Propane and tankless water heater combo systems with a secondary storage tank (condensing or non-condensing) ",
        "correctAnswer": "Propane, gas and oil, and storage tank water heater combo systems (condensing or non-condensing) "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heat Pumps",
        "question_image": "No Image",
        "answer_4": "The Temperature Cut-off Type. ",
        "question": "When modelling a heat pump as a ground source heat pump (GSHP), which of the following kinds of information is not required in HOT2000?",
        "answer_1": "The Unit Function by specifying whether the heat pump is used for heating only or both heating and cooling; ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.9.1",
        "answer_2": "The Central Equipment Type by selecting the equipment type as a central split system, central single package system or mini-split ductless; ",
        "answer_3": "The Heating/Cooling Efficiency; ",
        "correctAnswer": "The Central Equipment Type by selecting the equipment type as a central split system, central single package system or mini-split ductless; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Do not modify the default value. ",
        "question": "If a motorized vent damper is not an option listed for the Equipment type (e.g. for an oil furnace w/ flame retention head or gas furnace w/ continuous pilot), how should the user modify the HOT2000 default flue diameter?",
        "answer_1": "Decrease by 25\u00a0mm (1 in.); ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.6",
        "answer_2": "Increase by 25\u00a0mm (1 in.); ",
        "answer_3": "Increase by 52\u00a0mm (2 in.); ",
        "correctAnswer": "Decrease by 25\u00a0mm (1 in.); "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "Q= n\u0394P^c. ",
        "question": "The air exchange rate per hour at a forced air pressure difference of 50\u00a0Pa is calculated by blower door software based on the airtightness test results using the formula where:",
        "answer_1": "Q= C\u0394P; ",
        "exam": "EA",
        "source": "Technical Procedures, 7.1.2",
        "answer_2": "Q= C\u0394P^n; ",
        "answer_3": "Q= m\u0394P^c; ",
        "correctAnswer": "Q= C\u0394P^n; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "The heating capacity and the energy factor of radiant heating. ",
        "question": "When modelling a radiant heating system, the modelling requirement(s) to be entered in the radiant heating screen are:",
        "answer_1": "Manufacturer, model and heating capacity; ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.20",
        "answer_2": "The effective temperature and percentage of the radiant heated area; ",
        "answer_3": "The energy factor of radiant heating; ",
        "correctAnswer": "The effective temperature and percentage of the radiant heated area; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "Skylights, windows within doors, or patio doors should be modelled:",
        "answer_1": "In the wizard; ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 6.1.3",
        "answer_2": "In the main interface upon exiting the wizard; ",
        "answer_3": "Both In the wizard and in the main interface upon exiting the wizard; ",
        "correctAnswer": "In the main interface upon exiting the wizard; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Equipment type, flue diameter, the temperature of exhaust gas and the radiation loss level. ",
        "question": "In case of solid-fuel burning equipment, the energy advisor should collect the following information:",
        "answer_1": "Equipment manufacturer and model, whether the damper is open or closed: ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.21",
        "answer_2": "Equipment type, flue diameter, whether the damper is open or closed; ",
        "answer_3": "Equipment type, flue diameter and the temperature of exhaust gas; ",
        "correctAnswer": "Equipment type, flue diameter, whether the damper is open or closed; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Data are not required for this case. ",
        "question": "Baseboards, furnaces, boilers and solid-fuel burning appliances may serve as supplementary systems. When that is the case, which data are required to be collected in all cases? ",
        "answer_1": "The equipment type, energy source, presence of a pilot, and pilot light energy consumption if available; ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.13",
        "answer_2": "Equipment type, flue diameter, whether the damper is open or closed and the number of identically-sized openings (for whole-building MURBs); ",
        "answer_3": "The equipment type, flue diameter and the temperature of exhaust gas; ",
        "correctAnswer": "The equipment type, energy source, presence of a pilot, and pilot light energy consumption if available; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Standard Operating Conditions",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "What does rated annual energy consumption represent?",
        "answer_1": "The sum of space heating, space cooling, domestic water heating, distribution of ventilation air (electrical energy consumption only), and electrical base loads; ",
        "exam": "EA",
        "source": "Standard, 3.",
        "answer_2": "The distribution of ventilation air (electrical energy consumption only) and electrical base loads; ",
        "answer_3": "The sum of space heating, space cooling and domestic water heating; ",
        "correctAnswer": "The sum of space heating, space cooling, domestic water heating, distribution of ventilation air (electrical energy consumption only), and electrical base loads; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Unit Conversions",
        "question_image": "No Image",
        "answer_4": "1 inch = 1 cm ",
        "question": "Convert cm to inches.",
        "answer_1": "1 inch = 2.5 cm ",
        "exam": "EA",
        "source": "None.",
        "answer_2": "2.5 inches = 1 cm ",
        "answer_3": "1 inch = 2 cm ",
        "correctAnswer": "1 inch = 2.5 cm "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Unit Conversions",
        "question_image": "No Image",
        "answer_4": "RSI 68.13 ",
        "question": "What is R12 when converted to RSI units?",
        "answer_1": "RSI 2.11 ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.13",
        "answer_2": "RSI 68.14 ",
        "answer_3": "RSI 2.12 ",
        "correctAnswer": "RSI 2.11 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "Can be ignored.  ",
        "question": "How should a skylight shaft wall be modelled in HOT2000 when it is located in a roof assembly whose depth is filled with insulation?",
        "answer_1": "Wall regardless of its slope; ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.4",
        "answer_2": "Glass block configuration; ",
        "answer_3": "Window regardless of its slope; ",
        "correctAnswer": "Can be ignored.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Domestic Hot Water",
        "question_image": "No Image",
        "answer_4": "Tankless propane hot water system ",
        "question": "Which of the following is not a valid domestic hot water system?",
        "answer_1": "Heat pump condensing hot water system ",
        "exam": "EA",
        "source": "Technical Procedures, 3.6",
        "answer_2": "Oil conventional tank hot water system ",
        "answer_3": "Induced draft gas-fired hot water system ",
        "correctAnswer": "Heat pump condensing hot water system "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heat Pumps",
        "question_image": "No Image",
        "answer_4": "If the house mechanical system is equipped with a balanced heat recovery ventilator. ",
        "question": "Under which condition should the temperature of cut-off type heat pumps be considered as \u201cRestricted\u201d? ",
        "answer_1": "If the air-source heat pump shuts down when it is not able to meet the full space heating load; ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.19",
        "answer_2": "If the air source heat pump shuts off at a user-defined temperature; ",
        "answer_3": "If the interior temperature reaches 72\u00a0\u00b0F (22\u00a0\u00b0C); ",
        "correctAnswer": "If the air source heat pump shuts off at a user-defined temperature; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heat Pumps",
        "question_image": "No Image",
        "answer_4": "Model numbers of both the condenser and evaporator coils of ASHPs and central air conditioner. ",
        "question": "If the efficiency of a heat pump or air conditioning unit is unknown, what further data should be exclusively collected? ",
        "answer_1": "Unit function; ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.19",
        "answer_2": "Manufacturer and model number; ",
        "answer_3": "Whether or not the basement is cooled; ",
        "correctAnswer": "Manufacturer and model number; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "It does not apply to organizations that operate entirely within a province with legislation deemed substantially similar to the PIPEDA if personal information crosses provincial or national borders. ",
        "question": "The Personal Information Protection and Electronic Documents Act (PIPEDA) sets out the general rules governing how private-sector organizations collect, use or disclose personal information in the course of commercial activities across Canada. Among the following statements, which is true?",
        "answer_1": "It also applies to organizations that are not engaged in commercial activity. ",
        "exam": "EA",
        "source": "Administrative Procedures, Appendix A.",
        "answer_2": "It also applies to personal information of employees of federally regulated works, undertakings, or businesses (e.g., banks, airlines, and telecommunications companies). ",
        "answer_3": "It also applies to organizations that operate entirely within a province with legislation deemed substantially similar to the PIPEDA if personal information does not cross provincial or national borders. ",
        "correctAnswer": "It also applies to personal information of employees of federally regulated works, undertakings, or businesses (e.g., banks, airlines, and telecommunications companies). "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "The should be ignored. ",
        "question": "How are bath and kitchen fans modelled?",
        "answer_1": "As part of the central ventilation system. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.11.3",
        "answer_2": "As atypical loads. ",
        "answer_3": "As supplemental components. ",
        "correctAnswer": "As supplemental components. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "Year built ",
        "question": "Which of the following is not a data field in the Main House selector screen?",
        "answer_1": "House type ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 6.1.1",
        "answer_2": "Heating system type ",
        "answer_3": "Ceiling type ",
        "correctAnswer": "Heating system type "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "Pay exam fees (no registration is needed), take the exam online and achieve a passing grade on said exam(s). ",
        "question": "To take the ERS exams, prospective energy advisors must: ",
        "answer_1": "Register to take the relevant exam(s) at a Natural Resources Canada approved test centre, pay exam fees, write the exam(s) in the presence of a Natural Resources Canada approved exam proctor and achieve a passing grade on said exam(s);",
        "exam": "EA",
        "source": "Administrative Procedures, 9.3",
        "answer_2": "Register to take the relevant exam(s) at a service organization Canada approved test centre, pay exam fees, write the exam(s) in the presence of a service organization manager approved exam proctor and achieve a passing grade on said exam(s); ",
        "answer_3": "Register to take the relevant exam(s) online, write the exam(s) and achieve a passing grade on said exam(s); "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "All of the above. ",
        "question": "The ERS official marks should never be used in the following manner:",
        "answer_1": "Suggests that NRCan or any other government body endorses a particular organization, company or product; ",
        "exam": "EA",
        "source": "Administrative Procedures, Appendix C.",
        "answer_2": "Associates the ERS official mark or graphic identifier with products or services not within the scope of the NRCan EnerGuide Rating System; ",
        "answer_3": "Disparages the Government of Canada, Natural Resources Canada or any other government body; ",
        "correctAnswer": "All of the above. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Zero-Rated Homes",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "For zero-rated homes, the data collection requirement(s) for dryers are:",
        "answer_1": "Annual energy consumption as displayed on the EnerGuide label; ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.11.6",
        "answer_2": "Manufacturer name and model number; ",
        "answer_3": "Manufacturer name, model number and annual energy consumption as displayed on the EnerGuide label; ",
        "correctAnswer": "Manufacturer name, model number and annual energy consumption as displayed on the EnerGuide label; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "1:1 ",
        "question": "A roof has a slope of 45\u00b0. What is its slope?",
        "answer_1": "45:1 ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "1:45 ",
        "answer_3": "90:2 ",
        "correctAnswer": "1:1 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "12:3 ",
        "question": "A roof has a run of 6 feet and a rise of 3 feet. What is its slope?",
        "answer_1": "6:3 ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "1:2 ",
        "answer_3": "3:12 ",
        "correctAnswer": "1:2 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "5:20 ",
        "question": "A roof has a rise of 10 feet and a span of 20 feet. What is its slope?",
        "answer_1": "1:2 ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "20:10 ",
        "answer_3": "1:1 ",
        "correctAnswer": "1:1 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "4:3 ",
        "question": "A roof has a rafter with a length of 25 feet and a rise of 20 feet. What is its slope?",
        "answer_1": "3:4 ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "5:4 ",
        "answer_3": "4:5 ",
        "correctAnswer": "4:3 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Unit Conversions",
        "question_image": "No Image",
        "answer_4": "273.04 kW ",
        "question": "What is the heating capacity in kW of a 80,000BTU/h furnace",
        "answer_1": "23.44 kW ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "BTU/h is an energy units and cannot be converted to kW ",
        "answer_3": "23,440 kW ",
        "correctAnswer": "23.44 kW "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Insulation",
        "question_image": "No Image",
        "answer_4": "It is the insulation value when we take into account the heating degree days.  ",
        "question": "What characterizes effective thermal resistance?",
        "answer_1": "It is the insulation value of the material itself. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "It is the overall insulation value when we take into account all the building components of the assembly. ",
        "answer_3": "It is the insulation value of all the building components other than the insulating material. ",
        "correctAnswer": "It is the overall insulation value when we take into account all the building components of the assembly. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "The house wrap is sealed directly to the window frame using expanding foam. ",
        "question": "Which of the following statements is true about house wrap air barrier approach?",
        "answer_1": "It is sealed around service penetrations using gasket, caulking or tape. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "It covers the outside wall of the foundations. ",
        "answer_3": "Plastic air-tight electrical boxes can be used to ensure continuity around in-house electrical boxes. ",
        "correctAnswer": "It is sealed around service penetrations using gasket, caulking or tape. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Foundations",
        "question_image": "No Image",
        "answer_4": "A permeable top layer that channels water to the drainage pipe system ",
        "question": "Which of the following is not in included in an Effective wall drainage system:",
        "answer_1": "Surface drainage to direct water away from the foundation. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Free-drainage backfill or a drainage plane next to the foundation. ",
        "answer_3": "Graded drainage pipe system ",
        "correctAnswer": "A permeable top layer that channels water to the drainage pipe system "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Foundations",
        "question_image": "No Image",
        "answer_4": "Can lead to the identification of other hidden problems that require attention. ",
        "question": "What is an advantage of adding below grade wall insulation to the exterior of the building envelope?",
        "answer_1": "No disruption in the house, no interior work disturbed, but inside space is lost. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Freeze-thaw stresses are eliminated, and frost is unlikely to penetrate down to the footings. ",
        "answer_3": "The mass of the foundation is within the insulated portion of the house and will tend to even out temperature fluctuations. ",
        "correctAnswer": "Can lead to the identification of other hidden problems that require attention. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Mechanical Systems",
        "question_image": "No Image",
        "answer_4": "A ground-source heat pump uses the earth or ground water or both as the sources of heat in the summer, and as the \'sink\' for heat removed from the home in the winter. ",
        "question": "Which of the following statements is false regarding high efficiency mechanical systems in houses and residential buildings?",
        "answer_1": "Integrated mechanical systems (IMS) group the functions of space heating, water heating and heat recovery ventilation into a single package. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Geothermal heat pump systems have a working life estimated at 25 years  ",
        "answer_3": "Air-source heat pumps draw heat from the outside air during the heating season and reject heat outside during the summer cooling season. ",
        "correctAnswer": "A ground-source heat pump uses the earth or ground water or both as the sources of heat in the summer, and as the \'sink\' for heat removed from the home in the winter. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "The main air barrier material forms a principal plane. ",
        "question": "Which statement below is false about an effective air barrier:  ",
        "answer_1": "It is a leakage control system. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "There can be multiple air barriers. ",
        "answer_3": "It can only be located on the cold side of the assembly to avoid condensation. ",
        "correctAnswer": "It can only be located on the cold side of the assembly to avoid condensation. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "To reduce radiation heat losses. ",
        "question": "What is the main purpose of the HSG low-e coating during the cooling season? ",
        "answer_1": "To limit conduction losses through the glazing. ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.177",
        "answer_2": "To reduce heat gains. ",
        "answer_3": "To help limit air leakage and condensation in the glazing. ",
        "correctAnswer": "To reduce radiation heat losses. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "ER ratings do not apply to skylights ",
        "question": "Which of the following statements is true about residential Fenestration Energy Ratings?",
        "answer_1": "A negative rating indicates that heat gains are superior to heat losses. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "It represents a window\u2019s overall heat loss coefficient expressed in W/m2K or in Btu/(hr)(ft2)(\u00b0F). ",
        "answer_3": "It is adversely affected by air exfiltration only. ",
        "correctAnswer": "ER ratings do not apply to skylights "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "For zone 2 skylight compliance : have U factor below 1.40 W/m2K and an Energy rating above 20 ",
        "question": "What is required to comply to ENERGY STAR ",
        "answer_1": "For zone 1 windows compliance : have U factor below 1.60 W/m2K and an Energy rating above 16 ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "For zone 1 skylight compliance : have U factor below 1.60 W/m2K and an Energy rating above 16 ",
        "answer_3": "For zone 2 windows compliance : have U factor below 1.60 W/m2K and an Energy rating above 16 ",
        "correctAnswer": "For zone 1 windows compliance : have U factor below 1.60 W/m2K and an Energy rating above 16 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "The temperature where the heating equipment should be at the peak efficiency level. ",
        "question": "What is the winter outdoor design temperature?",
        "answer_1": "The lowest possible temperature that can be expected during a winter.  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "The temperature below which the heating equipment starts supplying heat. ",
        "answer_3": "The temperature below which the heating equipment cannot meet the indoor temperature set-points. ",
        "correctAnswer": "The temperature below which the heating equipment cannot meet the indoor temperature set-points. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Air Conditioners",
        "question_image": "No Image",
        "answer_4": "Limiting air infiltration can reduce the cooling load. ",
        "question": "Which of the following statements is false regarding the cooling load: ",
        "answer_1": "The peak cooling load occurs during the peak heat gain period of the day. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "The cooling load represents the heat extraction rate required to meet given indoor conditions. ",
        "answer_3": "The cooling load can be expressed in W or Btu/h. ",
        "correctAnswer": "The peak cooling load occurs during the peak heat gain period of the day. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Domestic Hot Water",
        "question_image": "No Image",
        "answer_4": "DWHR systems can also be used in a decentralized manner, using DWHR to preheat cold water entering a shower. ",
        "question": "Which of the following statement is false?:",
        "answer_1": "DWHR systems should be installed in a counter flow manner to enhance heat exchange. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "DWHR require a lot of maintenance.  ",
        "answer_3": "DWHR systems work best with simultaneous flows of hot water like showers, where there is a demand for hot water at the same time as hot water is going down the drain. ",
        "correctAnswer": "DWHR require a lot of maintenance.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "There are few small holes. ",
        "question": "What does the exponent 'n' indicate when it is closer to 0.5?",
        "answer_1": "There are few larger holes. ",
        "exam": "EA",
        "source": "Technical Procedures, 7.6.10.1",
        "answer_2": "There are many small holes. ",
        "answer_3": "There are many large holes. ",
        "correctAnswer": "There are few larger holes. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Safety",
        "question_image": "No Image",
        "answer_4": "Tie yourself to a safety harness when working 5 m (16 ft) or more off the ground or when working with both hands. ",
        "question": "Which of the following statements about the ladder safety protocol is false? ",
        "answer_1": "Check for overhead power lines before setting up a ladder. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Clear debris, tools and other objects from the area around the base and top of the ladder ",
        "answer_3": "Maintain three-point contact by keeping two hands and one foot, or two feet and one hand on the ladder at all times  ",
        "correctAnswer": "Tie yourself to a safety harness when working 5 m (16 ft) or more off the ground or when working with both hands. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "These windows always have higher U-factors compared to krypton-filled windows. ",
        "question": "Which of the following statements about argon-filled windows is true?",
        "answer_1": "This method reduces radiation heat losses and improves the overall U-factor. ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.177",
        "answer_2": "This method limits heat losses by suppressing the gas movement between the panes. ",
        "answer_3": "This method reduces the risk of condensation between the panes. ",
        "correctAnswer": "This method limits heat losses by suppressing the gas movement between the panes. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "When a central heating system is used, the heating load is the same for all the rooms of a\u00a0house. ",
        "question": "Which of the following statements is true regarding the peak heating load requirements of a home?",
        "answer_1": "Is it always cost-effective for a geothermal system to be sized to meet the full heating load. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Thermal bridging cannot be neglected when calculating heating loads because it accentuates heat transfer.  ",
        "answer_3": "Lower U-values lead to higher heating load.  ",
        "correctAnswer": "Thermal bridging cannot be neglected when calculating heating loads because it accentuates heat transfer.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Unit Conversions",
        "question_image": "No Image",
        "answer_4": "Btu/h is energy, while W is power. ",
        "question": "You have a BBQ with a maximum heat output of 30,000 Btu/h (power), what is the equivalent in W?",
        "answer_1": "8,800 W ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "8,400 W ",
        "answer_3": "28,400 W ",
        "correctAnswer": "8,800 W "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Unit Conversions",
        "question_image": "No Image",
        "answer_4": "3.75kW ",
        "question": "If a heat pump has a COP of 4.0 and outputs 5 kW of heating, how much electrical power is used by the heat pump? ",
        "answer_1": "1.25 kW ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "9 kW ",
        "answer_3": "20 kW ",
        "correctAnswer": "1.25 kW "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Natural gas is composed of a high percentage of methane (CH4) (generally above 85 percent) and varying amounts of ethane, propane, butane, and inert gases (typically nitrogen, carbon dioxide, and helium). ",
        "question": "Which of the following statements is false?",
        "answer_1": "For the purpose of space and water-heating in homes, gas combustion occurs in its liquid state.  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Oil combustion occurs in its liquid state.  ",
        "answer_3": "Oil-fired combustion efficiency increases with higher static burners.  ",
        "correctAnswer": "For the purpose of space and water-heating in homes, gas combustion occurs in its liquid state.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Domestic Hot Water",
        "question_image": "No Image",
        "answer_4": "To protect the inside of the tank from corrosion, storage tank water heaters are usually equipped with a galvanic anode.  ",
        "question": "Which of the following statement is false :",
        "answer_1": "Drain water heat recovery and solar domestic water heating systems can be used as energy efficiency and renewable energy measures in Canada.  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "A lower standby loss yield to a higher efficiency Electrical water heater which can be reached by better insulation around the tank.  ",
        "answer_3": "Gas fired water heaters and electric water heaters are rated with the same energy efficiency rating.  ",
        "correctAnswer": "Gas fired water heaters and electric water heaters are rated with the same energy efficiency rating.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Direct vent ",
        "question": "Which of the following system prevents combustion gas spillage?",
        "answer_1": "Naturally aspired  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Forced draft ",
        "answer_3": "Induced Draft ",
        "correctAnswer": "Direct vent "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "Air changes per house, building envelope, energy use and energy production of a home. ",
        "question": "Which of the following elements are considered in the EnerGuide Rating.",
        "answer_1": "Building envelope, cold water use and energy use in a home. ",
        "exam": "EA",
        "source": "Standard, 4.",
        "answer_2": "Air changes per house, embodied energy and energy production of a home. ",
        "answer_3": "Source energy, embodied energy, building envelope and cold water use in a home. ",
        "correctAnswer": "Air changes per house, building envelope, energy use and energy production of a home. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "Separately ducted HRVs and ERV systems do not require a furnace fan to run as part of the ventilation distribution system ",
        "question": "Which of the following statements is false regarding ventilation: ",
        "answer_1": "Balanced ventilation uses fans to simultaneously exhaust air and supply outdoor air in equal quantities.  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Specific measures should be taken in the case of soil gas, attached garages and fuel-fired equipment that is not directly-vented or mechanically vented.  ",
        "answer_3": "Exhaust-only ventilation system fans are usually controlled by thermostats.  ",
        "correctAnswer": "Exhaust-only ventilation system fans are usually controlled by thermostats.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Solar Design",
        "question_image": "No Image",
        "answer_4": "Does not matter. ",
        "question": "To optimize energy efficiency and ensure good solar exposure in a neighborhood, what should be the orientation of most streets?",
        "answer_1": "Along the east-west axis. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Along the north-south axis. ",
        "answer_3": "Along the northeast-southwest axis. ",
        "correctAnswer": "Along the east-west axis. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Solar Design",
        "question_image": "No Image",
        "answer_4": "Increasing the height of a wind turbine will usually not affect its energy contribution.  ",
        "question": "Which of the following statement is true: ",
        "answer_1": "A compass points to magnetic north, which is located at the axis of rotation of the earth.  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "A solar photovoltaic panel will collect more energy throughout a year if oriented at an angle corresponding to the latitude of the site.  ",
        "answer_3": "Solar irradiance is the same at sea level as it is at high altitudes. ",
        "correctAnswer": "A solar photovoltaic panel will collect more energy throughout a year if oriented at an angle corresponding to the latitude of the site.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Main Walls",
        "question_image": "No Image",
        "answer_4": "1.0 m\u00b2\u00b7\u00b0C/W ",
        "question": "Calculate the R value of a wall assembly with the following components",
        "answer_1": "4.5 m\u00b2\u00b7\u00b0C/W ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "5.0 m\u00b2\u00b7\u00b0C/W ",
        "answer_3": "3.0 m\u00b2\u00b7\u00b0C/W  ",
        "correctAnswer": "4.5 m\u00b2\u00b7\u00b0C/W "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "Balanced ventilation systems are designed with the objective of maintaining neutral pressure inside buildings. ",
        "question": "Which of the following statement is false?",
        "answer_1": "Building Codes  requirements for the fabrication, design, and installation of mechanical ventilation systems vary by province ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "SRE measures the net sensible energy recovered by the supply airstream, excluding latent energy. ",
        "answer_3": "Heat-recovery ventilators (HRVs) are designed to transfer both heat and moisture.  ",
        "correctAnswer": "Heat-recovery ventilators (HRVs) are designed to transfer both heat and moisture.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Solar Design",
        "question_image": "No Image",
        "answer_4": "Evacuated tube liquid collectors are more efficient than glazed flat-plate liquid collectors. ",
        "question": "Which of the following statements is false: ",
        "answer_1": "An active solar domestic hot water system uses a circulating pump to move water or an anti-freeze fluid in solar collectors. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Batch liquid collectors heat water in dark tanks or tubes within an insulated box, storing water until drawn. ",
        "answer_3": "Passive solar domestic hot water systems are most commonly used in Canada. ",
        "correctAnswer": "Passive solar domestic hot water systems are most commonly used in Canada. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Watertightness",
        "question_image": "No Image",
        "answer_4": "Moisture flow through diffusion can be stopped, whereas it can only be delayed for capillary action. ",
        "question": "What is the difference between capillary action and diffusion?",
        "answer_1": "Capillary action causes liquid water to move through porous materials or across small gaps, whereas diffusion is a process whereby vapour passes through a seemingly solid material. ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.12",
        "answer_2": "Capillary action causes liquid water to move through porous materials or across small gaps, whereas diffusion is a process whereby vapour passes through air leakages in the building envelope.  ",
        "answer_3": "A hundred times more moisture can enter a building structure by capillary action than by diffusion. ",
        "correctAnswer": "Capillary action causes liquid water to move through porous materials or across small gaps, whereas diffusion is a process whereby vapour passes through a seemingly solid material. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "Low humidity levels improve air quality. ",
        "question": "How can moisture affect indoor quality?",
        "answer_1": "Low relative humidity leads to condensation and the formation of moulds. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Condensation can lead to mould formation and the release of toxins in the air. ",
        "answer_3": "Water vapour can lead to mould formation and the release of toxins in the air. ",
        "correctAnswer": "Condensation can lead to mould formation and the release of toxins in the air. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "Excessive dust problems ",
        "question": "Which of the following is not an effect of extreme low humidity in a house?",
        "answer_1": "Frosting and fogging of windows ",
        "exam": "MAIN",
        "source": "Keeping the Heat In, Section 2.4.2",
        "answer_2": "Ozone production ",
        "answer_3": "Respiratory Infections ",
        "correctAnswer": "Frosting and fogging of windows "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Asbestos",
        "question_image": "No Image",
        "answer_4": "If you are renovating or demolishing a house or building built before 1990, there is a strong probability that at least some parts contain asbestos. ",
        "question": "Which of the following statement is false regarding asbestos: ",
        "answer_1": "From the 1950s to 1990s, Asbestos was a popular material widely used in more than 3,000 building materials.  ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "Asbestos poses health risks only when fibres are present in the air that people breathe such as in renovation projects where walls, ceilings, floors or equipment are opened and dismantled. ",
        "answer_3": "Vermiculite insulation does not contain asbestos.  ",
        "correctAnswer": "Vermiculite insulation does not contain asbestos.  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "Moulds and fungi are found in nature. ",
        "question": "Which of the following statements about moulds is false?",
        "answer_1": "They can lead to eye, nose, and throat irritation. ",
        "exam": "MAIN",
        "source": "ERS V.15 Supplementary Study Guide, March 2018",
        "answer_2": "They are odourless and as such can only be detected visually. ",
        "answer_3": "Typically, they are found in humid areas with a higher risk of condensation. ",
        "correctAnswer": "They are odourless and as such can only be detected visually. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "Absolute humidity level will stay the same. ",
        "question": "What effect does the infiltration of -20C outdoor air with 95% relative humidity have on the indoor air quality of a home with an indoor air temperature of 23C?",
        "answer_1": "Relative humidity level will increase. ",
        "exam": "EA",
        "source": "Keeping the Heat In, Section 2.1.6",
        "answer_2": "Relative humidity level will decrease. ",
        "answer_3": "Absolute humidity level will increase. ",
        "correctAnswer": "Relative humidity level will increase. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "6:12 ",
        "question": "What is the slope of a roof that has a vertical height (rise) or 2.4 metres (8ft) and an angled roof length of 6.3 metres (20ft 8in)?",
        "answer_1": "3:12 ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.118",
        "answer_2": "4:12 ",
        "answer_3": "5:12 ",
        "correctAnswer": "5:12 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "Vermiculite, asbestos and structural integrity, ",
        "question": "What types of warning can appear on the Homeowner Information Sheet?",
        "answer_1": "Building envelope, mould and exhaust devices depressurisation. ",
        "exam": "EA",
        "source": "Standard, 4.5",
        "answer_2": "Foundation water damage, mechanical ventilation and indoor air quality. ",
        "answer_3": "Vermiculite, mechanical ventilation and exhaust devices depressurization. ",
        "correctAnswer": "Vermiculite, mechanical ventilation and exhaust devices depressurization. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "Installing a balanced ventilation system ",
        "question": "An increase in cooking, laundry and showering in an air tight home may require which of the following in order to reduce the potential for excessive moisture levels in the home?",
        "answer_1": "Installing at least one ceiling fan on every floor ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.215",
        "answer_2": "Upgrading the attic insulation ",
        "answer_3": "Installing triple glazed windows ",
        "correctAnswer": "Installing a balanced ventilation system "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "To endorse another organisation's particular product of service. ",
        "question": "In accordance with the EnerGuide Rating System Code of Ethics, a service organisation's marketing approach shall NOT use the EnerGuide Rating System for which of the following activities?",
        "answer_1": "To improve the EnerGuide Rating System's professional integrity. ",
        "exam": "EA",
        "source": "Administrative Procedures, Appendix B.",
        "answer_2": "To promote the EnerGuide Rating System to new home builders. ",
        "answer_3": "To promote the EnerGuide Rating System to home contractors. ",
        "correctAnswer": "To endorse another organisation's particular product of service. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "A house with a gas-fired, sealed combustion, direct vented furnace and a wood burning stove. ",
        "question": "Which of the following house configuration scenarios would NOT require the performance of the exhaust depressurisation test procedure?",
        "answer_1": "A house with an oil-fired furnace, manufactured in 1989, and electric water heater. ",
        "exam": "MAIN",
        "source": "Technical Procedures, 3.3.1",
        "answer_2": "A house with a gas-fired, sealed combustion, direct vented furnace and electric water heater. ",
        "answer_3": "A house with a naturally aspirated furnace and an induced draft fan water heater. ",
        "correctAnswer": "A house with a gas-fired, sealed combustion, direct vented furnace and electric water heater. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Mechanical draft created by a device downstream from the combustion zone of an appliance. ",
        "question": "Which of the following BEST describes forced-draft venting of fuel-fired appliances?",
        "answer_1": "Draft created by a mechanical device that may supplement natural draft. ",
        "exam": "MAIN",
        "source": "n/a",
        "answer_2": "Draft created by a chimney's height and the temperature difference of the flue gases and the outside. ",
        "answer_3": "Mechanical draft created by a device upstream from the combustion zone of an appliance. ",
        "correctAnswer": "Mechanical draft created by a device upstream from the combustion zone of an appliance. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "Threshold ",
        "question": "Which of the following is NOT a window component?",
        "answer_1": "Sash ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.176",
        "answer_2": "Sill ",
        "answer_3": "Muntin ",
        "correctAnswer": "Threshold "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "540 cubic metres ",
        "question": "The inside dimensions of a one-storey house with a full basement are 6m x 10m. The basement is 2.7m high from the floor to the underside of the joists. The first floor structure of open web wood joists totals 0.3m in height. The long walls of the main floor are 3m high, and they support a full length cathedral ceiling with a 12:12 pitch and two equal slopes. What is the approximate heated volume of the house?",
        "answer_1": "414 cubic metres ",
        "exam": "MAIN",
        "source": "None",
        "answer_2": "432 cubic metres ",
        "answer_3": "450 cubic metres ",
        "correctAnswer": "540 cubic metres "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Watertightness",
        "question_image": "No Image",
        "answer_4": "Cleaning a 12 square meter ceramic tile floor area with hot water and soap twice a week. ",
        "question": "Which of the following is usually the largest contributor of moisture in a home with an average family of four over a typical 7 day period?",
        "answer_1": "Each person taking one average length shower per day. ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.18",
        "answer_2": "Cooking three meals a day. ",
        "answer_3": "Respiration and perspiration ",
        "correctAnswer": "Respiration and perspiration "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "10.4\' ",
        "question": "What is the diameter of a circular flue with the same area as a 9\' x 9\' square flue?",
        "answer_1": "5.1\' ",
        "exam": "MAIN",
        "source": "None",
        "answer_2": "6.8\' ",
        "answer_3": "10.2\' ",
        "correctAnswer": "5.1\' "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "Tilt and turn ",
        "question": "Which of the following operable window types is the most prone to air leakage?",
        "answer_1": "Single-hung ",
        "exam": "MAIN",
        "source": "CMHC-Canadian-Wood-Frame-House-Construction, p.176",
        "answer_2": "Casement ",
        "answer_3": "Hopper ",
        "correctAnswer": "Single-hung "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Insulation",
        "question_image": "No Image",
        "answer_4": "Mineral fibre (loose fill) ",
        "question": "For keeping heat in, which of the following materials requires air space on the warm side?",
        "answer_1": "Spray foam insulation ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.27",
        "answer_2": "Radiant barrier ",
        "answer_3": "Extruded Polystyrene ",
        "correctAnswer": "Radiant barrier "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Watertightness",
        "question_image": "No Image",
        "answer_4": "Transport of moisture laden air through the building materials from an area of high air pressure to an area of low air pressure. ",
        "question": "Which of the following scenarios will allow the greatest amount of moisture to enter the building structure and potencially cause moisture-related damage to the building envelope assemblies?",
        "answer_1": "Movement of moisture in the vapour state through building materials as a result of a vapour pressure difference across the materials. ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.12",
        "answer_2": "Movement of moisture in the vapour state through the building materials as a result of a temperature difference between the inside and outside. ",
        "answer_3": "Transport of moisture laden air through the building materials from an area of low air pressure to an area of high air pressure. ",
        "correctAnswer": "Movement of moisture in the vapour state through building materials as a result of a vapour pressure difference across the materials. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "Enter a user specified value without a justification. ",
        "question": "How should an attic be modelled if there is a significant variation in the insulation levels or types?",
        "answer_1": "Model as two separate attics. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.3.2",
        "answer_2": "Calculate an average insulation level. ",
        "answer_3": "Enter a user specified value and add a justification. ",
        "correctAnswer": "Model as two separate attics. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Insulation",
        "question_image": "No Image",
        "answer_4": "EPS generally has a higher R value. ",
        "question": "What is the difference between XPS and EPS rigid foam boards?",
        "answer_1": "XPS is always blue, and EPS is always white. ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.25-26",
        "answer_2": "EPS is solid rigid board. XPS is made up of little white balls. ",
        "answer_3": "XPS is solid rigid board. EPS is made up of little white balls. ",
        "correctAnswer": "XPS is solid rigid board. EPS is made up of little white balls. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Renovation Upgrade Service",
        "question_image": "No Image",
        "answer_4": "Determine the homeowner's financial considerations, provide personalised advice for each proposed upgrade, and provide a label showing the rating of the house if all upgrade recommendations are implemented. ",
        "question": "Which of the following steps must be a part of the Renovation Upgrade Service?",
        "answer_1": "Use the Basic Service evaluation as a base, locate air leakage locations, and develop upgrade recommendations that include the installation of new windows. ",
        "exam": "EA",
        "source": "Standard, 6.1",
        "answer_2": "Acquire the homeowner's renovation plans, consider the house-as-a-system when developing upgrade recommendations, and include standard comments for each upgrade recommendation. ",
        "answer_3": "Use the Basic Service evaluation as a base, consider the mechanical systems, and model the recommended upgrades. ",
        "correctAnswer": "Determine the homeowner's financial considerations, provide personalised advice for each proposed upgrade, and provide a label showing the rating of the house if all upgrade recommendations are implemented. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "Surface area (square feet) x Temp. difference (Fahrenheit) divided by U-factor ",
        "question": "How do you calculate heat flow through a surface?",
        "answer_1": "Surface area (square metres) x Temp. difference (Celcius) multiplied by U-factor ",
        "exam": "MAIN",
        "source": "http://energy-models.com/heat-transfer",
        "answer_2": "Surface area (square feet) x Temp. difference (Fahrenheit) multiplied by U-factor ",
        "answer_3": "Surface area (square metres) x Temp. difference (Celcius) divided by U-factor ",
        "correctAnswer": "Surface area (square feet) x Temp. difference (Fahrenheit) multiplied by U-factor "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "A blower door zone refers to all areas of the house building, including attached unconditioned areas like the attic and garage. ",
        "question": "What is a blower door zone?",
        "answer_1": "A blower door zone refers to all the parts of the house that are accessible from at least one exterior door. ",
        "exam": "MAIN",
        "source": "Technical Procedures, 7.5",
        "answer_2": "A blower door zone is the door in which the blower door test fan is housed for the duration of the test. ",
        "answer_3": "A blower door zone refers to the parts of the house on the above grade floors, with the basement doors closed. ",
        "correctAnswer": "A blower door zone refers to all the parts of the house that are accessible from at least one exterior door. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "Open a window to connect all three zones. ",
        "question": "How do you conduct a 3 zone one fan test?",
        "answer_1": "Run a hose to each of the other zones. Connect each hose to a single manometer. Repeat in all three zones. ",
        "exam": "MAIN",
        "source": "Technical Procedures, 7.6.5.1",
        "answer_2": "Conduct three separate tests, one on each zone. ",
        "answer_3": "Run a hose to each of the other zones. Connect each hose to separate manometers. Repeat in all three zones. ",
        "correctAnswer": "Run a hose to each of the other zones. Connect each hose to a single manometer. Repeat in all three zones. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "Solar should only be modelled as the primary water heater in a zero-rated home. ",
        "question": "How do you model an oil water heater if there is also a solar water heater present?",
        "answer_1": "Fossil fuel burning water heaters should always be modelled as the primary water heater. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.15.2",
        "answer_2": "Solar is always modelled as the primary. ",
        "answer_3": "Solar is always modelled as the secondary. ",
        "correctAnswer": "Solar is always modelled as the primary. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "Residential portions of mixed use buildings are always eligible for the EnerGuide Rating System. ",
        "question": "What is the split between residential and mixed use in order to be eligible for the EnerGuide Rating System?",
        "answer_1": "The combined total floor area of the non-residential portion of the building must be LESS than that of the residential portion, AND not exceed more than 300 square metres (3229 sq ft). ",
        "exam": "EA",
        "source": "Standard, 1.2.1",
        "answer_2": "The combined total floor area of the non-residential portion of the building must be MORE than that of the residential portion, AND not exceed more than 300 square metres (3229 sq ft). ",
        "answer_3": "Residential portions of mixed use buildings are never eligible for the EnerGuide Rating System. ",
        "correctAnswer": "The combined total floor area of the non-residential portion of the building must be LESS than that of the residential portion, AND not exceed more than 300 square metres (3229 sq ft). "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Air Conditioners",
        "question_image": "No Image",
        "answer_4": "The SEER rating. ",
        "question": "What data collection is required for window AC units?",
        "answer_1": "The same data that is required for all AC units. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.2.9",
        "answer_2": "The total number present. ",
        "answer_3": "The make and model number only. ",
        "correctAnswer": "The total number present. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "Measure the glazing and add 6\' to the height and width. Indicate on the DCF that they were measured from the inside. ",
        "question": "How do you measure a window from the inside?",
        "answer_1": "Measure the glazing and add 3\' to the height and width. Indicate on the DCF that they were measured from the inside. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.7.1",
        "answer_2": "Measure the height and width to the outside of the trim. ",
        "answer_3": "Measure the glazing and add 3\' to the height and width. Do not indicate on the DCF that they were measured from the inside. ",
        "correctAnswer": "Measure the glazing and add 3\' to the height and width. Indicate on the DCF that they were measured from the inside. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "6400 cubic feet ",
        "question": "Calculate the attic volume if the house is 20'x40' and the attic is 8' at it's peak.",
        "answer_1": "1600 cubic feet ",
        "exam": "MAIN",
        "source": "None",
        "answer_2": "3200 cubic feet ",
        "answer_3": "4800 cubic feet ",
        "correctAnswer": "3200 cubic feet "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Data Collection",
        "question_image": "No Image",
        "answer_4": "To within 4\' ",
        "question": "How accurate must the ceiling height measurement be?",
        "answer_1": "To within 1\' ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.4.4",
        "answer_2": "To within 2\' ",
        "answer_3": "To within 3\' ",
        "correctAnswer": "To within 1\' "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "Inform the homeowner of the presence of vermiculite and explain that it could contain asbestos. Advise that they remove the vermiculite immediately themselves. ",
        "question": "What are the steps in informing the homeowner of the presence of vermiculite?",
        "answer_1": "Inform the homeowner of the presence of vermiculite and explain that it could contain asbestos. Advise that they do not touch or disturb the vermiculite, and to contact their local health authority. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.1.2",
        "answer_2": "Inform the homeowner of the presence of vermiculite and but explain that they should not worry because most vermiculite does not contain asbestos. ",
        "answer_3": "Inform the homeowner of the presence of vermiculite and explain that it could contain asbestos. Advise that they do not touch or disturb the vermiculite, and to contact their local health authority. Encourage them to consult the Government of Canada web page on the Health Risks of Asbestos. ",
        "correctAnswer": "Inform the homeowner of the presence of vermiculite and explain that it could contain asbestos. Advise that they do not touch or disturb the vermiculite, and to contact their local health authority. Encourage them to consult the Government of Canada web page on the Health Risks of Asbestos. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "If the crawl space is uninsulated. ",
        "question": "What is the only time an open crawl space can be modelled as an exposed floor?",
        "answer_1": "It shoul always be modelled as an exposed floor. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.6",
        "answer_2": "When there are multiple foundation types. ",
        "answer_3": "If the open crawl space is the only foundation type. ",
        "correctAnswer": "When there are multiple foundation types. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Unit Conversions",
        "question_image": "No Image",
        "answer_4": "37.8 L ",
        "question": "How many litres are there in 1 gallon?",
        "answer_1": "3.78 L ",
        "exam": "EA",
        "source": "None",
        "answer_2": "0.26 L ",
        "answer_3": "4 L ",
        "correctAnswer": "3.78 L "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Airtightness",
        "question_image": "No Image",
        "answer_4": "Indicates how airtight the home is overall. ",
        "question": "What does the correlation coefficient \'r\' indicate?",
        "answer_1": "Indicates the number and size of holes. ",
        "exam": "EA",
        "source": "Technical Procedures, 7.6.10.2",
        "answer_2": "Indicates the reliability of the test results. (must be greater than 0.99) ",
        "answer_3": "Indicates the reliability of the test results. (must be less than 0.99) ",
        "correctAnswer": "Indicates the reliability of the test results. (must be greater than 0.99) "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "It should not be set. ",
        "question": "When the thermostat is set to 'on' in the house, how must it be modelled in HOT2000?",
        "answer_1": "It should always be left as default. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.3",
        "answer_2": "It should be set to 'Heat' ",
        "answer_3": "It should be set to 'On' ",
        "correctAnswer": "It should always be left as default. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "JPEG Photo, pdf file and the report generator. ",
        "question": "What is needed in order to generate the Homeowner Information Sheet?",
        "answer_1": "JPEG Photo, h2k file and the report generator. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 8.",
        "answer_2": "PNG Photo, h2k file and the report generator. ",
        "answer_3": "JPEG Photo, txt file and the report generator. ",
        "correctAnswer": "JPEG Photo, h2k file and the report generator. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Domestic Hot Water",
        "question_image": "No Image",
        "answer_4": "Standby heat loss, thermal efficiency and input capacity. ",
        "question": "If 'standby' is checked in HOT2000 for the Domestic Hot Water (because it does not have an EF), what data must be collected?",
        "answer_1": "No additional data is required. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.15.1",
        "answer_2": "Standby heat loss only. ",
        "answer_3": "The size of the tank. ",
        "correctAnswer": "Standby heat loss, thermal efficiency and input capacity. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Domestic Hot Water",
        "question_image": "No Image",
        "answer_4": "The material the system is made of. ",
        "question": "What data must be collected in order to model a Drain Water Heat Recovery system?",
        "answer_1": "Manufacturer, model and heating capacity only. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.15.3",
        "answer_2": "Manufacturer and model number; If unknown, collect the length of the unit and configuration. ",
        "answer_3": "The efficiency of the system. ",
        "correctAnswer": "Manufacturer and model number; If unknown, collect the length of the unit and configuration. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "The reference house reflects the house being rated using the collected household operating conditions. ",
        "question": "What is the 'new house reference point' reflecting?",
        "answer_1": "The reference house reflects the house being rated as if all recommended upgrades have been completed. ",
        "exam": "EA",
        "source": "Standard, 5.3",
        "answer_2": "The reference house reflects the house being rated as if it were built today using the energy requirements of the building code. ",
        "answer_3": "The reference house reflects the house being rated under standard operating conditions. ",
        "correctAnswer": "The reference house reflects the house being rated as if it were built today using the energy requirements of the building code. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "\u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 determined at the exterior extremities of the walls surrounding the heated and unheated volume. ",
        "question": "The geometry (footprint) of a house can initially be estimated by HOT2000 by specifying the \u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 of the house footprint. How should the \u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 be determined?",
        "answer_1": "\u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 determined at the interior extremities of the walls surrounding the heated volume; ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 6.1.1",
        "answer_2": "\u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 determined at the exterior extremities of the walls surrounding the heated volume; ",
        "answer_3": "\u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 determined at the interior extremities of the walls surrounding the heated and unheated volume; ",
        "correctAnswer": "\u201cWidth/Depth\u201d or \u201cPerimeter/Area\u2019\u2019 determined at the exterior extremities of the walls surrounding the heated volume; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "Calculate the weighted average efficiency and total the heating capacities. ",
        "question": "How do you model 2 boilers (or furnaces) that have the same energy source?",
        "answer_1": "Model as a combination heating system. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.10.3",
        "answer_2": "Model one as the primary heating system and the other as a supplementary heating system. ",
        "answer_3": "Model as two separate boilers. ",
        "correctAnswer": "Calculate the weighted average efficiency and total the heating capacities. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Data Collection",
        "question_image": "No Image",
        "answer_4": "Geometry sketches and building plans do not need to be extremely detailed because their main purpose is to provide a general idea to a third party about the house geometry. ",
        "question": "How and why should an Energy Advisor create geometry sketches and building plans? ",
        "answer_1": "Geometry sketches and building plans are not mandatory and the Energy Advisor can proceed with the EnerGuide Rating System procedure without them; ",
        "exam": "EA",
        "source": "Technical Procedures, 2.8",
        "answer_2": "Geometry sketches and building plans must be clear, complete and sufficiently detailed in order for a third party to recreate the house geometry calculations; ",
        "answer_3": "Geometry sketches and building plans must be drawn by a third-party specialist to document the house shape for NRCan; ",
        "correctAnswer": "Geometry sketches and building plans must be clear, complete and sufficiently detailed in order for a third party to recreate the house geometry calculations; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "Yes, as long as the building contains between 2 and 100 units. ",
        "question": "Is a 4 storey MURB eligible to receive an EnerGudie Rating?",
        "answer_1": "No. MURBs must meet all house criteria, plus additional criteria. ",
        "exam": "EA",
        "source": "Standard, 1.2.1",
        "answer_2": "No. MURBs are never eligible. ",
        "answer_3": "Yes, as long as only 3 storey's are fully above grade. ",
        "correctAnswer": "No. MURBs must meet all house criteria, plus additional criteria. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "Provide proof of a Criminal Record Check to the service organization\u2019s manager. ",
        "question": "An energy advisor must be affiliated with a licensed service organization and registered with Natural Resources Canada prior to offering EnerGuide Rating System services. Among the following, what is not relevant to the registration requirement for the energy advisor candidate? ",
        "answer_1": "Demonstrate proficiency by passing the Foundation Level Exam, Energy Advisor Exam; ",
        "exam": "EA",
        "source": "Administrative Procedures, 4.2.5",
        "answer_2": "Provide proof of possession of a home warranty number or its provincial/territorial equivalent to the service organization(s);  ",
        "answer_3": "Complete probationary files to the satisfaction of the service organization\u2019s quality assurance specialist; ",
        "correctAnswer": "Provide proof of possession of a home warranty number or its provincial/territorial equivalent to the service organization(s);  "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "Clearing leaves from the eavestroughs. ",
        "question": "How can ice damming be minimized?",
        "answer_1": "Air sealing the upper ceiling and insulating the attic. ",
        "exam": "MAIN",
        "source": "Keeping The Heat In Ch.5.5",
        "answer_2": "Air sealing the upper ceiling. ",
        "answer_3": "Insulating the attic. ",
        "correctAnswer": "Air sealing the upper ceiling and insulating the attic. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "All of the above. ",
        "question": "When can you use 'User Specified' for modelling basements?",
        "answer_1": "For double stud walls ",
        "exam": "EA",
        "source": "Technical Procedures, 2.7.7",
        "answer_2": "For sub-slab insulation. ",
        "answer_3": "For exterior foundation wall insulation. ",
        "correctAnswer": "All of the above. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "Drywall ",
        "question": "When a garage ceiling has gypsum on it, what is modelled in the exterior drop down menu?",
        "answer_1": "Gypsum ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 67.8",
        "answer_2": "Wood Lapped ",
        "answer_3": "Lath and Plaster ",
        "correctAnswer": "Wood Lapped "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "The area of the diffuser converted to a height and width. ",
        "question": "What data must be collected for tubular daylight devices?",
        "answer_1": "The height of the shaft only. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.7.1",
        "answer_2": "The area of the diffuser and the height of the shaft. ",
        "answer_3": "The area of the diffuser only. ",
        "correctAnswer": "The area of the diffuser converted to a height and width. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "NRCan regulates it's own privacy of information. ",
        "question": "How is the privacy of information controlled for government?",
        "answer_1": "The Privacy Act. ",
        "exam": "EA",
        "source": "Administrative Procedures, Appendix A.",
        "answer_2": "PIPEDA ",
        "answer_3": "Provincial Laws ",
        "correctAnswer": "The Privacy Act. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "What happens to relative humidity if the temperature decreases?",
        "answer_1": "Relative humidity level will increase. ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.12",
        "answer_2": "Relative humidity level will decrease. ",
        "answer_3": "Relative humidity will not change. ",
        "correctAnswer": "Relative humidity level will increase. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Roofs",
        "question_image": "No Image",
        "answer_4": "To calculate the surface area in the attic. ",
        "question": "Why do we need to measure eave length on hip and gable roofs?",
        "answer_1": "To calculate the volume of the attic. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.3.3",
        "answer_2": "To account for compression in these areas when calculating effective R value in the attic. ",
        "answer_3": "To know how much insulation to recommend the homeowner adds. ",
        "correctAnswer": "To account for compression in these areas when calculating effective R value in the attic. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "Only the lighting load should ever be altered. ",
        "question": "What base loads can be modified in a Basic Service?",
        "answer_1": "None, base loads should be left as default. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.12",
        "answer_2": "Base loads should be updated to reflect the number of occupants in the home. ",
        "answer_3": "Estimated Hot Water Load and Electrical Appliances should be updated to reflect the presence of a hot tub or pool. ",
        "correctAnswer": "None, base loads should be left as default. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "How is a non-condensing tankless water heater used as a Combo-system, with no secondary tank modelled?",
        "answer_1": "Combo-heater with induced draft fan. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.7.1",
        "answer_2": "Combo-heater w/continuous pilot ",
        "answer_3": "Combo-heater w/vent damper. ",
        "correctAnswer": "Combo-heater with induced draft fan. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "Provincial private sector laws only apply in British Columbia and Alberta. ",
        "question": "How is the privacy of information controlled for a business?",
        "answer_1": "PIPEDA, even if the business is overseen by the govornment. ",
        "exam": "EA",
        "source": "Administrative Procedures, Appendix A.",
        "answer_2": "PIPEDA, unless the business is overseen by the govornment. ",
        "answer_3": "All provinces and territories have their own private sector laws. These laws would apply. ",
        "correctAnswer": "PIPEDA, even if the business is overseen by the govornment. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Heating Systems",
        "question_image": "No Image",
        "answer_4": "A sum of heating efficiency. a sum of cooling efficiency, and a sum of their capacities. ",
        "question": "How are efficiency and capacities of multiple air source heat pumps modelled?",
        "answer_1": "A weighted average of heating efficiency. a weighted average of cooling efficiency, and a sum of their capacities. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.10.3",
        "answer_2": "A sum of heating efficiency. a weighted average of cooling efficiency, and a sum of their capacities. ",
        "answer_3": "A weighted average of heating efficiency. a weighted average of cooling efficiency, and a weighted average of their capacities. ",
        "correctAnswer": "A weighted average of heating efficiency. a weighted average of cooling efficiency, and a sum of their capacities. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Insulation",
        "question_image": "No Image",
        "answer_4": "30.72 ",
        "question": "What is the R value of 7\' of cellulose?",
        "answer_1": "3.56 ",
        "exam": "MAIN",
        "source": "Keeping The Heat In p.28",
        "answer_2": "4.38 ",
        "answer_3": "24.92 ",
        "correctAnswer": "24.92 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "In the justifications screen. ",
        "question": "Where does an air source heap pump or central ac AHRI# get entered in HOT2000?",
        "answer_1": "In the AHRI field. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.14.9.1",
        "answer_2": "In the manufacturer field with AHRI before the number. ",
        "answer_3": "In the model number field with AHRI before the number. ",
        "correctAnswer": "In the manufacturer field with AHRI before the number. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Foundations",
        "question_image": "No Image",
        "answer_4": "Only define the attachment length if the attachment length amounts to more than 50% of the total foundation perimeter. ",
        "question": "What method is used to model multiple foundations?",
        "answer_1": "Define the attachment using the 'Exposed Surfaces Perimeter' method. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.9.4",
        "answer_2": "Define the attachment using the 'Attachment List' method. ",
        "answer_3": "Model as two foundations without defining the attachment length. ",
        "correctAnswer": "Define the attachment using the 'Exposed Surfaces Perimeter' method. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Exposed Floors",
        "question_image": "No Image",
        "answer_4": "Distance of the inside surface of the farthest outside wall to the outside surface of the exterior wall below the exposed floor. ",
        "question": "How do we measure the area of exposed floors?",
        "answer_1": "Distance of the inside surface of the farthest outside wall to the inside surface of the interior wall below the exposed floor. ",
        "exam": "MAIN",
        "source": "Technical Procedures, 3.5.6.2",
        "answer_2": "Distance of the outside surface of the farthest outside wall to the inside surface of the exterior wall below the exposed floor. ",
        "answer_3": "Distance of the inside surface of the farthest outside wall to the inside surface of the exterior wall below the exposed floor. ",
        "correctAnswer": "Distance of the inside surface of the farthest outside wall to the inside surface of the exterior wall below the exposed floor. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Foundations",
        "question_image": "No Image",
        "answer_4": "100% ",
        "question": "What portion (as a percentage) of the basement ceiling must be drywalled in order to model the drywall?",
        "answer_1": "25% ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.8.1",
        "answer_2": "50%` ",
        "answer_3": "75% ",
        "correctAnswer": "50%` "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "925 sq m ",
        "question": "Calculate the interior area given a 1' perimeter wall.",
        "answer_1": "779 sq ft ",
        "exam": "MAIN",
        "source": "None",
        "answer_2": "779 cu ft ",
        "answer_3": "925 sq ft ",
        "correctAnswer": "779 sq ft "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "11.28 m ",
        "question": "What is the diameter of a circle that has the same area as a 100 sq ft square?",
        "answer_1": "5.64 ft ",
        "exam": "MAIN",
        "source": "None",
        "answer_2": "11.28 ft ",
        "answer_3": "5.64 m ",
        "correctAnswer": "11.28 ft "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "Surface area (square feet) x Temp. difference (Fahrenheit) divided by R-value ",
        "question": "How do you calculate heat loss through a surface?",
        "answer_1": "Surface area (square feet) x Temp. difference (celcius) divided by R-value ",
        "exam": "MAIN",
        "source": "https://www.e-education.psu.edu/egee102/node/2070#:~:text=Heat%20loss%20from%20the%20walls%3A,wall%20needs%20to%20be%20calculated.&text=Total%20heat%20loss%20from%20the,116.99%20million%20BTUs%20per%20year.",
        "answer_2": "Surface area (square metres) x Temp. difference (celcius) divided by R-value ",
        "answer_3": "Surface area (square metres) x Temp. difference (Fahrenheit divided by R-value ",
        "correctAnswer": "Surface area (square feet) x Temp. difference (Fahrenheit) divided by R-value "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Administrative Procedures",
        "question_image": "No Image",
        "answer_4": "The energy advisor models the house in HOT2000 and saves the calculations as a TXT file. The homeowner converts the house evaluated file to \u201cHomeowner Information Sheet\u201d using the Report Generator and submits it to the energy service organization. ",
        "question": "How/who should be in charge of preparing the HOT2000 file for submission to the service organization?",
        "answer_1": "The energy advisor models the house in HOT2000, saves the calculations as an h2k file and submits the house evaluated file to the energy service organization; ",
        "exam": "EA",
        "source": "Administrative Procedures, 7.2.3",
        "answer_2": "The energy advisor models the house in HOT2000, saves the calculations as an hse file and submits the house evaluated file to the energy service organization; ",
        "answer_3": "The energy advisor models the house in HOT2000 and saves the calculations as an XML file. The homeowner submits the house evaluated file to the energy service organization; ",
        "correctAnswer": "The energy advisor models the house in HOT2000, saves the calculations as an h2k file and submits the house evaluated file to the energy service organization; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "How does the EnerGuide Rating System account for varying numbers of occupants across different homes, to allow the comparison of ratings.",
        "answer_1": "Household Operating Conditions are used. ",
        "exam": "EA",
        "source": "Standard, 3.6.2",
        "answer_2": "Standard Operating Conditions are used. ",
        "answer_3": "The EnerGuide Rating System cannot be used to compare homes. ",
        "correctAnswer": "Standard Operating Conditions are used. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "More information about the home is necessary to assess eligiblity. ",
        "question": "Is a house with 3 storeys above grade, 1 storey below grade, with a building area of 550 sq m, on permanent foundations is eligible for the EnerGuide Rating System",
        "answer_1": "Yes. ",
        "exam": "EA",
        "source": "Standard, 1.2.1",
        "answer_2": "No, the home must not be greater than three storeys in building height. ",
        "answer_3": "No, the home must be at least 600 sq m to be eligible. ",
        "correctAnswer": "More information about the home is necessary to assess eligiblity. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "Required mechanical systems must be on site, except in the case of a heating system failure. ",
        "question": "Which of the following are state-of-home requirements of a house to be rated?",
        "answer_1": "Windows, exterior doors and skylights must be installed and intact, with a maximum of 1 window, 1 exterior door and 1 skylight missing, provided that the openings are temporarily sealed in accordance with the airtightness test. ",
        "exam": "EA",
        "source": "Standard, 1.3",
        "answer_2": "The building envelope must be in a suitable condition for an airtightness test. ",
        "answer_3": "There must be a 120 amp, 15 volt AC power source on site. ",
        "correctAnswer": "The building envelope must be in a suitable condition for an airtightness test. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "None of the above. ",
        "question": "If an EnerGuide Rating System service is withheld, who is responsible for providing the homeowner with a written notification explaining why the service was withheld?",
        "answer_1": "Energy Advisor ",
        "exam": "EA",
        "source": "Technical Procedures, 2.3",
        "answer_2": "Service Organisation ",
        "answer_3": "NRCan ",
        "correctAnswer": "Energy Advisor "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "GJ/sq ft ",
        "question": "What are the units of rated energy intensity?",
        "answer_1": "GJ/sq ft/year ",
        "exam": "EA",
        "source": "Standard, 5.2",
        "answer_2": "GJ/sq m/year ",
        "answer_3": "GJ/sq m ",
        "correctAnswer": "GJ/sq m/year "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Standard Operating Conditions",
        "question_image": "No Image",
        "answer_4": "Cooling to 15C at all times, regardless of if AC is present or not. ",
        "question": "The EnerGuide Rating is calculated assuming which of the following standard thermostat settings?",
        "answer_1": "Heating to 21C during the day and 18C during the night on the main floors, and 19C in the basement. ",
        "exam": "EA",
        "source": "Standard 4.6.2.2",
        "answer_2": "Heating to 21C during the day and 18C during the night on all floors. ",
        "answer_3": "Cooling to 25C at all times, regardless of if AC is present or not. ",
        "correctAnswer": "Heating to 21C during the day and 18C during the night on the main floors, and 19C in the basement. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Insulation",
        "question_image": "No Image",
        "answer_4": "Use the initial R-value only, the EnerGuide Rating System does not account for LTTR. ",
        "question": "How should you determine the long term thermal resistance of closed cell spray foam?",
        "answer_1": "Use the CAN/ULC S770 test data value when available, using linear approximations for half inch values. ",
        "exam": "EA",
        "source": "Technical Procedures, 2.7.3",
        "answer_2": "Use the CAN/ULC S770 test data value when available, using the closest whole inch value. ",
        "answer_3": "Use the CAN/ULC S770 test data value when available, extrapolating the data for thicknesses that exceed the given data. ",
        "correctAnswer": "Use the CAN/ULC S770 test data value when available, using linear approximations for half inch values. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "Direct emissions concern only the emissions of on-site stationary combustion appliances, indirect emissions the total of all greenhouse gas emissions. ",
        "question": "Direct and indirect greenhouse gas emissions are differentiated how?",
        "answer_1": "Direct emissions concern the total of all greenhouse gas emissions, indirect emissions only concern emissions associated with electricity generation at powerplants. ",
        "exam": "EA",
        "source": "Standard, 5.5",
        "answer_2": "Direct emissions concern only the emissions of on-site stationary combustion appliances, indirect emissions only concern emissions associated with electricity generation at powerplants. ",
        "answer_3": "Direct emissions concern the total of all greenhouse gas emissions, indirect emissions only the emissions of on-site stationary combustion appliances ",
        "correctAnswer": "Direct emissions concern only the emissions of on-site stationary combustion appliances, indirect emissions only concern emissions associated with electricity generation at powerplants. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "EnerGuide Rating",
        "question_image": "No Image",
        "answer_4": "False, the heated floor area is the surface area of the footprint of the house. ",
        "question": "The heated floor area is defined as the sum of all floor areas within the building envelope that are partially or fully above grade.",
        "answer_1": "True ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.1.6",
        "answer_2": "False, below-grade floor areas are not included in the calculation. ",
        "answer_3": "False, crawl space floors are not included in the calculation. ",
        "correctAnswer": "False, crawl space floors are not included in the calculation. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Basic Service",
        "question_image": "No Image",
        "answer_4": "Performing an airtightness test. ",
        "question": "Which of the following is NOT a task of the Energy Advisor when performing the Basic Service?",
        "answer_1": "Recording the house dimensions. ",
        "exam": "EA",
        "source": "Technical Procedures, 3.3",
        "answer_2": "Assessing the building envelope components. ",
        "answer_3": "Assessing the structural components of the house construction. ",
        "correctAnswer": "Assessing the structural components of the house construction. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Ventilation",
        "question_image": "No Image",
        "answer_4": "Dryer ",
        "question": "Which of the following do systems need not be assessed as part of the Basic Service?",
        "answer_1": "Heat or Energy Recovery Systems ",
        "exam": "EA",
        "source": "Technical Procedures, 3.5.11",
        "answer_2": "Bathroom Fans ",
        "answer_3": "Range Hood Fans ",
        "correctAnswer": "Dryer "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Renovation Upgrade Service",
        "question_image": "No Image",
        "answer_4": "Model the house and the upgrades in HOT2000 to assess potential reduction in energy consumption. ",
        "question": "What is the first step that an Energy Advisor should start by to initiate the Renovation Upgrade Service of a house?",
        "answer_1": "Determine potential for energy upgrades including those aligned with the planned work; ",
        "exam": "EA",
        "source": "Technical Procedures, 4.2.1",
        "answer_2": "Discuss potential renovation plans and any house-related concerns the homeowner may have; ",
        "answer_3": "Ensure completeness and accuracy of Basic Service information or performing a Basic Service if it has not been performed; ",
        "correctAnswer": "Ensure completeness and accuracy of Basic Service information or performing a Basic Service if it has not been performed; "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Renovation Upgrade Service",
        "question_image": "No Image",
        "answer_4": "All of the above. ",
        "question": "The Renovation Upgrade Report includes which of the following comparators?",
        "answer_1": "The EnerGuide Rating ",
        "exam": "EA",
        "source": "Standard, 6.1.1",
        "answer_2": "The rated house using building code requirements. ",
        "answer_3": "The potential EnerGuide Rating calculated incorporating all the recommended upgrades. ",
        "correctAnswer": "All of the above. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Blower Door Tests",
        "question_image": "No Image",
        "answer_4": "Two zones - three fans - one test ",
        "question": "In the case where the number of blower door zones is two and the number of blower door fans is three, which of the following procedures should be followed for the airtightness test.",
        "answer_1": "Two zones - two fans - one test ",
        "exam": "EA",
        "source": "Technical Procedures, 7.5",
        "answer_2": "Two zones - two fans - two tests ",
        "answer_3": "Two zones - two fans - three tests ",
        "correctAnswer": "Two zones - two fans - two tests "
    },
    {
        "question_type": "Multiple Choice",
        "category": "House Wizard",
        "question_image": "No Image",
        "answer_4": "House volume. ",
        "question": "Which of the following fields cannot be found in the House Wizard Main House Selectors screen?",
        "answer_1": "Front orientation ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 6.1.1",
        "answer_2": "Number of floors. ",
        "answer_3": "Ceiling type ",
        "correctAnswer": "House volume. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Windows",
        "question_image": "No Image",
        "answer_4": "All of the above. ",
        "question": "Which of the following should be modelled as windows in HOT2000?",
        "answer_1": "Skylights ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.6",
        "answer_2": "Glass Blocks ",
        "answer_3": "Sliding Glass Doors ",
        "correctAnswer": "All of the above. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "HOT2000",
        "question_image": "No Image",
        "answer_4": "To indicate that there is underfloor heating present. ",
        "question": "Which of the following is NOT a valid reason to change the values/selections in the Temperatures screen?",
        "answer_1": "To indicate that AC ductwork serves the basement. ",
        "exam": "EA",
        "source": "HOT2000 User Guide, 7.10",
        "answer_2": "To indicate a crawl space is heater. ",
        "answer_3": "To indicate that a MURB single unit is a Basement Unit. ",
        "correctAnswer": "To indicate that there is underfloor heating present. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "3.15 ",
        "question": "Which of the following is 3.14159 rounded to 2 significant figures?",
        "answer_1": "3.1 ",
        "exam": "MAIN",
        "source": "None.",
        "answer_2": "3.2 ",
        "answer_3": "3.14 ",
        "correctAnswer": "3.1 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "3.142 ",
        "question": "Which of the following is 3.14159 rounded to 3 decimal places?",
        "answer_1": "3.14 ",
        "exam": "MAIN",
        "source": "None.",
        "answer_2": "3.15 ",
        "answer_3": "3.141 ",
        "correctAnswer": "3.142 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "Cannot say, we need more information. ",
        "question": "Calculate the area of a square with side length 5.",
        "answer_1": "25 units. ",
        "exam": "MAIN",
        "source": "None.",
        "answer_2": "25 square units. ",
        "answer_3": "25 cubic units. ",
        "correctAnswer": "25 square units. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "Cannot say, we need more information. ",
        "question": "Which of the following is the correct volume of a cube with side length 5.",
        "answer_1": "5 cubic units. ",
        "exam": "MAIN",
        "source": "None.",
        "answer_2": "25 cubic units. ",
        "answer_3": "125 cubic units. ",
        "correctAnswer": "125 cubic units. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "Cannot say, we need more information. ",
        "question": "Calculate the perimeter of a square with side length 5.",
        "answer_1": "5 units. ",
        "exam": "MAIN",
        "source": "None.",
        "answer_2": "25 square units. ",
        "answer_3": "20 units. ",
        "correctAnswer": "20 units. "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "49.74 ",
        "question": "Calculate the circumference of a circle that has the same area as a square of side length 5, correct to 2 decimal places.",
        "answer_1": "17.72 ",
        "exam": "EA",
        "source": "None.",
        "answer_2": "17.73 ",
        "answer_3": "49.73 ",
        "correctAnswer": "17.72 "
    },
    {
        "question_type": "Multiple Choice",
        "category": "Math",
        "question_image": "No Image",
        "answer_4": "arcsin(1.67) ",
        "question": "Given the two shortest sides of a right angled triangle are 3 units and 5 units, which expression will give the size of the smallest angle in the triangle.",
        "answer_1": "arctan(0.6) ",
        "exam": "EA",
        "source": "None.",
        "answer_2": "arctan(1.67) ",
        "answer_3": "arcsin(0.6) ",
        "correctAnswer": "arctan(0.6) "
    }
]
''';