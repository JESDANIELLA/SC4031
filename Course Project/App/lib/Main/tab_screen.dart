import 'package:flutter/material.dart';
import './NavigationManager.dart';

// ignore: must_be_immutable
class TabScreen extends StatelessWidget {
  TabScreen(int curPage) {
    this.curPage = curPage - 1;
  }

  late BuildContext context1;
  late int curPage;

  void _curPage(int index) {
    index++;
    NavigationManager.tabIndex(context1, index);
  }

  @override
  Widget build(BuildContext context) {
    context1 = context;

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1C1C1E),
      onTap: _curPage,
      currentIndex: curPage,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.w400,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.device_hub_outlined),
          label: 'Classify',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Exit',
        ),
      ],
    );
  }
}
