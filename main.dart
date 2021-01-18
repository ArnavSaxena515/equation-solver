import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'dart:core';
import 'package:equations/equations.dart';

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
    color: Color(0xFF24D876), fontSize: 25, fontWeight: FontWeight.bold);

const kBMITextStyle = TextStyle(fontSize: 100, fontWeight: FontWeight.bold);

const kBodyTextStyle = TextStyle(fontSize: 22);

//enum imageSources { camera, gallery }
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  String scannedEquation;
  bool isImageLoaded = false;
  double sol;
  String answers = '';
  String equationWithoutWhiteSpace;
  String bottomText = '';
  String getText = '';
  String getAns = '';

  Future pickImageCamera() async {
    // ignore: deprecated_member_use
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future pickImage() async {
    // ignore: deprecated_member_use
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future<String> readText() async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(pickedImage);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    String text = visionText.text;
    // for (TextBlock block in visionText.blocks) {
    //
    //   for (TextLine line in block.lines) {
    //     // Same getters as TextBlock
    //     for (TextElement element in line.elements) {
    //       // Same getters as TextBlock
    //     }
    //   }
    // }
    textRecognizer.close();
    scannedEquation = text;
    print('printing out the recognized text:');
    print(text);
    equationWithoutWhiteSpace =
        scannedEquation.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    print('no white spaces:');
    print(equationWithoutWhiteSpace);
    return equationWithoutWhiteSpace;
    // for (TextBlock block in readText.blocks) {
    //   for (TextLine line in block.lines) {
    //     for (TextElement word in line.elements) {
    //       print(word.text);
    //     }
    //   }
    // }
  }

  Future<String> solve() async {
    final newton = Newton("$equationWithoutWhiteSpace", -1, maxSteps: 5);
    final solutions = await newton.solve();
    print(solutions.guesses);
    print(solutions);
    return solutions.guesses[solutions.guesses.length - 1]
        .toStringAsPrecision(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBottomContainerColor,
          title: Center(
              child: Text(
            'EQUATION SOLVER',
            style: kBodyTextStyle,
          )),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100.0),
              isImageLoaded
                  ? Center(
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(pickedImage),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      FontAwesomeIcons.image,
                      size: 200,
                    ),
              SizedBox(height: 30.0),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kBottomContainerColor,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: FlatButton(
                    minWidth: 200,
                    height: 50,
                    color: kBottomContainerColor,
                    child: Text('From Storage', style: kBodyTextStyle),
                    onPressed: pickImage,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kBottomContainerColor,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: FlatButton(
                    minWidth: 200,
                    height: 50,
                    color: kBottomContainerColor,
                    child: Text('Camera', style: kBodyTextStyle),
                    onPressed: pickImageCamera,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kBottomContainerColor,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10), right: Radius.circular(10)),
                  ),
                  child: FlatButton(
                    color: kBottomContainerColor,
                    child: Text(
                      'Solve!',
                      style: kBodyTextStyle,
                    ),
                    onPressed: () async {
                      getText = 'Equation: ${await readText()}';
                      getAns = await solve();
                      //bottomText = 'Equation: $equationWithoutWhiteSpace';
                      setState(() {
                        bottomText = getText;
                        answers = getAns;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: kBottomContainerColor,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10), right: Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Text(
                          bottomText,
                          style: kBodyTextStyle,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Solution: $answers',
                          style: kResultTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
