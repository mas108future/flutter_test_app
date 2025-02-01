class Quiz {
  String? id;
  String? title;
  List<Question>? questions;

  Quiz({this.id, this.title, this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions?.map((question) => question.toJson()).toList(),
    };
  }
}

class Question {
  String? id;
  String? text;
  List<String>? options;
  List<String>? correctAnswers;
  bool? isMultipleChoice;

  Question({
    this.id,
    this.text,
    this.options,
    this.correctAnswers,
    this.isMultipleChoice,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswers: List<String>.from(json['correctAnswers']),
      isMultipleChoice: json['isMultipleChoice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctAnswers': correctAnswers,
      'isMultipleChoice': isMultipleChoice,
    };
  }
}