import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SynchronizeData extends StatelessWidget {
  const SynchronizeData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.8,
            child: LottieBuilder.asset('assets/anim/sync_data_anim.json'),
          ),
          Text(
            "Mohon tunggu..",
            style: Theme.of(context).textTheme.headline3,
          ),
        ],
      ),
    );
  }
}
