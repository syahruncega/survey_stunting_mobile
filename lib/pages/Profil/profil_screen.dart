import 'package:flutter/material.dart';
import 'package:survey_stunting/consts/colors.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profil",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w700, color: kTextColor),
          ),
          // const Text(
          //   "Memorandum Of Agreement",
          //   style: TextStyle(fontSize: 14, color: kHintColor),
          // )
        ],
      ),
    );
  }
}
