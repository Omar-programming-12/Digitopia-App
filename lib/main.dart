import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/main_navigation.dart';
import 'clear_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  await Supabase.initialize(
    url: 'https://hzolhiplwpycqldeudgk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6b2xoaXBsd3B5Y3FsZGV1ZGdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3MDM5MDYsImV4cCI6MjA3MzI3OTkwNn0.BeSadD1DqrSBsJEs6vR_ZbzJJvzAypE6Yk9pTIXnhe4',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digitopia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
