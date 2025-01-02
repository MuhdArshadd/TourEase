import 'package:flutter/material.dart';
import 'dart:typed_data';

class BusinessHour {
  bool isOpen;
  TimeOfDay openTime;
  TimeOfDay closeTime;
  bool is24Hours; // New property for 24 hours option

  BusinessHour({
    this.isOpen = false,
    this.is24Hours = false, // Initialize is24Hours
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
  })  : openTime = openTime ?? const TimeOfDay(hour: 9, minute: 0),
        closeTime = closeTime ?? const TimeOfDay(hour: 17, minute: 0);
}

class BusinessInfo {
  String businessName;
  String businessCategory;
  String streetAddress;
  String accessibility;
  String planning;
  String children;
  String postTown;
  String postCode;
  Map<String, BusinessHour> businessHours;
  Uint8List? businessPhoto;
  double? latitude; // New property for latitude
  double? longitude; // New property for longitude

  BusinessInfo({
    this.businessName = '',
    this.businessCategory = '',
    this.streetAddress = '',
    this.accessibility = '',
    this.planning = '',
    this.children = '',
    this.postTown = '',
    this.postCode = '',
    Map<String, BusinessHour>? businessHours,
    this.businessPhoto,
    this.latitude,
    this.longitude,
  }) : businessHours = businessHours ??
      {
        "Sunday": BusinessHour(),
        "Monday": BusinessHour(),
        "Tuesday": BusinessHour(),
        "Wednesday": BusinessHour(),
        "Thursday": BusinessHour(),
        "Friday": BusinessHour(),
        "Saturday": BusinessHour(),
      };
}
