// To parse this JSON data, do
//
//     final RawResponse = RawResponseFromJson(jsonString);

import 'dart:convert';

RawResponse rawResponseFromJson(String str) =>
    RawResponse.fromJson(json.decode(str));

String rawResponseToJson(RawResponse data) => json.encode(data.toJson());

String getData(String str) {
  RawResponse rawResponse = RawResponse.fromJson(json.decode(str));
  return json.encode(rawResponse.data);
}

class RawResponse {
  RawResponse({
    required this.message,
    required this.data,
  });

  String message;
  dynamic data;

  factory RawResponse.fromJson(Map<String, dynamic> json) => RawResponse(
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
