import 'package:flutter/material.dart';
import 'package:letzpay/theme/pallete.dart';

enum TextSize {
  xSmall,
  small,
  medium,
  large,
  xMedium,
}

enum TextWeight {
  light,
  regular,
  medium,
  lMedium,
  bold,
}

class LPText extends StatelessWidget {
  final String text;
  final TextSize size;
  final Color color;
  final TextWeight weight;


  const LPText(
    this.text, {super.key,
    this.size = TextSize.medium,
    this.color = Pallete.black,
    this.weight = TextWeight.regular,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;
    FontWeight fontWeight;

    switch (size) {
      case TextSize.xSmall:
        fontSize = 9;
        break;
      case TextSize.small:
        fontSize = 12.0;
        break;
      case TextSize.medium:
        fontSize = 16.0;
        break;
      case TextSize.large:
        fontSize = 32.0;
        break;
      case TextSize.xMedium:
        fontSize = 18;
        break;
    }

    switch (weight) {
      case TextWeight.light:
        fontWeight = FontWeight.w300;
        break;
      case TextWeight.regular:
        fontWeight = FontWeight.w400;
        break;
      case TextWeight.medium:
        fontWeight = FontWeight.w500;
        break;
      case TextWeight.lMedium:
        fontWeight = FontWeight.w600;
        break;
      case TextWeight.bold:
        fontWeight = FontWeight.w700;
        break;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
