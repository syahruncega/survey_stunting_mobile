import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          SvgPicture.asset("assets/images/not_found.svg",
              height: size.height * 0.2),
          const SizedBox(height: 10),
          Text(
            "Data tidak ditemukan",
            style: Theme.of(context).textTheme.headline3,
          )
        ],
      ),
    );
  }
}
