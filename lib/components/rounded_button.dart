import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.title,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.disabled = false,
    Key? key,
  })  : outline = false,
        super(key: key);

  const RoundedButton.outline({
    required this.title,
    this.onPressed,
    this.color,
    this.disabled = false,
    Key? key,
  })  : outline = true,
        backgroundColor = null,
        super(key: key);

  final String title;
  final void Function()? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final bool outline;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: disabled ? () {} : onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: outline
              ? color ?? Theme.of(context).colorScheme.secondary
              : color ?? Theme.of(context).textTheme.button?.color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: outline
            ? backgroundColor
            : backgroundColor ?? Theme.of(context).colorScheme.primary,
        side: outline
            ? BorderSide(
                width: 2, color: Theme.of(context).colorScheme.secondary)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
