import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raed_store/data/error_model.dart';
import 'package:raed_store/data/login/login_response.dart';
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

  Future<String> getClientBalance(String accountNumber) async {
    var response = await http.post(Uri.parse(NetworkHelper().getClientBalance),
        body: '{"AccNumber":"$accountNumber"}');
    return response.body;
  }

  dynamic _validateResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        return ErrorModel.fromJson(json.decode(response.body)).errors![0];
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    var response = await http.post(
      Uri.parse("http://mydatasoft.net/token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {"grant_type": "password", "username": email, "password": password},
    );
    if(response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    }else {
      throw Exception('error in login');
    }
  }
}
