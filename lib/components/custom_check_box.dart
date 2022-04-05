import 'package:flutter/material.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/models/jawaban_survey.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    required this.label,
    required this.value,
    required this.isOther,
    required this.onChanged,
    required this.jawabanSurvey,
    Key? key,
  }) : super(key: key);

  final String label;
  final bool value;
  final bool isOther;
  final void Function(bool?)? onChanged;
  final JawabanSurvey jawabanSurvey;

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
                validator: (value) {
                  if (jawabanSurvey.isAllowed == true &&
                      (value == null || value.trim().isEmpty)) {
                    return "Jawaban tidak boleh kosong";
                  }
                  return null;
                },
                onSaved: (value) => jawabanSurvey.jawabanLainnya = value,
              ),
            ),
          if (!isOther) Flexible(child: Text(label)),
        ],
      ),
    );
  }
}
