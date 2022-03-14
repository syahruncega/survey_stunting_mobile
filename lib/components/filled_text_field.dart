import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilledTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final String? hintText;
  final String? helperText;
  final String? title;
  final int? minLine;
  final int? maxLine;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obsecureText;
  const FilledTextField({
    this.prefixIcon,
    this.hintText,
    this.title,
    this.helperText,
    this.controller,
    this.minLine,
    this.maxLine = 1,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obsecureText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: Theme.of(context).textTheme.headline3,
          ),
        if (title != null) SizedBox(height: size.height * 0.01),
        TextFormField(
          controller: controller,
          minLines: minLine,
          maxLines: maxLine,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          obscureText: obsecureText!,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            helperMaxLines: 2,
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: prefixIcon,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withAlpha(0),
              ),
            ),
            filled: true,
            // fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
