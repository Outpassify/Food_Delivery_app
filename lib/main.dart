import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_manager/Admin/Dashboard.dart';
import 'package:inventory_manager/Admin/MenuManagementScreen.dart';
import 'package:inventory_manager/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print("🔥 Firebase initialization error: $e");
    runApp(const MaterialApp(home: Text("Firebase Error!")));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  home:AdminHome()
);
  }
}

