
import 'package:flutter/material.dart';
import 'package:vcolorpicker/v_color_gradient_canvas.dart';
import 'package:vcolorpicker/v_color_input.dart';

extension on Color {
  HSVColor toHSVColor() => HSVColor.fromColor(this);
}

class VColorPicker extends StatefulWidget {
  VColorPicker({Key key}) : super(key: key);

  @override
  _VColorPickerState createState() => _VColorPickerState();
}

class _VColorPickerState extends State<VColorPicker> {
  HSVColor _color = Color(0xff630000).toHSVColor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          VColorGradientCanvas(
            color: _color,
            onColorChanged: (color) {
              setState(() {
                _color = color;
              });
            },
          ),
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  image: DecorationImage(
                    image: AssetImage("assets/trans_bg.png"),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                foregroundDecoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: _color.toColor(),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Slider(
                      min: 0,
                      max: 360,
                      value: _color.hue,
                      onChanged: (value) {
                        setState(() {
                          _color = _color.withHue(value);
                        });
                      },
                    ),
                    Slider(
                      min: 0,
                      max: 1,
                      value: _color.alpha.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _color = _color.withAlpha(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          VColorInput(
            color: _color,
            onColorChanged: (newColor) {
              if (newColor is HSVColor) {
                setState(() {
                  _color = newColor;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
