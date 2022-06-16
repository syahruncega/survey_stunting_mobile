import 'package:flutter/material.dart';

class CustomComboBox extends StatelessWidget {
  const CustomComboBox({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String label;
  final String value;
  final String groupValue;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {onChanged!(value)},
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
          Text(label),
        ],
      ),
    );
  }
}
