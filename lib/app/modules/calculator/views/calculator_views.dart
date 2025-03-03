import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

const Color colorDark = Color(0xFF374352);
const Color colorLight = Color(0xFFe6eeff);

class _CalculatorState extends State<Calculator> {
  bool darkMode = false;
  String userInput = '';
  String result = '';

final NumberFormat formatter = NumberFormat('#,##0.00');

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        userInput = '';
        result = '';
      } else if (value == '⌫') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
        if(userInput.isEmpty){
          result = '';
        }
      } else if (value == '=') {
        if (userInput.isNotEmpty) {
          result = _calculateResult();
        }
      } else {
        if(userInput.length < 105){
         userInput += value;
        }
        if(result.length > 54){
          result = '';
        }
      }
    });
  }

  String _calculateResult() {
    try {
      String processedInput = userInput.replaceAll('x', '*');
     processedInput = processedInput.replaceAllMapped(RegExp(r'√\((.*?)\)'), (match) {
      return '(${match.group(1)})^(0.5)';
    });
      RegExp percentageRegex = RegExp(r'(\d+(\.\d+)?)(%)');
      while (processedInput.contains('%')) {
        Match? match = percentageRegex.firstMatch(processedInput);
        if (match != null) {
          double percentageValue = double.parse(match.group(1)!);
          int matchStartIndex = match.start;
          double precedingNumber = 0;

          // Find the preceding number
          RegExp precedingNumberRegex = RegExp(r'(\d+(\.\d+)?)(?!%)');
          Iterable<Match> precedingMatches = precedingNumberRegex
              .allMatches(processedInput.substring(0, matchStartIndex))
              .toList()
              .reversed;

          if (precedingMatches.isNotEmpty) {
            precedingNumber = double.parse(precedingMatches.first.group(1)!);
          } else {
            //if there is no preceding number, the percentage is simply the value divided by 100.
            precedingNumber = 1;
          }

          double calculatedPercentage =
              (percentageValue / 100.0) * precedingNumber;

          processedInput = processedInput.replaceRange(
            match.start,
            match.end,
            calculatedPercentage.toString(),
          );
        } else {
          break;
        }
      }

      Parser p = Parser();
      Expression exp = p.parse(processedInput);
      ContextModel cm = ContextModel();
      cm.bindVariable(Variable('e'), Number(2.71828));
      p.parse(processedInput);
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return formatter.format( eval);
     
    } catch (e) {
      return 'Error';
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: colorLight,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
              onTap: () {
                setState(() {
                  darkMode = !darkMode;
                });
              },
              child: _switchMode()),
        ],
      ),
      backgroundColor: darkMode ? colorDark : colorLight,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: double.infinity,
                              child:
                                  Wrap(alignment: WrapAlignment.end, children: [
                                Text(
                                  userInput,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: userInput.length > 22 ? 30 : 55,
                                      color:
                                          darkMode ? Colors.white : Colors.red),
                                ),
                              ]),
                            ),
                          ),
                          Align(
                            alignment: Alignment
                                .bottomRight, // Fixes result at the bottom right
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              children: [
                                Text(
                                result,
                                style: TextStyle(
                                  fontSize: userInput.length > 22 ? 30 : 40,
                                  fontWeight: FontWeight.bold,
                                  color: darkMode ? Colors.green : Colors.grey,
                                ),
                              ),
                              ]
                            ),
                          ),
                        ]),
                  ),
                  // SizedBox(height: 80,),

                  Column(
                    children: [
                      // _buildRowOval(['sin', 'cos', 'tan', 'log']),
                      _buildRow(['e', '(', ')', '^']),
                      _buildRow(['C', '%', '⌫', '/']),
                      _buildRow(['7', '8', '9', 'x']),
                      _buildRow(['4', '5', '6', '-']),
                      _buildRow(['1', '2', '3', '+']),
                      _buildRow(['00', '0', '.', '=']),
                    ],
                  ),
                ],
              ))),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons.map((btn) {
        return _buttonRounded(
          title: btn,
          textColor: ['C', '⌫', '=', '+', '-', 'x', '/', '%'].contains(btn)
              ? (darkMode ? Colors.green : Colors.redAccent)
              : null,
          onTap: () => _onButtonPressed(btn),
        );
      }).toList(),
    );
  }

// Widget _buildRowOval(List<String> buttons) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: buttons.map((btn) {
//         return _buttonOval(
//           title: btn,
//           textColor: ['sin', 'cos', 'tan', 'log'].contains(btn)
//               ? (darkMode ? Colors.green : Colors.redAccent)
//               : null,
//           onTap: () => _onButtonPressed(btn),
//         );
//       }).toList(),
//     );
//   }

  Widget _buttonRounded(
      {String? title,
      double padding = 17,
      IconData? icon,
      Color? iconColor,
      required VoidCallback onTap,
      Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: onTap,
        child: NeuContainer(
            darkMode: darkMode,
            padding: EdgeInsets.all(padding),
            borderRadius: BorderRadius.circular(40),
            child: SizedBox(
              width: padding * 2,
              // MediaQuery.of(context).size.height * 0.03,
              height: padding * 2,
              child: Center(
                  child: title != null
                      ? Text(
                          title,
                          style: TextStyle(
                              color: textColor ??
                                  (darkMode ? Colors.white : Colors.black),
                              fontSize: 20),
                        )
                      : Icon(
                          icon,
                          color: iconColor,
                          size: 30,
                        )),
            )),
      ),
    );
  }

  // Widget _buttonOval({String? title,required VoidCallback onTap,Color? textColor, double padding = 17}) {
  //   return Padding(
  //     padding: EdgeInsets.all(10),
  //     child: NeuContainer(
  //       darkMode: darkMode,
  //       borderRadius: BorderRadius.circular(50),
  //       padding:
  //           EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
  //       child: Container(
  //         width: padding * 2,
  //         child: Center(
  //           child: Text(
  //             '$title',
  //             style: TextStyle(
  //                 color: darkMode ? Colors.white : Colors.black,
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _switchMode() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      width: 80,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.wb_sunny,
            color: darkMode ? Colors.grey : Colors.redAccent,
          ),
          Icon(
            Icons.nightlight_round,
            color: darkMode ? Colors.green : Colors.grey,
          )
        ],
      ),
    );
  }
}

class NeuContainer extends StatefulWidget {
  final bool darkMode;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  NeuContainer(
      {super.key,
      this.darkMode = false,
      required this.borderRadius,
      required this.child,
      required this.padding});
  @override
  State<NeuContainer> createState() => _NeuContainerState();
}

class _NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = widget.darkMode;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
            color: darkMode ? colorDark : colorLight,
            borderRadius: widget.borderRadius,
            boxShadow: _isPressed
                ? null
                : [
                    BoxShadow(
                        color: darkMode
                            ? Colors.black54
                            : Colors.blueGrey.shade200,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15,
                        spreadRadius: 1),
                    BoxShadow(
                        color:
                            darkMode ? Colors.blueGrey.shade700 : Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15,
                        spreadRadius: 1)
                  ]),
        child: widget.child,
      ),
    );
  }
}
