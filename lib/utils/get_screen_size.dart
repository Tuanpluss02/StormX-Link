import 'package:flutter/material.dart';

enum ScreenType { mobile, tab, web }

ScreenType getScreenType(BuildContext context) {
  double scrWidth = MediaQuery.of(context).size.width;
  if (scrWidth > 915) {
    return ScreenType.web;
  } else if (scrWidth < 650) {
    return ScreenType.mobile;
  }
  return ScreenType.tab;
}

bool isMobile(BuildContext context) =>
    getScreenType(context) == ScreenType.mobile;

bool isTab(BuildContext context) => getScreenType(context) == ScreenType.tab;

bool isWeb(BuildContext context) => getScreenType(context) == ScreenType.web;
