import 'package:flutter/material.dart';

class CustomElevatedButtonIcon extends StatelessWidget {
  final String label;
  final Widget icon;
  final void Function()? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const CustomElevatedButtonIcon({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).textTheme.button?.color,
                strokeWidth: 2,
              ),
            )
          : icon,
      label: Text(
        label,
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: onPressed,
    );
  }
}
