import 'package:flutter/material.dart';
import 'home_page.dart';

import '../dbConnection/dbConnection.dart';
import 'package:postgres/postgres.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? selectedQuestionId;
  List<Map<String, String>> securityQuestions = [];
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  String? _answerError;
  String? _questionError;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    List<Map<String, String>> questions = await getQuestionsFromAzure();
    setState(() {
      securityQuestions = questions;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _forgotPass() {
    setState(() {
      _emailError = null;
      _answerError = null;
      _questionError = null;
    });

    bool isValid = true;

    if (selectedQuestionId == null) {
      _questionError = 'Please select a security question';
      isValid = false;
    }
    if (_emailController.text.isEmpty) {
      _emailError = 'Email is required';
      isValid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
        .hasMatch(_emailController.text)) {
      _emailError = 'Enter a valid email';
      isValid = false;
    }
    if (_answerController.text.isEmpty) {
      _answerError = 'Answer is required';
      isValid = false;
    }

    if (isValid) {
      _checkingAnswer(
          selectedQuestionId!, _answerController.text, _emailController.text);
    }
  }

  Future<List<Map<String, String>>> getQuestionsFromAzure() async {
    final conn = PostgreSQLConnection('Database', 5432, 'db_name',
        username: username, password: password, useSSL: true);
    List<Map<String, String>> questions = [];
    try {
      await conn.open();
      var results = await conn
          .query('SELECT * FROM tbl_security ORDER BY RANDOM() LIMIT 2;');
      for (var row in results) {
        questions.add({'id': row[0].toString(), 'question': row[1]});
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
    return questions;
  }

  void _checkingAnswer(String questionId, String answer, String email) {
    // Add logic here to verify answer and handle further actions
    print(
        'Checking answer for question ID: $questionId, Answer: $answer, Email: $email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Forgot Your Password?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Security Question',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (securityQuestions.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: securityQuestions.map((question) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedQuestionId = question['id'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selectedQuestionId == question['id']
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.white,
                          border: Border.all(
                              color: selectedQuestionId == question['id']
                                  ? Colors.blue
                                  : Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          question['question']!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (_questionError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_questionError!,
                      style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Security Question Answer',
                  hintText: 'Enter your answer',
                  border: OutlineInputBorder(),
                  errorText: _answerError,
                  helperText:
                      'Answer the security question you set during account creation',
                  helperStyle:
                      const TextStyle(fontSize: 12, color: Color(0xff0b036c)),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  errorText: _emailError, // Show error if any
                  helperText: 'Provide the email associated with your account',
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _forgotPass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0b036c),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
