import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentations/pet/pet_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Store App',
      theme: AppTheme.lightTheme,
      home: const PetListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
