import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Add this dependency

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String history = '';
  String output = '0';

  // Evaluates the expression safely
  void calculateResult() {
    try {
      String expression = history + output;
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        history = '';
        output = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
      });
    } catch (e) {
      setState(() {
        output = 'Error';
      });
    }
  }

  // Handles button presses
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        history = '';
        output = '0';
      } else if (value == 'CE') {
        if (output.isNotEmpty && output != '0') {
          output = output.substring(0, output.length - 1);
          if (output.isEmpty) output = '0';
        }
      } else if (value == '=') {
        calculateResult();
      } else if (['+', '-', '×', '÷'].contains(value)) {
        if (output.isNotEmpty && output != '0') {
          history += output + value;
          output = '0';
        }
      } else {
        if (output == '0') {
          output = value;
        } else {
          output += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: const Text(
          'A simple calculator app',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 244, 184, 204),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Display Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          history,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          output,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Buttons Section
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    children: [
                      'C', 'CE', '%', '÷',
                      '7', '8', '9', '*',
                      '4', '5', '6', '-',
                      '1', '2', '3', '+',
                      ' ', '0', ' ', '=', // Empty string for alignment
                    ].map((text) {
                      // Logic for 'C', 'CE', and '%' buttons (gray background)
                      if (['C', 'CE', '%'].contains(text)) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300], // Gray background
                                shape: CircleBorder(),
                                side: BorderSide(color: Colors.transparent), // No border
                                elevation: 0, // No shadow
                              ),
                              onPressed: () => onButtonPressed(text),
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 18, // Matching text size
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // Logic for operator buttons (÷, *, -, +, = red background)
                      if (['÷', '*', '-', '+', '='].contains(text)) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: CircleBorder(),
                                side: BorderSide(color: Colors.transparent),
                                elevation: 0,
                              ),
                              onPressed: () => onButtonPressed(text),
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // Logic for regular buttons (numbers)
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: text == '0' ? 120 : 60, // Adjust width for "0"
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: CircleBorder(),
                              side: BorderSide(color: Colors.transparent),
                              elevation: 0,
                            ),
                            onPressed: () => onButtonPressed(text),
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
