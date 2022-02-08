
import 'package:flutter/material.dart';
import 'package:raed_store/constants/colors.dart';
import 'package:raed_store/constants/text_styles.dart';

class CustomAppBar {
  static AppBar getAppBar(String title, {List<Widget>? actions}) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text(title, style: kWhiteTextStyle),
      centerTitle: (actions ?? []).isNotEmpty ? false : true,
      actions: actions ?? [],
    );
  }

  static AppBar getAppBarWithBackButton(
      BuildContext context,
      String title, {
        List<Widget>? actions,
        double? elevation,
        required Function leadingAction,
      }) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: elevation,
      title: Text(title, style: kWhiteTextStyle),
      centerTitle: (actions ?? []).isNotEmpty ? false : true,
      leading: IconButton(
        onPressed: ()=>leadingAction,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      actions: actions ?? [],
    );
  }

  static AppBar getSearchAppBar(BuildContext context, Widget searchWidget,
      {List<Widget>? actions}) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: searchWidget,
      centerTitle: (actions ?? []).isNotEmpty ? false : true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      actions: actions ?? [],
    );
  }
}
