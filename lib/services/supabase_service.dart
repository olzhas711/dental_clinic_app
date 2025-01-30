import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://oxkwyrclgkpymzhvvpdy.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94a3d5cmNsZ2tweW16aHZ2cGR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgxNjI0MDAsImV4cCI6MjA1MzczODQwMH0.OIy1jJ8WTKJ-ou9HmpaYBp4TOSJ594QiNGCFD6CNCJQ',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
