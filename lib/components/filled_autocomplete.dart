import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FilledAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final List<String> items;
  final String hintText;
  const FilledAutocomplete(
      {required this.controller,
      required this.items,
      this.hintText = "",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            hintText: hintText,
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
              borderSide:
                  BorderSide(color: Theme.of(context).secondaryHeaderColor),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SvgPicture.asset(
                "assets/icons/outline/arrow-down.svg",
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          controller: controller),
      suggestionsCallback: (pattern) => items.where(
          (element) => element.toLowerCase().contains(pattern.toLowerCase())),
      itemBuilder: (_, String suggestion) => ListTile(
        title: Text(suggestion),
      ),
      getImmediateSuggestions: true,
      onSuggestionSelected: (String suggestion) {
        controller.text = suggestion;
      },
      noItemsFoundBuilder: (context) => const Padding(
        padding: EdgeInsets.all(20),
        child: Text("Item tidak ditemukan"),
      ),
      suggestionsBoxDecoration:
          SuggestionsBoxDecoration(borderRadius: BorderRadius.circular(10)),
    );
  }
}
