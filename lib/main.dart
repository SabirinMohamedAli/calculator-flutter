import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // For expression evaluation

void main() {
  runApp(MyCalculatorApp());
}

class MyCalculatorApp extends StatefulWidget {
  @override
  _MyCalculatorAppState createState() => _MyCalculatorAppState();
}

class _MyCalculatorAppState extends State<MyCalculatorApp> {
  String userInput = '';
  String answer = '0';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Calculator'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display Area for User Input
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                userInput,
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
            // Display Area for Result
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                answer,
                style: TextStyle(fontSize: 36, color: Colors.tealAccent),
              ),
            ),
            // Button Area
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    buildButtonRow(['AC', '()', '%', '/']),
                    buildButtonRow(['7', '8', '9', '*']),
                    buildButtonRow(['4', '5', '6', '-']),
                    buildButtonRow(['1', '2', '3', '+']),
                    buildButtonRow(['0', '.', '=', '+']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build rows of buttons
  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((btn) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btn == '=' ? Colors.teal : Colors.grey[850],
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (btn == 'AC') {
                      // Clear input and output
                      userInput = '';
                      answer = '0';
                    } else if (btn == '=') {
                      // Calculate the result
                      answer = calculateAnswer();
                    } else {
                      // Add button pressed to userInput
                      userInput += btn;
                    }
                  });
                },
                child: Text(
                  btn,
                  style: TextStyle(
                    fontSize: 24,
                    color: btn == '=' ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Function to evaluate the user's input and calculate the result
  String calculateAnswer() {
    // Basic Validation Rules to avoid invalid expressions
    if (userInput.isEmpty || 
        userInput.endsWith('+') || 
        userInput.endsWith('-') || 
        userInput.endsWith('*') || 
        userInput.endsWith('/') || 
        userInput.endsWith('%')) {
      return 'Error';
    }

    try {
      // Parsing and evaluating the mathematical expression
      Parser p = Parser();
      Expression exp = p.parse(userInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // If evaluation is successful, return result
      return eval.toString();
    } catch (e) {
      
      print("Error encountered: $e");
      return 'Error';
    }
  }
}
