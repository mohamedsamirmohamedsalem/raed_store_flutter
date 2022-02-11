
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:raed_store/widgets/entryField.dart';
import 'package:raed_store/utils/string_extenstions.dart';

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
      appBar: AppBar(),
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
      child: const Text("Raad Store"),
    );
  }

  Widget _registerTitle() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: const Text("Register"),
    );
  }

  Widget _registerEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: EntryField(
        title: "email",
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
        title: "password",
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
        title: "confirm_password",
        errorMessage: _passwordConfirmationErrorMessage,
        isValid: _isValidPasswordConfirmation,
        controller: _confirmPasswordController,
      ),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: () => _validateInputs(),
      child: const Text("register"),
    );
  }


  void _validateInputs() async {
    if (_validateEmail() &&
        _validatePassword() &&
        _validateConfirmPassword()) {
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

  bool _validateConfirmPassword() {
    if(_confirmPasswordController!.value.text.isEmpty){
      _isValidPasswordConfirmation = false;
      _passwordConfirmationErrorMessage = 'Value Can\'t Be Empty';
      return false;
    }else {
      if(_confirmPasswordController!.text.isStringIdentical(_passwordController!.value.text)){
        _isValidPasswordConfirmation = true;
        return true;
      }else {
        _isValidPasswordConfirmation = false;
        _passwordConfirmationErrorMessage = "confirm password not matching password";
        return false;
      }
    }
  }

  bool _validatePassword() {
     if( _passwordController!.value.text.isEmpty){
      _isValidPassword = false;
      _passwordErrorMessage = 'Value Can\'t Be Empty';
      return false;
    }else {
      if(_passwordController!.value.text.isValidPasswordLength(6)){
        if(_passwordController!.value.text.isValidPassword()) {
          _isValidPassword = true;
          return true;
        }else{
          _isValidPassword=false;
          _passwordErrorMessage = "password must contain upper characters , numbers and lower characters";
          return false;
        }
      }
      else {
        _passwordErrorMessage = 'password should be greater than 5 char';
        _isValidPassword = false;
        return false;
      }
    }
  }

  bool _validateEmail() {
     if (_emailController!.value.text.isEmpty) {
      _isValidEmail = false;
      _emailErrorMessage = 'Value Can\'t Be Empty';
      return false;
    } else {
      if (_emailController!.value.text.isValidEmail()) {
        _isValidEmail = true;
        return true;
      } else {
        _isValidEmail = false;
        _emailErrorMessage = 'enter a valid email';
        return false;
      }
    }
  }


}
