import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/constants/app_dimensions.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:raed_store/tab_bar_view.dart';
import 'package:raed_store/utils/navigation/navigation.dart';
import 'package:raed_store/utils/string_extenstions.dart';
import 'package:raed_store/widgets/entryField.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/colors.dart';
import 'constants/routes.dart';
import 'constants/text_styles.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // LogInModel _logInModel;
  late SnackBar snackBar;

  // bool _isPasswordShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 60, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _loginButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _loginHeader(),
        Text("welcome".tr(),
            style: kBigBlackTextStyle.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 20),
        _emailPasswordWidget(),
        const SizedBox(height: 10),
        _submitButton(),
        // SizedBox(height: 10),
        // Container(
        //   padding: EdgeInsets.symmetric(vertical: 10),
        //   alignment: Alignment.centerRight,
        //   child: Text(Languages.of(context).kForgotPassword,
        //       style: TextStyle(
        //           fontSize: 14, fontWeight: FontWeight.w500)),
        // ),
        const SizedBox(height: 20),
        _createAccountLabel(),
        const SizedBox(height: 20),
        // _divider(Languages.of(context).kOrUsing),
        // facebookAndGoogle(),
        // SizedBox(height: 10),
        // _divider("Or"),
        // const SizedBox(height: 10),
        // _skipButton(),
      ],
    );
  }
   Widget _loginHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: 200,
      height: 100,
      child:
          const Image(image: AssetImage('assets/images/raad_store_logo.jpeg')),
    );
  }


  Widget _skipButton() {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          Navigation(navigationKey: navigatorKey)
              .navigateTo(routeName: RoutesNames.tabBarMainView);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kPrimaryColor),
        ),
        child: const Text(
          "Skip",
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return RoundedLoadingButton(
      height: 50,
      elevation: 3,
      width: 180,//AppDimensions.width,
      borderRadius: 15,
      animateOnTap: true,
      color: kPrimaryColor,
      controller: _btnController,
      onPressed: _login,
      child:  Text(
        "login".tr(),
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

  void _login() async {
    _btnController.start();
    if (emailController.value.text.isValidEmail() &&
        passwordController.value.text.isValidPasswordLength(6)) {
      var loginResponse;
      try {
        loginResponse = await NetworkManager()
            .login(emailController.value.text, passwordController.value.text);
      } catch (e) {
        showDialogError();
      }
      if (loginResponse != null) {
        await saveLoginResponseToSharedPereferance(loginResponse);
        Navigation(navigationKey: Navigation.navigation_Key)
            .navigateTo(routeName: RoutesNames.homeRoute);
        // save login response to SB
      }
    } else {
      showDialogError();
    }

    _btnController.reset();
  }

  void showDialogError() {
     showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
              title: Text('alert'.tr()),
              content: Text('unable_to_login'.tr()),
            ));
  }

  Future<void> saveLoginResponseToSharedPereferance(loginResponse) async {
     final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_response", json.encode(loginResponse));
  }

  Widget _divider(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 20),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(text),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
         Text(
          "NoAccount".tr(),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => Navigation(navigationKey: navigatorKey)
              .navigateTo(routeName: RoutesNames.registerRoute),
          child:  Text(
            "register".tr(),
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        EntryField(title: "email".tr(), controller: emailController),
        EntryField(
            title: "Password".tr(),
            isPassword: true,
            controller: passwordController),
      ],
    );
  }
}
