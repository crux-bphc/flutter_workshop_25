import 'package:flutter/material.dart';
import 'package:flutter_workshop_25/models/expense.dart';
import 'package:flutter_workshop_25/screens/home_screen.dart';
import 'package:flutter_workshop_25/services/hive_service.dart';
import 'package:flutter_workshop_25/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_workshop_25/providers/expense_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider(),
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
