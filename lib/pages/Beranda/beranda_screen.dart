import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/beranda_item.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/components/survey_item.dart';
import 'package:survey_stunting/controllers/beranda_controller.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BerandaController berandaController = Get.put(BerandaController());
    return RefreshIndicator(
      onRefresh: berandaController.getSurveyByStatus,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Beranda",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Obx(
              () => SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    BerandaItem(
                      icon: SvgPicture.asset(
                        "assets/icons/bulk/profile-2user.svg",
                        color: Theme.of(context).primaryColor,
                      ),
                      title: "Total Responden Anda",
                      subTitle: berandaController
                          .totalSurvey.value.totalResponden
                          .toString(),
                      isLoaded: berandaController.isLoadedTotalSurvey.value,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    BerandaItem(
                      icon: SvgPicture.asset(
                        "assets/icons/bulk/profile-2user.svg",
                        color: Colors.blue.shade300,
                      ),
                      title: "Responden Survey Pre",
                      subTitle: berandaController.totalSurvey.value.respondenPre
                          .toString(),
                      isLoaded: berandaController.isLoadedTotalSurvey.value,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    BerandaItem(
                      icon: SvgPicture.asset(
                        "assets/icons/bulk/profile-2user.svg",
                        color: Colors.indigo.shade300,
                      ),
                      title: "Responden Survey Post",
                      subTitle: berandaController
                          .totalSurvey.value.respondenPost
                          .toString(),
                      isLoaded: berandaController.isLoadedTotalSurvey.value,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "Survey belum selesai:",
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            FilledTextField(
              hintText: "Cari...",
              prefixIcon: SvgPicture.asset(
                "assets/icons/outline/search-2.svg",
                color: Theme.of(context).hintColor,
                height: 22,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              child: Obx(
                () => Visibility(
                  visible: berandaController.isLoadedSurvey.value,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: berandaController.surveys.isNotEmpty
                      ? ListView.builder(
                          itemCount: berandaController.surveys.length,
                          itemBuilder: (context, index) {
                            return SurveyItem(
                              key: UniqueKey(),
                              enabled: false,
                              survey: berandaController.surveys[index],
                            );
                          },
                        )
                      : ListView(
                          children: const [Text("Data tidak ditemukan")],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
