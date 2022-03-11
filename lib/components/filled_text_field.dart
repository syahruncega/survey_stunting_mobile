import 'package:flutter/material.dart';

class FilledTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final String? hintText;
  const FilledTextField({this.prefixIcon, this.hintText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        // hintStyle: const TextStyle(color: kHintColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: prefixIcon,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
        ),
        filled: true,
        // fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
