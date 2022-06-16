import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final bool isLoading;
  final double? width;
  final double? height;

  const CustomElevatedButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 40,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width, height: height),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Theme.of(context).textTheme.button?.color,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: Theme.of(context).textTheme.button,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
