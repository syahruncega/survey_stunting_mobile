import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:survey_stunting/models/detail_survey.dart';
import 'package:survey_stunting/models/jawaban_soal.dart';

class KategoriSoalItem extends StatelessWidget {
  const KategoriSoalItem(this.kategoriSoal, {Key? key}) : super(key: key);

  final DetailSurvey kategoriSoal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            kategoriSoal.nama,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ...kategoriSoal.soal.map(
          (soal) {
            var soalNumber = kategoriSoal.soal.indexOf(soal) + 1;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$soalNumber. ",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            soal.soal,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          ...kategoriSoal.jawabanSurvey.map((jawabanSurvey) {
                            if (jawabanSurvey.soalId == soal.id.toString()) {
                              return Text(
                                jawabanSurvey.jawabanLainnya != null
                                    ? jawabanSurvey.jawabanLainnya.toString()
                                    : soal.tipeJawaban != "Kotak Centang"
                                        ? JawabanSoal.fromJson(
                                                jawabanSurvey.jawabanSoal)
                                            .jawaban
                                        : "- ${JawabanSoal.fromJson(jawabanSurvey.jawabanSoal).jawaban}",
                              );
                            }
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          }).toList(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ).toList(),
      ],
    );
  }
}
