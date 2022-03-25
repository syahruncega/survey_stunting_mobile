import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FilledAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final List<Map<String, dynamic>> items;
  final String? hintText;
  final String? title;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool enabled;
  final void Function(Map<String, dynamic>) onSuggestionSelected;

  const FilledAutocomplete({
    required this.controller,
    required this.items,
    required this.onSuggestionSelected,
    this.title,
    this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.enabled = true,
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
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            textInputAction: textInputAction,
            enabled: enabled,
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    BorderSide(color: Theme.of(context).secondaryHeaderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor.withAlpha(0),
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 58,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.text = "";
                        },
                        child: Icon(Icons.close,
                            color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset(
                        "assets/icons/outline/arrow-down.svg",
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            controller: controller,
          ),
          suggestionsCallback: (pattern) => items.where((element) =>
              element["label"].toLowerCase().contains(pattern.toLowerCase())),
          itemBuilder: (_, Map<String, dynamic> suggestion) => InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(suggestion["label"]),
            ),
          ),
          getImmediateSuggestions: false,
          onSuggestionSelected: onSuggestionSelected,
          noItemsFoundBuilder: (context) => const Padding(
            padding: EdgeInsets.all(20),
            child: Text("Item tidak ditemukan"),
          ),
          suggestionsBoxDecoration:
              SuggestionsBoxDecoration(borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }
}
