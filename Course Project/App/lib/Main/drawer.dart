import 'package:flutter/material.dart';

import './NavigationManager.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildDrawerItem(
            icon: Icons.settings_remote_outlined,
            label: 'Fruit Object Classifier',
            onTap: () => NavigationManager.drawerPageIndex(context, 1),
          ),
          _buildDrawerItem(
            icon: Icons.info_outline_rounded,
            label: 'About',
            onTap: () => NavigationManager.drawerPageIndex(context, 3),
          ),
          const Spacer(),
          _buildDrawerItem(
            icon: Icons.logout,
            label: 'Exit',
            onTap: () => NavigationManager.drawerPageIndex(context, 2),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Helvetica',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white10,
      splashColor: Colors.white24,
    );
  }
}
