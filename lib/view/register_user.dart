import 'package:flutter/material.dart';
import 'home_page.dart';

import 'package:TourEase/Controller/security_questions.dart'; //import the security question controller
import 'package:TourEase/Controller/user_controller.dart'; //import the user controller

class RegisterUserPage extends StatefulWidget {
  //final Function(bool) onLoginChanged;

  //const RegisterUserPage({super.key, required this.onLoginChanged});
  const RegisterUserPage({super.key});

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  String? selectedQuestion; // selected question
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final SecurityController _securityController = SecurityController(); //add the security_controller instance
  Future<List<Map<String, dynamic>>>? securityQuestionsFuture; // to store the questions fetched from the database

  final UserController _userController = UserController(); //add the security_controller instance

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _answerError;
  String? _questionError;

  bool _isPasswordVisible = false; //to toggle password visibility

  @override
  void initState() {
    super.initState();
    // Fetch the security questions when the widget is initialized
    securityQuestionsFuture = _securityController.fetchSecurityQuestions();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Success',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'You have successfully registered',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                    ),*/
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(onLoginChanged: (bool isLoggedIn) {
                              //set login state to false
                              isLoggedIn = false;
                            },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFailureDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 50.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pop(); //Go back to previous page

                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog

                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _register() async {
    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _emailError = null;
      _passwordError = null;
      _answerError = null;
      _questionError = null;
    });

    bool isValid = true;

    if (_firstNameController.text.isEmpty) {
      _firstNameError = 'First Name is required';
      isValid = false;
    }
    if (_lastNameController.text.isEmpty) {
      _lastNameError = 'Last Name is required';
      isValid = false;
    }
    if (_emailController.text.isEmpty) {
      _emailError = 'Email is required';
      isValid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text)) {
      _emailError = 'Enter a valid email';
      isValid = false;
    }
    if (_passwordController.text.isEmpty) {
      _passwordError = 'Password is required';
      isValid = false;
    } else if (_passwordController.text.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
      isValid = false;
    }
    if (selectedQuestion == null) {
      _questionError = 'Please select a security question';
      isValid = false;
    }
    if (_answerController.text.isEmpty) {
      _answerError = 'Answer is required';
      isValid = false;
    }

    //registration process here
    if (isValid) {
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String answer = _answerController.text;
      final String question = selectedQuestion!;
      final int category = 1; // 1 is for public or personal

      bool registrationSuccess = await _userController.registerUser(firstName, lastName, email, password, category, question, answer);

      if(registrationSuccess){
        _showSuccessDialog();
      }
      else {
        _showFailureDialog("There was an issue with your registration. Please try again.");
      }
    } else {
      setState(() {}); // Update UI to show error messages
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Create Personal Account',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff0b036c)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'First Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your first name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorText: _firstNameError, // Show error if any
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Last Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your last name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    errorText: _lastNameError, // Show error if any
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Email',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 70,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    helperText: 'Email must be in the correct format',
                    helperStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff0b036c)
                    ),
                    errorText: _emailError, // Show error if any
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 70,
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, //this will toggle password visible
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    helperText: 'Password must be at least 8 characters',
                    helperStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff0b036c)
                    ),
                    errorText: _passwordError, // Show error if any
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: (){
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Security Question',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_questionError != null)
                Text(
                  _questionError!,
                  style: const TextStyle(color: Colors.red),
                ),
              //Security question start display here
              FutureBuilder<List<Map<String, dynamic>>>(
                future: securityQuestionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loader while waiting
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching questions');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No questions available');
                  } else {
                    List<Map<String, dynamic>> questions = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: questions.map((questionData) {
                        String questionText = questionData['question'];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedQuestion = questionText; // Store the selected question text
                              });
                            },
                            child: Container(
                              width: 180,
                              height: 70,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: selectedQuestion == questionText
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.white,
                                border: Border.all(
                                    color: selectedQuestion == questionText
                                        ? Colors.blue
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                questionText,
                                style: TextStyle(
                                fontSize: 13,
                                color: selectedQuestion == questionText
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              const Text(
                'Answer',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 70,
                child: TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'Enter your answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorText: _answerError,
                    helperText: 'Answer should be case-sensitive',
                    helperStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff0b036c)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0b036c),// Button color
                    padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 140),
                  ),
                  onPressed: _register,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
