import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://ckdwlllmyoirjcyfvqoz.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNrZHdsbGxteW9pcmpjeWZ2cW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc4MjkyNjcsImV4cCI6MjA3MzQwNTI2N30.uGgoIV6erpv-5gwE0RyflCWQouxo-3xPMQaCh-MpXcc';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
