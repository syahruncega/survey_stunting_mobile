// To parse this JSON data, do
//
//     final surveyParameters = surveyParametersFromJson(jsonString);

import 'dart:convert';

SurveyParameters surveyParametersFromJson(String str) =>
    SurveyParameters.fromJson(json.decode(str));

String surveyParametersToJson(SurveyParameters data) =>
    json.encode(data.toJson());

class SurveyParameters {
  SurveyParameters({
    this.status,
    this.typeSurveyId,
    this.search,
  });

  dynamic status;
  dynamic typeSurveyId;
  dynamic search;

  factory SurveyParameters.fromJson(Map<String, dynamic> json) =>
      SurveyParameters(
        status: json["status"],
        typeSurveyId: json["typeSurveyId"],
        search: json["search"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "typeSurveyId": typeSurveyId,
        "search": search,
      };
}
