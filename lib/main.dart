import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_storage/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationTracker(),
    );
  }
}

