import 'package:flutter/material.dart';
import 'package:vcolorpicker/v_color_picker.dart';

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
  ));
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Color Picker"),
      ),
      body: VColorPicker(),
    );
  }
}
