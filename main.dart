import 'package:flutter/material.dart';

import 'calculator.dart';

void main() {
  runApp(
      const MaterialApp(
        title: 'My calculator',
        debugShowCheckedModeBanner: false,
        home: CalculatorApp(),
  ),
  );
}