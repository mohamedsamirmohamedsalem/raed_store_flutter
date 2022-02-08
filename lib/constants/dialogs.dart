
import 'package:flutter/material.dart';
import 'package:raed_store/constants/text_styles.dart';

class Dialogs {
  static showAlertDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String positiveTitle,
    required String negativeTitle,
    required Function positiveCallback,
    required Function negativeCallback,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(title),
        content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(body),
                  ],
                ),
              )
            ,
        actions: <Widget>[
          positiveTitle != null
              ? FlatButton(
                  shape: StadiumBorder(),
                  child: Text(positiveTitle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (positiveCallback != null) {
                      positiveCallback();
                    }
                  },
                )
              : SizedBox(),
          FlatButton(
              shape: const StadiumBorder(),
              child: Text(negativeTitle),
              onPressed: () {
                if (negativeCallback != null) {
                  negativeCallback();
                }
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  static showErrorMsg(GlobalKey<ScaffoldState> key, String msg,
      { int? duration}) {
    key.currentState!.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration ?? 5),
        content: Text(
          msg,
          style: kWhiteTextStyle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 3,
        ),
      ),
    );
  }

  static buildSnackBar(String text, GlobalKey<ScaffoldState> scaffoldKey,
      {int duration = 3}) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

}
