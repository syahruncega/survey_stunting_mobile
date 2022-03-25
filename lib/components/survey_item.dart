import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:survey_stunting/components/custom_icon_button.dart';
import 'package:survey_stunting/models/survey.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem({
    required this.survey,
    this.onDelete,
    this.onEdit,
    this.enabled = true,
    Key? key,
  }) : super(key: key);
  final Survey survey;
  final bool enabled;
  final dynamic Function()? onDelete;
  final dynamic Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        enabled: enabled,
        key: key,
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.35,
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomIconButton(
                onTap: onDelete ?? () {},
                color: Colors.red.shade400,
                icon: SvgPicture.asset(
                  "assets/icons/bold/delete.svg",
                  color: Colors.white,
                ),
              ),
            ),
            CustomIconButton(
              onTap: onEdit ?? () {},
              color: Theme.of(context).colorScheme.secondary,
              icon: SvgPicture.asset(
                "assets/icons/bold/edit.svg",
                color: Colors.white,
              ),
            ),
          ],
        ),
        child: Material(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        survey.responden.kartuKeluarga,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.headline1!.color,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius: BorderRadius.circular(26)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            survey.namaSurvey.tipe,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Text(
                    survey.profile.namaLengkap,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    survey.namaSurvey.nama,
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).hintColor),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/bold/calendar.svg",
                            height: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat("dd MMMM yyyy")
                                .format(survey.createdAt!),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: survey.isSelesai == "0"
                                ? Colors.orange.shade300
                                : Colors.purple.shade300,
                            borderRadius: BorderRadius.circular(26)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            survey.isSelesai == "0"
                                ? "Belum Selesai"
                                : "Selesai",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
