import 'package:flutter/material.dart';

import '../theme/pallete.dart';
import '../theme/text.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text, required this.onTap,
  });

  final String text;
  final VoidCallback onTap ;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 19),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      color: Pallete.primaryColor,
      child: LPText(
        text,
        color: Pallete.whiteColor,
        size: TextSize.xMedium,
      ),
    );
  }
}
