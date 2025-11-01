import 'package:flutter/material.dart';
import 'package:flutter_workshop_25/models/expense.dart';
import 'package:flutter_workshop_25/screens/home_screen.dart';
import 'package:flutter_workshop_25/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
