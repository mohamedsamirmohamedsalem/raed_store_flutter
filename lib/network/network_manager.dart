import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raed_store/data/error_model.dart';
import 'package:raed_store/data/register/request.dart';
import 'package:raed_store/network/end_points.dart';

class NetworkManager {
  static NetworkManager? singleton;

  factory NetworkManager() {
    singleton = singleton ?? NetworkManager._internal();
    return singleton!;
  }

  NetworkManager._internal();

  Future<String> registerUser(
      String email, String password, String passwordConfirmation) async {
    var response = await http.post(Uri.parse(NetworkHelper().register),
        body: RegisterRequest(
                email: email,
                password: password,
                confirmPassword: passwordConfirmation)
            .toJson());
    return _validateResponse(response);
  }

  dynamic _validateResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        return ErrorModel.fromJson(json.decode(response.body)).errors![0];
    }
  }
}
