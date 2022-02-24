import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/bill_screen.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:raed_store/utils/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  BuildContext? context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    NetworkManager().on401UnAuthorizedUser = _on401UnAuthorizedUser;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.yellow,
          title: Text(
            "home".tr(),
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, size: 30, color: Colors.black),
            onPressed: () => _logout(context),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              _registerHeader(),
              Container(
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
                              child: _buildnavigationCard(
                                  "receive_money".tr(), Icons.money),
                            ),
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: () =>
                                {_navigateToBillScreen(BillType.saleBill)},
                            child: _buildnavigationCard(
                                "sale_bill".tr(), Icons.list),
                          ))
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
                              onTap: () =>
                                  {_navigateToBillScreen(BillType.returnBill)},
                              child: _buildnavigationCard("return_bill".tr(),
                                  Icons.settings_backup_restore),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => {},
                              child: _buildnavigationCard(
                                  "Card 4", Icons.card_giftcard),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Card _buildnavigationCard(String title, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.yellow, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      color: Colors.white,
      child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.yellow,
                size: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Widget _registerHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: 200,
      height: 100,
      child:
          const Image(image: AssetImage('assets/images/raad_store_logo.jpeg')),
    );
  }

  void _navigateToReceiveMoney() {
    Navigation(navigationKey: Navigation.navigation_Key)
        .navigateTo(routeName: RoutesNames.receiveMoneyRoute);
  }

  void _navigateToBillScreen(BillType saleBill) {
    Navigation(navigationKey: Navigation.navigation_Key)
        .navigateTo(routeName: RoutesNames.billRoute, arg: saleBill);
  }

  void _logout(BuildContext context) async {
    Navigation(navigationKey: Navigation.navigation_Key)
        .navigateAndRemoveUntil(routeName: RoutesNames.loginRoute);
    _forgetLoginResponseToSharedPereferance();
  }

  Future<void> _forgetLoginResponseToSharedPereferance() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_response");
  }

  void _on401UnAuthorizedUser() {
    showDialog(
        context: context!,
        builder: (_) => AlertDialog(
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                    ),
                    onPressed: () =>
                        Navigation(navigationKey: Navigation.navigation_Key)
                            .goBack(),
                    child: Text("ok".tr()))
              ],
              title: Text('alert'.tr()),
              content: Text('unauthorized_user'.tr()),
            ));
  }
}
