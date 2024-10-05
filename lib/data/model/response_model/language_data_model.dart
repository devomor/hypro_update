// To parse this JSON data, do
//
//     final languageDataModel = languageDataModelFromJson(jsonString);

import 'dart:convert';

LanguageDataModel languageDataModelFromJson(String str) => LanguageDataModel.fromJson(json.decode(str));

String languageDataModelToJson(LanguageDataModel data) => json.encode(data.toJson());

class LanguageDataModel {
  dynamic status;
  Map<dynamic, dynamic>? language;

  LanguageDataModel({
    this.status,
    this.language,
  });

  factory LanguageDataModel.fromJson(Map<String, dynamic> json) => LanguageDataModel(
    status: json["status"],
    language: Map.from(json["message"]!).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": Map.from(language!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
