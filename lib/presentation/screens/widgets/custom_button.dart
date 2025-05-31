import 'package:flutter/material.dart';

import '../../../config/config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isTransparent = false,
    this.isLarge = false,
    this.icon,
  });

  final String text;
  final void Function()? onPressed;
  final bool isTransparent;
  final bool isLarge;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isTransparent ? Colors.transparent : AppColors.primaryColor;

    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      elevation: isTransparent ? 0 : 6,
      shadowColor:
          isTransparent ? Colors.transparent : backgroundColor.withAlpha(153),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    final textStyle = TextStyle(
      color: isTransparent ? Colors.black : Colors.white,
      fontSize: 16,
    );

    return SizedBox(
      height: 50,
      width: isLarge ? double.infinity : 160,
      child:
          icon != null
              ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, color: textStyle.color),
                label: Text(text, style: textStyle),
                style: style,
              )
              : ElevatedButton(
                onPressed: onPressed,
                child: Text(text, style: textStyle),
                style: style,
              ),
    );
  }
}
