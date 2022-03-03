import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/ReceiveMoneyScreen.dart';
import 'package:raed_store/bill_screen.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/homeScreen.dart';
import 'package:raed_store/invoicesList.dart';
import 'package:raed_store/login_page.dart';
import 'package:raed_store/pdf_print_screen.dart';
import 'package:raed_store/receivedMoneyList.dart';
import 'package:raed_store/register_page.dart';
import 'package:raed_store/tab_bar_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  log("Route Name:" + settings.name.toString());
  log("Route arg:" + settings.arguments.toString());

  switch (settings.name) {
    case RoutesNames.loginRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    case RoutesNames.tabBarMainView:
      return MaterialPageRoute(
        builder: (context) => const TabBarMainView(),
      );
    case RoutesNames.registerRoute:
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );

    case RoutesNames.homeRoute:
      return MaterialPageRoute(
        builder: (context) =>  HomeScreen(),
      );

    case RoutesNames.receiveMoneyRoute :
      return MaterialPageRoute(
        builder: (context) => const ReceiveMoneyScreen(),
      );
    case RoutesNames.billRoute :
      return MaterialPageRoute(
        builder: (context) => BillScreen(billType: settings.arguments as BillType)
      );
      case RoutesNames.invoiceHistoryRoute:
        return MaterialPageRoute(
        builder: (context) => InvoicesHistoryScreen()
      );
       case RoutesNames.receiptHistoryRoute:
        return MaterialPageRoute(
        builder: (context) => const ReceiveMoneyHistory()
      );
      case RoutesNames.pdfPrinterScreen:
      return MaterialPageRoute(
        builder: (context) =>  PDFPrint(file:settings.arguments as File ,)
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  }
}
