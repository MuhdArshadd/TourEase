import 'package:flutter/foundation.dart';

class LocationState with ChangeNotifier {
  double? _latitude;
  double ?_longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  void setLocation(double latitude,double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }
}
