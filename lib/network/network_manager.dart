import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:raed_store/bill_screen.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/data/Invoice/invoice_list_response.dart';
import 'package:raed_store/data/Invoice/invoice_response.dart';
import 'package:raed_store/data/SaveMoneyRequest/SaveMoneyRequest.dart';
import 'package:raed_store/data/SaveMoneyRequest/save_received_money_response.dart';
import 'package:raed_store/data/client/clientResponse.dart';
import 'package:raed_store/data/error_model.dart';
import 'package:raed_store/data/get_items_by_id/response.dart';
import 'package:raed_store/data/login/login_response.dart';
import 'package:raed_store/data/money_receive_list/recieve_money_list.dart';
import 'package:raed_store/data/register/request.dart';
import 'package:raed_store/data/save_invoice/request.dart';
import 'package:raed_store/data/save_invoice/response.dart';
import 'package:raed_store/network/end_points.dart';
import 'package:raed_store/utils/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/print_receive_money/print_receive_money_response.dart';

class NetworkManager {
  static NetworkManager? singleton;
  Function? on401UnAuthorizedUser;

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

  Future<String?> getClientBalance(String accountNumber) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().getClientBalance),
        body: '{"AccNumber":"$accountNumber"}',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken}"
        });
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("unable to get client balance");
    }
  }

  Future<List<ClientResponse>?> getAgents() async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response =
        await http.post(Uri.parse(NetworkHelper().getClients), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${loginResponse!.accessToken}"
    });
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
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

  Future<SaveInvoiceResponse?> saveInvoice(
      BillType billType, SaveInvoiceRequest saveInvoiceRequest) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().saveInvoice),
        body: jsonEncode(saveInvoiceRequest.toJson()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken!}"
        });
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      return SaveInvoiceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("unable to Save Invoice");
    }
  }

  Future<List<GetItemWithBalanceByIdResponse>?> getItemWithBalance(
      String stockID) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().getItemsByID),
        body: '{"StockId":"$stockID"}',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken!}"
        });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
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

  Future<List<InoviceListResponse>?> getInvoiceList() async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response =
        await http.post(Uri.parse(NetworkHelper().getInvoicesList), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${loginResponse!.accessToken!}"
    });
    print(response.body);
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<InoviceListResponse> items = [];
      for (int i = 0; i < list.length; i++) {
        items.add(InoviceListResponse.fromJson(list[i]));
      }
      return items;
    } else {
      throw Exception("unable to Invoice List");
    }
  }

  Future<List<ReceiveMoneyListResponse>?> getReceiptList() async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response =
        await http.post(Uri.parse(NetworkHelper().getReceiptList), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${loginResponse!.accessToken!}"
    });
    print(response.body.toString());
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<ReceiveMoneyListResponse> items = [];
      for (int i = 0; i < list.length; i++) {
        items.add(ReceiveMoneyListResponse.fromJson(list[i]));
      }
      return items;
    } else {
      throw Exception("unable to receipt List");
    }
  }

  Future<SaveReceivedMoney?> saveMoney(
      SaveMoneyRequest saveMoneyRequest) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    saveMoneyRequest.userName = loginResponse?.userName ?? "";
    var response = await http.post(Uri.parse(NetworkHelper().saveReceivedMoney),
        body: json.encode(saveMoneyRequest),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken}"
        });
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      return SaveReceivedMoney.fromJson(json.decode(response.body));
    } else {
      throw Exception("unable to Save Received Money");
    }
  }

  dynamic _validateResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("unable_to_register".tr());
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
    print(response.body);
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('error in login');
    }
  }

  Future<InvoiceResponse?> printInvoice(String trasID) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().printInvoice),
        body: '{"TransId":"$trasID"}',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken}"
        });
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      return InvoiceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("unable to print Invoice");
    }
  }

  Future<PrintReceiveMoneyResponse?> printReceiveMoney(
      String trasID, String transTrpeName) async {
    LoginResponse? loginResponse = await getLoginResponseFromSharedPreference();
    var response = await http.post(Uri.parse(NetworkHelper().printReceiveMoney),
        body: '{"TransId":"$trasID" , "TransTrpeName":"$transTrpeName"}',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${loginResponse!.accessToken}"
        });
    if (response.statusCode == 401) {
      Navigation(navigationKey: Navigation.navigation_Key)
          .navigateAndRemoveUntil(routeName: RoutesNames.homeRoute);
      on401UnAuthorizedUser!();
      return null;
    } else if (response.statusCode == 200) {
      return PrintReceiveMoneyResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("unable to print Receive Money");
    }
  }
}
