import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:survey_stunting/components/elevated_icon_button.dart';
import 'package:survey_stunting/components/filled_text_field.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survey",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          Row(
            children: [
              Flexible(
                child: FilledTextField(
                  hintText: "Cari...",
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/outline/search-2.svg",
                    color: Theme.of(context).hintColor,
                    height: 22,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              ElevatedIconButton(
                icon: SvgPicture.asset(
                  "assets/icons/outline/setting-4.svg",
                  color: Colors.white,
                ),
                onTap: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
