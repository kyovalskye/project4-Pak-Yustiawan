import 'package:flutter/material.dart';
import 'config/supabase_config.dart';
import 'pages/home_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const PPDBApp());
}

class PPDBApp extends StatelessWidget {
  const PPDBApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPDB Online',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
