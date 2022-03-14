import 'package:flutter/material.dart';

class ElevatedIconButton extends StatelessWidget {
  final Widget icon;
  final Function() onTap;
  const ElevatedIconButton({
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: icon,
        ),
      ),
    );
  }
}
