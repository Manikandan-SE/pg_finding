import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  const AppElevatedButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.borderRadius,
    this.width,
    this.height = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(20);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Colors.cyan,
            Colors.indigo,
          ],
        ),
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
