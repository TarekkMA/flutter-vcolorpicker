import 'package:flutter/material.dart';

extension on Offset {
  Offset clamp(Rect rect) {
    return Offset(
      dx.clamp(rect.left, rect.right),
      dy.clamp(rect.top, rect.bottom),
    );
  }
}

class VColorGradientCanvas extends StatelessWidget {
  final double height;

  const VColorGradientCanvas({
    Key key,
    @required HSVColor color,
    this.onColorChanged,
    this.height = 250,
  })  : _color = color,
        super(key: key);

  final Function(HSVColor color) onColorChanged;
  final HSVColor _color;

  void colorUpdate(Offset offset, Rect rect) {
    if (onColorChanged == null) return;
    offset.clamp(rect);
    onColorChanged(
      HSVColor.fromAHSV(
        _color.alpha,
        _color.hue,
        (offset.dx / rect.width).clamp(0, 1).toDouble(),
        ((rect.height - offset.dy) / rect.height).clamp(0, 1).toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final areaRect = Rect.fromLTWH(0, 0, width, height);
        return GestureDetector(
          onPanUpdate: (details) {
            colorUpdate(details.localPosition, areaRect);
          },
          onPanStart: (details) {
            colorUpdate(details.localPosition, areaRect);
          },
          onPanDown: (details) {
            colorUpdate(details.localPosition, areaRect);
          },
          onTapDown: (details) {
            colorUpdate(details.localPosition, areaRect);
          },
          child: Container(
            width: width,
            height: height,
            child: CustomPaint(
              painter: ColorGradientPainter(_color),
            ),
          ),
        );
      },
    );
  }
}

class ColorGradientPainter extends CustomPainter {
  final HSVColor baseColor;

  ColorGradientPainter(this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final saturationGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        HSLColor.fromAHSL(1, 0, 0, 1).toColor(),
        HSLColor.fromAHSL(1, baseColor.hue, 1, 0.5).toColor(),
      ],
    );

    final valueGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        HSLColor.fromAHSL(0, 0, 0, 1).toColor(),
        HSLColor.fromAHSL(1, 0, 0, 0).toColor(),
      ],
    );

    final drawRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(
      drawRect,
      Paint()..shader = saturationGradient.createShader(drawRect),
    );
    canvas.drawRect(
      drawRect,
      Paint()..shader = valueGradient.createShader(drawRect),
    );

    final baseColorPos = Offset(
      baseColor.saturation * size.width,
      (1 - baseColor.value) * size.height,
    );

    canvas.drawCircle(
      baseColorPos,
      8,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      baseColorPos,
      9,
      Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
