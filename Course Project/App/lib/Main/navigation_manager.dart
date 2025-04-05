import 'package:flutter/material.dart';

import './MainScreen.dart';
import './side_panel/AboutUs.dart';
import './side_panel/ExitApp.dart';
import '../CommonML/NoImage.dart';

class NavigationManager {
  static void drawerPageIndex(BuildContext context, int curPage) {
    if (curPage == 1) {
      allNavigation(context, curPage);
    } else if (curPage == 2) {
      exitApp(context);
    } else if (curPage == 3) {
      aboutUs(context);
    }
  }

  static void mainMenuIndex(BuildContext context, int curPage) {
    if (curPage == 1) {
      allNavigation(context, curPage);
    }
  }

  static void tabIndex(BuildContext context, int curPage) {
    if (curPage == 1) {
      allNavigation(context, curPage);
    } else if (curPage == 2) {
      exitApp(context);
    }
  }

  static void allNavigation(BuildContext context, int curPage) {
    if (curPage == 1) {
      Navigator.of(context).pushReplacementNamed(RemoteML.routeName);
    }
  }

  static void noImgError(BuildContext context) {
    noImageError(context);
  }

  static void predictionResult(BuildContext context) {
    predictionResult(context);
  }
}
