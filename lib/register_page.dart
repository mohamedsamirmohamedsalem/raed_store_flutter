import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:raed_store/widgets/custom_app_bar.dart';
import 'package:raed_store/widgets/entryField.dart';
import 'package:raed_store/utils/string_extenstions.dart';

import 'constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  bool _isValidEmail = true;
  bool _isValidPassword = true;
  bool _isValidPasswordConfirmation = true;
  String _emailErrorMessage = "";
  String _passwordErrorMessage = "";
  String _passwordConfirmationErrorMessage = "";

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBarWithBackButton(context, "Register"),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _registerHeader(),
              _registerTitle(),
              _registerEmail(),
              _registerPassword(),
              _registerConfirmPassword(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: const Text("Raad_store").tr(),
    );
  }

  Widget _registerTitle() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: const Text("register").tr(),
    );
  }

  Widget _registerEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: EntryField(
        title: "email".tr(),
        errorMessage: _emailErrorMessage,
        isValid: _isValidEmail,
        controller: _emailController,
      ),
    );
  }

  Widget _registerPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: EntryField(
        title: "password".tr(),
        errorMessage: _passwordErrorMessage,
        isValid: _isValidPassword,
        controller: _passwordController,
      ),
    );
  }

  Widget _registerConfirmPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: EntryField(
        title: "confirm_password".tr(),
        errorMessage: _passwordConfirmationErrorMessage,
        isValid: _isValidPasswordConfirmation,
        controller: _confirmPasswordController,
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      color: kPrimaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: InkWell(
        onTap: () => _validateInputs(),
        child: const Text("register").tr(),
      ),
    );
  }

  void _validateInputs() async {
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();

    if (_isValidEmail && _isValidPassword && _isValidPasswordConfirmation) {
      String response = await NetworkManager().registerUser(
          _emailController!.value.text,
          _passwordController!.value.text,
          _confirmPasswordController!.value.text);
      if (kDebugMode) {
        print(response);
      }
    } else {
      setState(() {});
    }
  }

  void _validateConfirmPassword() {
    if (_confirmPasswordController!.value.text.isEmpty) {
      _isValidPasswordConfirmation = false;
      _passwordConfirmationErrorMessage = 'value_not_empty'.tr();
    } else {
      if (_confirmPasswordController!.text
          .isStringIdentical(_passwordController!.value.text)) {
        _isValidPasswordConfirmation = true;
      } else {
        _isValidPasswordConfirmation = false;
        _passwordConfirmationErrorMessage = "confirm_password_not_match".tr();
      }
    }
  }

  void _validatePassword() {
    if (_passwordController!.value.text.isEmpty) {
      _isValidPassword = false;
      _passwordErrorMessage = 'value_not_empty'.tr();
    } else {
      if (_passwordController!.value.text.isValidPasswordLength(8)) {
        if (_passwordController!.value.text.isValidPassword()) {
          _isValidPassword = true;
        } else {
          _isValidPassword = false;
          _passwordErrorMessage = "password_validation".tr();
        }
      } else {
        _passwordErrorMessage = 'value_greater_than_5_char'.tr();
        _isValidPassword = false;
      }
    }
  }

  void _validateEmail() {
    if (_emailController!.value.text.isEmpty) {
      _isValidEmail = false;
      _emailErrorMessage = 'value_not_empty'.tr();
    } else {
      if (_emailController!.value.text.isValidEmail()) {
        _isValidEmail = true;
      } else {
        _isValidEmail = false;
        _emailErrorMessage = 'enter_valid_email';
      }
    }
  }
}
