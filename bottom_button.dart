import 'package:flutter/material.dart';
const kBottomContainerHeight = 80.0;
const kActiveCardColor = Color(0xFF1D1E33);
const kInactiveCardColor = Color(0xFF111328);
const kBottomContainerColor = Color(0xFFEB1555);
const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const kNumberStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle =
TextStyle(fontWeight: FontWeight.bold, fontSize: 25);

const kTitleStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
    color: Color(0xFF24D876), fontSize: 22, fontWeight: FontWeight.bold);

const kBMITextStyle = TextStyle(fontSize: 100, fontWeight: FontWeight.bold);

const kBodyTextStyle = TextStyle(fontSize: 22);

class BottomButton extends StatelessWidget {
  BottomButton({@required this.onTap, @required this.buttonTitle});
  final Function onTap;
  final String buttonTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kLargeButtonTextStyle,
          ),
        ),
        margin: EdgeInsets.only(top: 10.0),
        color: kBottomContainerColor,
        width: double.infinity,
        height: kBottomContainerHeight,
        padding: EdgeInsets.only(bottom: 20),
      ),
    );
  }
}
