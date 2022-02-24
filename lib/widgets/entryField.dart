import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  TextEditingController? controller;
  bool isPassword;
  String? title;
  bool isValid;
  String errorMessage;

  EntryField({Key? key,
    @required this.controller,
    @required this.title,
    this.isValid = true,
    this.errorMessage = "",
    this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              errorText: isValid ? null : errorMessage,
              label: Text(
                title ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 20),
              ),
              focusColor: Colors.yellow,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow, width: 2.0),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              fillColor: Colors.white30 /*Color(0xfff3f3f4)*/,
              filled: true,
            ),
          )
        ],
      ),
    );
  }
}
