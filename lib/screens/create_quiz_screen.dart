import 'package:flutter/material.dart';
import 'package:test_application/models/quiz_model.dart';
import 'package:test_application/services/quiz_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class CreateQuizScreen extends StatefulWidget {
//   @override
//   _CreateQuizScreenState createState() => _CreateQuizScreenState();
// }

// class _CreateQuizScreenState extends State<CreateQuizScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final QuizService _quizService = QuizService();

//   String _title = '';
//   final List<Question> _questions = [];

//   void _addQuestion() {
//     setState(() {
//       _questions.add(Question(
//         id: DateTime.now().toString(),
//         text: '',
//         options: [],
//         correctAnswers: [],
//         isMultipleChoice: false,
//       ));
//     });
//   }

//   void _submitQuiz() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final quiz = Quiz(
//         title: _title,
//         questions: _questions,
//       );

//       try {
//         await _quizService.createQuiz(quiz);
//         Fluttertoast.showToast(msg: 'Quiz created successfully!');
//       } catch (e) {
//         Fluttertoast.showToast(msg: 'Failed to create quiz: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Quiz'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Quiz Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _title = value!,
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _questions.length,
//                   itemBuilder: (context, index) {
//                     return _buildQuestionCard(_questions[index], index);
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: _addQuestion,
//                 child: Text('Add Question'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitQuiz,
//                 child: Text('Submit Quiz'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuestionCard(Question question, int index) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Question Text'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter question text';
//                 }
//                 return null;
//               },
//               onSaved: (value) => question.text = value!,
//             ),
//             SizedBox(height: 10),
//             ...question.options!.asMap().entries.map((entry) {
//               int optionIndex = entry.key;
//               String option = entry.value;
//               return TextFormField(
//                 decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
//                 onSaved: (value) => question.options![optionIndex] = value!,
//               );
//             }).toList(),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   question.options!.add('');
//                 });
//               },
//               child: Text('Add Option'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//--------------------------------------------------------------------------------------------------------------------------------------------------
class QuizCreatorScreen extends StatefulWidget {
  @override
  _QuizCreatorScreenState createState() => _QuizCreatorScreenState();
}

class _QuizCreatorScreenState extends State<QuizCreatorScreen> {
  final _quizTitleController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  final _formKey = GlobalKey<FormState>();

  void _addQuestion() {
    setState(() {
      _questions.add({
        'text': '',
        'options': ['', '', '', ''],
        'correctAnswers': [],
        'isMultipleChoice': false,
      });
    });
  }

  void _submitQuiz() {
    if (_formKey.currentState!.validate()) {
      final quiz = {
        'title': _quizTitleController.text,
        'questions': _questions,
      };

      // Simulate a backend call (replace with your API integration)
      print('Quiz Created: $quiz');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz successfully created!')),
      );

      // Reset the form
      _quizTitleController.clear();
      setState(() {
        _questions.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Creator')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _quizTitleController,
                decoration: InputDecoration(
                  labelText: 'Quiz Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quiz title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ..._questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return QuestionCard(
                  question: question,
                  onUpdate: (updatedQuestion) {
                    setState(() {
                      _questions[index] = updatedQuestion;
                    });
                  },
                  onDelete: () {
                    setState(() {
                      _questions.removeAt(index);
                    });
                  },
                );
              }),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: Icon(Icons.add),
                label: Text('Add Question'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitQuiz,
                child: Text('Create Quiz'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(Map<String, dynamic>) onUpdate;
  final VoidCallback onDelete;

  const QuestionCard({
    required this.question,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final questionTextController = TextEditingController(text: question['text']);
    final optionsControllers = question['options']
        .map<TextEditingController>((option) => TextEditingController(text: option))
        .toList();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
             controller: questionTextController,
             decoration: InputDecoration(labelText: 'Question Text'),
             textAlign: TextAlign.left,  // Ensure text starts from the left
             textDirection: TextDirection.ltr,  // Force Left-to-Right text flow
             keyboardType: TextInputType.text,  // Ensure proper keyboard type
             onChanged: (value) {
             question['text'] = value;
             onUpdate(question);
             print("Entered text: ${questionTextController.text}");
             },
            ),

            SizedBox(height: 10),
            Text(
              'Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...optionsControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              final optionValue = controller.text;

              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                              controller: controller ,
                              decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                question['options'][index] = value;
                                onUpdate(question);
                              },
                            ),

                  ),
                  Checkbox(
                    value: question['correctAnswers'].contains(optionValue),
                    onChanged: (isChecked) {
                      if (isChecked == true) {
                        question['correctAnswers'].add(optionValue);
                      } else {
                        question['correctAnswers'].remove(optionValue);
                      }
                      onUpdate(question);
                    },
                  ),
                ],
              );
            }),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Multiple Choice',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: question['isMultipleChoice'],
                  onChanged: (value) {
                    question['isMultipleChoice'] = value;
                    onUpdate(question);
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onDelete,
              icon: Icon(Icons.delete),
              label: Text('Delete Question'),
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Corrected from 'primary' to 'backgroundColor'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//----------------------------------------------------2-------------------------------------------------------------
// import 'package:flutter/material.dart';

// class CreateQuizScreen extends StatefulWidget {
//   @override
//   _CreateQuizScreenState createState() => _CreateQuizScreenState();
// }

// class _CreateQuizScreenState extends State<CreateQuizScreen> {
//   final TextEditingController quizTitleController = TextEditingController();
//   List<Map<String, dynamic>> questions = [];

//   @override
//   void dispose() {
//     quizTitleController.dispose();
//     super.dispose();
//   }

//   void addQuestion() {
//     setState(() {
//       questions.add({
//         'text': '',
//         'options': ['', '', '', ''],
//         'correctAnswers': [],
//         'isMultipleChoice': false,
//       });
//     });
//   }

//   void updateQuestion(int index, Map<String, dynamic> updatedQuestion) {
//     setState(() {
//       questions[index] = updatedQuestion;
//     });
//   }

//   void removeQuestion(int index) {
//     setState(() {
//       questions.removeAt(index);
//     });
//   }

//   void saveQuiz() {
//     String title = quizTitleController.text;
//     if (title.isEmpty || questions.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Quiz title and at least one question required")),
//       );
//       return;
//     }

//     Map<String, dynamic> quizData = {
//       'title': title,
//       'questions': questions,
//     };

//     print("Quiz Data: $quizData"); // Replace with API call
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Create Quiz")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: quizTitleController,
//               decoration: InputDecoration(labelText: 'Quiz Title'),
//               textAlign: TextAlign.left,
//               textDirection: TextDirection.ltr,
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: questions.length,
//                 itemBuilder: (context, index) {
//                   return QuestionCard(
//                     key: ValueKey(index),
//                     question: questions[index],
//                     onUpdate: (updatedQuestion) => updateQuestion(index, updatedQuestion),
//                     onDelete: () => removeQuestion(index),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: addQuestion,
//               child: Text("Add Question"),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: saveQuiz,
//               child: Text("Save Quiz"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class QuestionCard extends StatefulWidget {
//   final Map<String, dynamic> question;
//   final Function(Map<String, dynamic>) onUpdate;
//   final VoidCallback onDelete;

//   const QuestionCard({
//     required this.question,
//     required this.onUpdate,
//     required this.onDelete,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _QuestionCardState createState() => _QuestionCardState();
// }

// class _QuestionCardState extends State<QuestionCard> {
//   late TextEditingController questionTextController;

//   @override
//   void initState() {
//     super.initState();
//     questionTextController = TextEditingController(text: widget.question['text']);
//   }

//   @override
//   void dispose() {
//     questionTextController.dispose();
//     super.dispose();
//   }

//   void updateOption(int index, String value) {
//     setState(() {
//       widget.question['options'][index] = value;
//       widget.onUpdate(widget.question);
//     });
//   }

//   void toggleCorrectAnswer(int index) {
//     setState(() {
//       String option = widget.question['options'][index];
//       if (widget.question['correctAnswers'].contains(option)) {
//         widget.question['correctAnswers'].remove(option);
//       } else {
//         widget.question['correctAnswers'].add(option);
//       }
//       widget.onUpdate(widget.question);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: questionTextController,
//               decoration: InputDecoration(labelText: 'Question Text'),
//               textAlign: TextAlign.left,
//               textDirection: TextDirection.ltr,
//               onChanged: (value) {
//                 widget.question['text'] = value;
//                 widget.onUpdate(widget.question);
//               },
//             ),
//             SizedBox(height: 10),
//             Text("Options:", style: TextStyle(fontWeight: FontWeight.bold)),
//             Column(
//               children: List.generate(widget.question['options'].length, (index) {
//                 return Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         initialValue: widget.question['options'][index],
//                         decoration: InputDecoration(labelText: 'Option ${index + 1}'),
//                         textAlign: TextAlign.left,
//                         textDirection: TextDirection.ltr,
//                         onChanged: (value) => updateOption(index, value),
//                       ),
//                     ),
//                     Checkbox(
//                       value: widget.question['correctAnswers'].contains(widget.question['options'][index]),
//                       onChanged: (value) => toggleCorrectAnswer(index),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: widget.onDelete,
//               icon: Icon(Icons.delete),
//               label: Text('Delete Question'),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class CreateQuizScreen extends StatefulWidget {
//   @override
//   _CreateQuizScreenState createState() => _CreateQuizScreenState();
// }

// class _CreateQuizScreenState extends State<CreateQuizScreen> {
//   final TextEditingController quizTitleController = TextEditingController();
//   // List<Map<String, dynamic>> questions = [];
//   final List<Question> questions = [];
//   final QuizService quizService = QuizService();

//   @override
//   void dispose() {
//     quizTitleController.dispose();
//     super.dispose();
//   }

//   // void addQuestion() {
//   //   setState(() {
//   //     questions.add({
//   //       'text': '',
//   //       'options': ['', '', '', ''],
//   //       'correctAnswers': [],
//   //       'isMultipleChoice': false,
//   //     });
//   //   });
//   // }
//   void addQuestion() {
//     setState(() {
//       questions.add(Question(
//         text: "",
//         options: ["", "", "", ""],
//         correctAnswers: [],
//         isMultipleChoice: false,
//       ));
//     });
//   }

//   // void updateQuestion(int index, Map<String, dynamic> updatedQuestion) {
//   //   setState(() {
//   //     questions[index] = updatedQuestion;
//   //   });
//   // }

//   // void removeQuestion(int index) {
//   //   setState(() {
//   //     questions.removeAt(index);
//   //   });
//   // }

// //   void saveQuiz() async {
// //     String title = quizTitleController.text;
// //     if (title.isEmpty || questions.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Quiz title and at least one question required")),
// //       );
// //       return;
// //     }

// //     Map<String, dynamic> quizData = {
// //       'title': title,
// //       'questions': questions,
// //     };

// // print("Quiz Data: $quizData"); // Replace with API call
// //     QuizService quizService = QuizService();
// //   Quiz? savedQuiz = await quizService.createQuiz(quizData);

// //   if (savedQuiz != null) {
// //     print("Quiz Saved: ${savedQuiz.title}");
// //   } else {
// //     print("Failed to save quiz");
// //   }
// //   }

// void saveQuiz() async {
//     if (quizTitleController.text.isEmpty || questions.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Quiz title and at least one question required")),
//       );
//       return;
//     }

//     Quiz quiz = Quiz(title: quizTitleController.text, questions: questions);
//     Quiz? savedQuiz = await quizService.createQuiz(quiz);

//     if (savedQuiz != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Quiz Saved Successfully!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save quiz")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Create Quiz")),
//       body: Center(
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: 500), // Centers content in a readable width
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   TextField(
//                     controller: quizTitleController,
//                     decoration: InputDecoration(labelText: 'Quiz Title'),
//                     textAlign: TextAlign.center,
//                     textDirection: TextDirection.ltr,
//                   ),
//                   SizedBox(height: 20),
//                   // ListView.builder(
//                   //   shrinkWrap: true,
//                   //   physics: NeverScrollableScrollPhysics(),
//                   //   itemCount: questions.length,
//                   //   itemBuilder: (context, index) {
//                   //     return QuestionCard(
//                   //       key: ValueKey(index),
//                   //       question: questions[index],
//                   //       onUpdate: (updatedQuestion) => updateQuestion(index, updatedQuestion),
//                   //       onDelete: () => removeQuestion(index),
//                   //     );
//                   //   },
//                   // ),
//                  ...questions.map((question) => buildQuestionField(question)).toList(),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: addQuestion,
//                   child: Text("Add Question"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: saveQuiz,
//                     child: Text("Save Quiz"),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }


// // class QuestionCard extends StatefulWidget {
// //   final Map<String, dynamic> question;
// //   final Function(Map<String, dynamic>) onUpdate;
// //   final VoidCallback onDelete;

// //   const QuestionCard({
// //     required this.question,
// //     required this.onUpdate,
// //     required this.onDelete,
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   _QuestionCardState createState() => _QuestionCardState();
// // }

// // class _QuestionCardState extends State<QuestionCard> {
// //   late TextEditingController questionTextController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     questionTextController = TextEditingController(text: widget.question['text']);
// //   }

// //   @override
// //   void dispose() {
// //     questionTextController.dispose();
// //     super.dispose();
// //   }

// //   void updateOption(int index, String value) {
// //     setState(() {
// //       widget.question['options'][index] = value;
// //       widget.onUpdate(widget.question);
// //     });
// //   }

// //   void toggleCorrectAnswer(int index) {
// //     setState(() {
// //       String option = widget.question['options'][index];
// //       if (widget.question['correctAnswers'].contains(option)) {
// //         widget.question['correctAnswers'].remove(option);
// //       } else {
// //         widget.question['correctAnswers'].add(option);
// //       }
// //       widget.onUpdate(widget.question);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: EdgeInsets.symmetric(vertical: 10),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             TextFormField(
// //               controller: questionTextController,
// //               decoration: InputDecoration(labelText: 'Question Text'),
// //               textAlign: TextAlign.left,
// //               textDirection: TextDirection.ltr,
// //               onChanged: (value) {
// //                 widget.question['text'] = value;
// //                 widget.onUpdate(widget.question);
// //               },
// //             ),
// //             SizedBox(height: 10),
// //             Text("Options:", style: TextStyle(fontWeight: FontWeight.bold)),
// //             Column(
// //               children: List.generate(widget.question['options'].length, (index) {
// //                 return Row(
// //                   children: [
// //                     Expanded(
// //                       child: TextFormField(
// //                         initialValue: widget.question['options'][index],
// //                         decoration: InputDecoration(labelText: 'Option ${index + 1}'),
// //                         textAlign: TextAlign.left,
// //                         textDirection: TextDirection.ltr,
// //                         onChanged: (value) => updateOption(index, value),
// //                       ),
// //                     ),
// //                     Checkbox(
// //                       value: widget.question['correctAnswers'].contains(widget.question['options'][index]),
// //                       onChanged: (value) => toggleCorrectAnswer(index),
// //                     ),
// //                   ],
// //                 );
// //               }),
// //             ),
// //             SizedBox(height: 10),
// //             ElevatedButton.icon(
// //               onPressed: widget.onDelete,
// //               icon: Icon(Icons.delete),
// //               label: Text('Delete Question'),
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// Widget buildQuestionField(Question question) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               onChanged: (value) => question.text = value,
//               decoration: InputDecoration(labelText: "Question Text"),
//             ),
//             SizedBox(height: 10),
//             Column(
//               children: List.generate(4, (index) {
//                 return TextField(
//                   onChanged: (value) => question.options![index] = value,
//                   decoration: InputDecoration(labelText: "Option ${index + 1}"),
//                 );
//               }),
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 Checkbox(
//                   value: question.isMultipleChoice ?? false,
//                   onChanged: (value) {
//                     setState(() {
//                       question.isMultipleChoice = value ?? false;
//                     });
//                   },
//                 ),
//                 Text("Multiple Choice"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
