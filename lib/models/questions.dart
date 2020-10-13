import 'package:EnerQuiz/models/questionsData.dart' show jsonData;
import 'dart:convert';

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