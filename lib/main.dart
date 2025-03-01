import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalculatorApp',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _firstOperand = null;
        _operator = null;
        _shouldResetDisplay = false;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        // When an operator is pressed, store the first operand and operator
        if (_display.isNotEmpty) {
          // If we already have a pending operation, calculate it first
          if (_operator != null && _firstOperand != null) {
            _calculateResult();
          }
          
          _firstOperand = double.parse(_display);
          _operator = value;
          _shouldResetDisplay = true;
        }
      } else if (value == '=') {
        // On equals, perform the calculation if all components are available
        _calculateResult();
      } else {
        // Handle digit or decimal input
        if (_shouldResetDisplay) {
          _display = value;
          _shouldResetDisplay = false;
        } else {
          // Don't allow multiple leading zeros
          if (_display == '0' && value != '.') {
            _display = value;
          } else {
            // Don't allow multiple decimal points
            if (value == '.' && _display.contains('.')) {
              return;
            }
            _display += value;
          }
        }
      }
    });
  }

  void _calculateResult() {
    if (_operator != null && _firstOperand != null) {
      double secondOperand = double.parse(_display);
      // Check for division by zero
      if (_operator == '/' && secondOperand == 0) {
        _display = 'Error';
        _firstOperand = null;
        _operator = null;
        return;
      }
      
      double result;
      switch (_operator) {
        case '+':
          result = _firstOperand! + secondOperand;
          break;
        case '-':
          result = _firstOperand! - secondOperand;
          break;
        case '*':
          result = _firstOperand! * secondOperand;
          break;
        case '/':
          result = _firstOperand! / secondOperand;
          break;
        default:
          return;
      }
      
      // Format result: display as integer if there's no fractional part
      if (result == result.roundToDouble()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }
      
      _firstOperand = result; // Store result for chaining calculations
      _operator = null;
      _shouldResetDisplay = true;
    }
  }

  Widget _buildButton(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(value),
          child: Text(value, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Text(_display, style: TextStyle(fontSize: 48)),
            ),
          ),
          Row(
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/'),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*'),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('='),
              _buildButton('+'),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('C'),
            ],
          ),
        ],
      ),
    );
  }
}
