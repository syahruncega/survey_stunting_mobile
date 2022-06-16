// To parse this JSON data, do
//
//     final totalSurvey = totalSurveyFromJson(jsonString);

import 'dart:convert';

TotalSurvey totalSurveyFromJson(String str) =>
    TotalSurvey.fromJson(json.decode(str));

String totalSurveyToJson(TotalSurvey data) => json.encode(data.toJson());

class TotalSurvey {
  TotalSurvey({
    this.respondenPre,
    this.respondenPost,
    this.totalResponden,
  });

  int? respondenPre;
  int? respondenPost;
  int? totalResponden;

  factory TotalSurvey.fromJson(Map<String, dynamic> json) => TotalSurvey(
        respondenPre: json["responden_pre"],
        respondenPost: json["responden_post"],
        totalResponden: json["total_responden"],
      );

  Map<String, dynamic> toJson() => {
        "responden_pre": respondenPre,
        "responden_post": respondenPost,
        "total_responden": totalResponden,
      };
}
