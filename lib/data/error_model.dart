import 'dart:convert' as json_converter;

class ErrorModel {
  String? message;
  Map<String, List<String>>? modelState;
  List<String>? errors;

  ErrorModel({this.message, this.modelState});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    errors = [];
    (json['ModelState'] as Map<String, dynamic>)
        .forEach((key, value) {
      errors!.add(value[0]);
    });
  }

}