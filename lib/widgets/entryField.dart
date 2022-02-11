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
          Text(
            title ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              errorText: isValid ? null : errorMessage,
              border: InputBorder.none,
              fillColor: Colors.white30 /*Color(0xfff3f3f4)*/,
              filled: true,
            ),
          )
        ],
      ),
    );
  }
}
