import 'package:flutter/material.dart';
import 'package:survey_stunting/models/detail_survey.dart';

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
              children: [
                Text(
                  "$soalNumber. ${soal.soal}",
                  style: Theme.of(context).textTheme.headline3,
                ),
                ...kategoriSoal.jawabanSurvey.map((jawabanSurvey) {
                  if (jawabanSurvey.soalId == soal.id.toString()) {
                    return Text(jawabanSurvey.id.toString());
                  }
                  return const SizedBox(
                    height: 0,
                    width: 0,
                  );
                }).toList(),
              ],
            );
          },
        ).toList(),
      ],
    );
  }
}
