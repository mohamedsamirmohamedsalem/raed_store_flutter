import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/bill_screen.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/utils/navigation/navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToReceiveMoney(),
                      child: Card(
                        color: Colors.red,
                        child: Container(
                            alignment: Alignment.center,
                            child: Text("receive_money".tr())),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {_navigateToBillScreen(BillType.saleBill)},
                      child: Card(
                        color: Colors.yellow,
                        child: Container(
                            alignment: Alignment.center,
                            child: const Text("sale_bill").tr()),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {_navigateToBillScreen(BillType.returnBill)},
                      child: Card(
                        color: Colors.green,
                        child: Container(
                            alignment: Alignment.center,
                            child: Text("return_bill".tr())),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {},
                      child: Card(
                        color: Colors.blue,
                        child: Container(
                            alignment: Alignment.center, child: Text("Card 4")),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  void _navigateToReceiveMoney() {
    Navigation(navigationKey: Navigation.navigation_Key)
        .navigateTo(routeName: RoutesNames.receiveMoneyRoute);
  }

  void _navigateToBillScreen(BillType saleBill) {
    Navigation(navigationKey: Navigation.navigation_Key)
        .navigateTo(routeName: RoutesNames.billRoute, arg: saleBill);
  }

  
}
