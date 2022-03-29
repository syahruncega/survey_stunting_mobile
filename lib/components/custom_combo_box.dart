import 'package:flutter/material.dart';

class CustomComboBox extends StatelessWidget {
  const CustomComboBox({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String title;
  final String value;
  final String groupValue;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
