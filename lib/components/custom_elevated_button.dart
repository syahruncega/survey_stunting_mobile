import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget icon;

  const CustomElevatedButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 40,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightForFinite(width: width!, height: height!),
      child: ElevatedButton.icon(
        label: Text(
          label,
          style: Theme.of(context).textTheme.button,
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
