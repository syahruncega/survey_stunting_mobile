import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/controllers/detail_survey_controller.dart';

class DetailSurveyScreen extends StatelessWidget {
  const DetailSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailSurveyController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: SvgPicture.asset(
                "assets/icons/outline/arrow-left.svg",
                color: Theme.of(context).textTheme.headline1!.color,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 20,
                  children: [
                    Text(
                      "Detail Survey",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
