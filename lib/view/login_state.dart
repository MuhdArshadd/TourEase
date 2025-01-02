import 'package:flutter/foundation.dart';

class LoginState with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void updateLoginStatus(bool status) {
    _isLoggedIn = status;
    notifyListeners();
  }
}
