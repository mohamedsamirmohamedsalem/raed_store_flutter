import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/utils/navigation/navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            height: MediaQuery
                .of(context)
                .size
                .height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _navigateToReceiveMoney(),
                          child: Card(
                            color: Colors.red,
                            child: Container(
                                alignment: Alignment.center, child: Text(
                                "receive_money".tr())),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => {},
                          child: Card(
                            color: Colors.yellow,
                            child: Container(alignment: Alignment.center,
                                child: Text("Card 2")),
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
                          onTap: () => {},
                          child: Card(
                            color: Colors.green,
                            child: Container(alignment: Alignment.center,
                                child: Text("Card 3")),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => {},
                          child: Card(
                            color: Colors.blue,
                            child: Container(alignment: Alignment.center,
                                child: Text("Card 4")),
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
    Navigation(navigationKey: Navigation.navigation_Key).navigateTo(
        routeName: RoutesNames.receiveMoneyRoute);
  }
}
