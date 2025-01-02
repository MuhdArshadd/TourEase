import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:TourEase/view/business_dashboard.dart';
import 'package:TourEase/view/register_main.dart';
import 'forgot_pass.dart';

import 'package:TourEase/Controller/user_controller.dart';

class LoginPage extends StatefulWidget {
  final Function(bool) onLoginChanged; // Callback for login state

  const LoginPage({super.key, required this.onLoginChanged});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  String? _errorMessage;

  final UserController _userController = UserController(); //add the user_controller instance


  bool _isPasswordVisible = false; //to toggle password visibility

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  /*void _showSuccessDialog() {
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
                  'Successfully login',
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,true);
                        Navigator.pop(context,true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Continue',
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
  }*/

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
                  Icons.close,
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

  void _validateForm() {
    final isValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _formKey.currentState?.validate() == true;

    _isButtonEnabled.value = isValid;
  }

  void _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Call the login method to get the account type (0 = incorrect, 1 = personal, 2 = business)
    int loginResult = await _userController.loginUser(email, password);

    if (loginResult == 2) {
      // If loginResult is 2, it's a personal account
      Navigator.pop(context, true); // Indicate successful login (personal)
    } else if (loginResult == 1) {
      // If loginResult is 1, it's a business account
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BusinessDashboard(), // Navigate to BusinessDashboard
        ),
      );
    } else {
      // If loginResult is 0, the credentials are incorrect
      _showFailureDialog('Failed to login'); // Show a failure dialog
      setState(() {
        _errorMessage = 'Incorrect email or password'; // Display error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: RichText(
                    text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tour',
                            style: TextStyle(
                                color: Color(0xff0b036c),
                                fontWeight: FontWeight.bold,
                                fontSize: 60
                            ),
                          ),
                          TextSpan(
                            text: 'Ease',
                            style: TextStyle(
                              color: Color(0xffe80000),
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter email',
                    border: OutlineInputBorder(),
                    //helperText: 'Email must be in correct format',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, //this will toggle password visible
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    border: const OutlineInputBorder(),
                    //helperText: 'Password must be at least 8 characters',
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
                  //obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return ElevatedButton(
                      onPressed: isEnabled ? _login : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isEnabled ? const Color(0xff0b036c) : Colors.grey, // Button color
                        padding:
                        const EdgeInsets.symmetric(vertical: 10.0,horizontal: 12),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16.0,color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                ),
                if (_errorMessage != null) // Display the error message if any
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 5.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Not registered yet? ',
                      style: const TextStyle(
                          color: Color(0xff636363),
                        fontSize: 13, fontWeight: FontWeight.normal,
                        fontFamily: 'Outfit',
                      ),
                    children: [
                      TextSpan(
                        text: 'Create Account',
                        style: const TextStyle(color: Color(0xff0b038c)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //builder: (context) => RegisterUserPage(onLoginChanged: widget.onLoginChanged)),
                                  builder: (context) => const RegisterMainPage()),
                            );
                            // Navigate to the registration page
                          }
                      )
                    ]
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
