import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Beranda",
            style: Theme.of(context).textTheme.headline1,
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
