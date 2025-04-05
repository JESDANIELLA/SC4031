import 'package:flutter/material.dart';
import 'package:starsearch_fixed/Main/MainScreen.dart'; // ✅ correct path based on your screenshot

void main() {
  runApp(const StarSearchApp());
}

class StarSearchApp extends StatelessWidget {
  const StarSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Detection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RemoteML(), // 👈 launches the image detection screen
    );
  }
}
