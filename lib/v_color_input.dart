import 'package:flutter/material.dart';

enum VColorType { argb, ahsl, ahsv, ahex }

class VColorInput extends StatefulWidget {
  final HSVColor color;
  final VColorType colorType;
  final Function(dynamic newColor) onColorChanged;
  const VColorInput({
    Key key,
    @required this.color,
    this.colorType = VColorType.ahsv,
    this.onColorChanged,
  }) : super(key: key);

  @override
  _VColorInputState createState() => _VColorInputState();
}

class _VColorInputState extends State<VColorInput> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateColorInput();
  }

  void updateColorInput() {
    if (widget.colorType == VColorType.ahsv) {
      controller1.value = controller1.value.copyWith(
        text: widget.color.alpha.toStringAsFixed(2),
      );
      controller2.value = controller2.value.copyWith(
        text: widget.color.hue.round().toString(),
      );
      controller3.value = controller3.value.copyWith(
        text: widget.color.saturation.toStringAsFixed(2),
      );
      controller4.value = controller4.value.copyWith(
        text: widget.color.value.toStringAsFixed(2),
      );
    } else {
      controller1.clear();
      controller2.clear();
      controller3.clear();
      controller4.clear();
    }
  }

  void parseNewColor() {
    if (widget.onColorChanged == null) return;
    if (widget.colorType == VColorType.ahsv) {
      final a = double.parse(controller1.text);
      final h = double.parse(controller2.text);
      final s = double.parse(controller3.text);
      final v = double.parse(controller4.text);
      widget.onColorChanged(HSVColor.fromAHSV(a, h, s, v));
    }
  }

  @override
  void didUpdateWidget(covariant VColorInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateColorInput();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildTextField(
          controller: controller1,
          name: "Alpha",
        ),
        buildTextField(
          controller: controller2,
          name: "Hue",
        ),
        buildTextField(
          controller: controller3,
          name: "Saturation",
        ),
        buildTextField(
          controller: controller4,
          name: "Value",
        ),
      ],
    );
  }

  Widget buildTextField({
    @required TextEditingController controller,
    @required String name,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: name),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) {
          parseNewColor();
        },
      ),
    );
  }
}
