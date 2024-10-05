import 'dart:convert';
/// success : 401
/// message : "Validation Error"
/// error : [{"code":"mobile","message":"The mobile field is required."}]

ErrorResponse errorResponseFromJson(String str) => ErrorResponse.fromJson(json.decode(str));
String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());
class ErrorResponse {
  ErrorResponse({
     dynamic success,
     String? message,
     List<Error>? error,}){
    _success = success;
    _message = message;
    _error = error;
  }

  ErrorResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['error'] != null) {
      _error = [];
      json['error'].forEach((v) {
        _error!.add(Error.fromJson(v));
      });
    }
  }
  dynamic _success;
  dynamic _message;
  List<Error>? _error;

  dynamic get success => _success;
  dynamic get message => _message;
  List<Error>? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_error != null) {
      map['error'] = _error!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// code : "mobile"
/// message : "The mobile field is required."

Error errorFromJson(dynamic str) => Error.fromJson(json.decode(str));
dynamic errorToJson(Error data) => json.encode(data.toJson());
class Error {
  Error({
    dynamic code,
    dynamic message,}){
    _code = code;
    _message = message;
  }

  Error.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
  }
  dynamic _code;
  dynamic  _message;

  dynamic  get code => _code;
  dynamic  get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    return map;
  }

}