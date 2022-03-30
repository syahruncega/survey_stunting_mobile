import 'package:flutter/material.dart';
import 'package:survey_stunting/components/filled_text_field.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    required this.label,
    required this.value,
    required this.isOther,
    required this.groupValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String label;
  final bool value;
  final bool isOther;
  final String groupValue;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {onChanged!(!value)},
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
          if (isOther)
            Flexible(
                child: FilledTextField(
              hintText: "Lainnya",
              height: 36,
              borderRadius: BorderRadius.circular(10),
            )),
          if (!isOther) Flexible(child: Text(label)),
        ],
      ),
    );
  }
}
