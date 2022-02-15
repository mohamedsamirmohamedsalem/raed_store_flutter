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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        _divider("kOr"),
        const SizedBox(height: 10),
        _skipButton(),
      ],
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
          "kSkip",
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
      width: AppDimensions.width,
      borderRadius: 15,
      animateOnTap: true,
      color: kPrimaryColor,
      controller: _btnController,
      onPressed: _login,
      child: const Text(
        "kLogin",
        style: TextStyle(fontSize: 20, color: Colors.white),
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
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  title: Text('Error'),
                  content: Text('Unable to Login'),
                ));
      }
      if (loginResponse != null) {
        await saveLoginResponseToSharedPereferance(loginResponse);
        Navigation(navigationKey: Navigation.navigation_Key)
            .navigateTo(routeName: RoutesNames.homeRoute);
        // save login response to SB
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text('Error'),
                content: Text('Unable to Login'),
              ));
    }

    _btnController.reset();
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
        const Text(
          "kNoAccount",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => Navigation(navigationKey: navigatorKey)
              .navigateTo(routeName: RoutesNames.registerRoute),
          child: const Text(
            "kRegister",
            style: TextStyle(
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
        EntryField(title: "email", controller: emailController),
        EntryField(
            title: "kPassword",
            isPassword: true,
            controller: passwordController),
      ],
    );
  }

  //API:- Section
  Future _callAPI() async {
    // Map<String, String> postRequestData = {
    //   "email": emailController.text,
    //   "password": passwordController.text,
    // };
    //
    // var res = await NetworkingHelper(endPoint: kLoginApi)
    //     .postData(postRequest: postRequestData);
    // logInModel = LogInModel.fromJson(res);
    // if (_logInModel.status == NetworkStatus.success) {
    //   final user = _logInModel.data.user;
    //   final userToken = _logInModel.token;
    //   user.password = passwordController.text;
    //   UserSingleton().setUser(user, userToken);
    //   print("userToken : $userToken");
    //   AppNavigator.pushReplacement(context: context, widget: TabBarMainView());
    // } else {
    //   Dialogs.buildSnackBar(_logInModel?.errorModel?.message ?? Strings.kErrorMessage,
    //       _scaffoldKey);
    // }
  }
}
