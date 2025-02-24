import 'package:flutter/material.dart';
import 'package:flutter_application_1/telalogin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fwplueegssrbcffmxduu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3cGx1ZWVnc3NyYmNmZm14ZHV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAzNDQ3ODksImV4cCI6MjA1NTkyMDc4OX0.lDnykEd6eAWCsJ5dnBoYD-ZZ6TtrBaJdbqL1zWKulI8',
  );

  runApp(const MaterialApp(
    home: TelaLogin(),
    debugShowCheckedModeBanner: false,
  ));
}
