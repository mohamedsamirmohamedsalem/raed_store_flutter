import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raed_store/bill_screen.dart';
import 'package:raed_store/data/SaveMoneyRequest/SaveMoneyRequest.dart';
import 'package:raed_store/data/client/clientResponse.dart';
import 'package:raed_store/data/error_model.dart';
import 'package:raed_store/data/get_items_by_id/response.dart';
import 'package:raed_store/data/login/login_response.dart';
import 'package:raed_store/data/register/request.dart';
import 'package:raed_store/data/save_invoice/request.dart';
import 'package:raed_store/data/save_invoice/response.dart';
import 'package:raed_store/network/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: jsonEncode(RegisterRequest(
                email: email,
                password: password,
                confirmPassword: passwordConfirmation)
            .toJson()),
        headers: {"Content-Type": "application/json"});
    return _validateResponse(response);
  }

  Future<LoginResponse?> getLoginResponseFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final LoginResponse? loginResponse =
        LoginResponse.fromJson(json.decode(prefs.getString('login_response')!));
    return loginResponse;
  }

  Future<String> getClientBalance(String accountNumber) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().getClientBalance),
        body: '{"AccNumber":"$accountNumber"}',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken}"
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("unable to get client balance");
    }
  }

  Future<List<ClientResponse>> getAgents() async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response =
        await http.post(Uri.parse(NetworkHelper().getClients), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${loginResponse!.accessToken}"
    });
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<ClientResponse> clients = [];
      for (int i = 0; i < list.length; i++) {
        clients.add(ClientResponse.fromJson(list[i]));
      }
      return clients;
    } else {
      throw Exception("unable to get Agents");
    }
  }

  Future<SaveInvoiceResponse> saveInvoice(
      BillType billType, SaveInvoiceRequest saveInvoiceRequest) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().saveInvoice),
        body: jsonEncode(saveInvoiceRequest.toJson()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken!}"
        });
    if (response.statusCode == 200) {
      return SaveInvoiceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("unable to Save Invoice");
    }
  }

  Future<List<GetItemWithBalanceByIdResponse>> getItemWithBalance(
      String stockID) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().getItemsByID),
        body: '{"StockId":"$stockID"}',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken!}"
        });
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<GetItemWithBalanceByIdResponse> items = [];
      for (int i = 0; i < list.length; i++) {
        items.add(GetItemWithBalanceByIdResponse.fromJson(list[i]));
      }
      return items;
    } else {
      throw Exception("unable to get items with balance");
    }
  }

  Future<String> saveMoney(SaveMoneyRequest saveMoneyRequest) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().saveReceivedMoney),
        body: json.encode(saveMoneyRequest),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken}"
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("unable to Save Received Money");
    }
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
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('error in login');
    }
  }
}
