import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_application/models/quiz_model.dart';

class QuizService {
  final String _baseUrl = "http://localhost:8342/test/api"; // Replace with your API URL

  Future<Quiz> createQuiz(Map<String, dynamic> quizData) async {
    // 🔹 Convert Map<String, dynamic> to Quiz object
    Quiz quiz = Quiz.fromJson(quizData);

    //see the json in console
    print("Quiz Json: $quiz");
    final response = await http.post(
      Uri.parse('$_baseUrl/quizzes'),
      headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'},
      body: jsonEncode(quiz.toJson()),
    );

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create quiz');
    }
  }
}

// class QuizService {
//   final String baseUrl = "http://localhost:8342/test/api/quizzes"; // Change this for production

//   Future<Quiz?> createQuiz(Quiz quiz) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(quiz.toJson()), // Convert Quiz to JSON
//     );

//     if (response.statusCode == 201) {
//       return Quiz.fromJson(jsonDecode(response.body)); // Convert JSON to Quiz object
//     } else {
//       return null;
//     }
//   }

//   Future<List<Quiz>> getAllQuizzes() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = jsonDecode(response.body);
//       return jsonList.map((json) => Quiz.fromJson(json)).toList();
//     } else {
//       throw Exception("Failed to load quizzes");
//     }
//   }
// }