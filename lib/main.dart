import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase in a non-blocking way with a timeout
  Future<void> initSupabase() async {
    try {
      await Supabase.initialize(
        url: 'https://clxulygjzlakqlkvksbq.supabase.com',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNseHVseWdqemxha3Fsa3Zrc2JxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUxMjUyNDgsImV4cCI6MjA5MDcwMTI0OH0.ugthSLrYFm_UdNekGm2EVsN2ubLw9JRCV-9FOYA4s78',
      );
    } catch (e) {
      debugPrint('Supabase failed to initialize: $e');
    }
  }

  // Proceed to runApp if Supabase is slow or failing (2s limit)
  await Future.any([
    initSupabase(),
    Future.delayed(const Duration(seconds: 2)),
  ]);

  runApp(
    const ProviderScope(
      child: LuxeBiteApp(),
    ),
  );
}

class LuxeBiteApp extends ConsumerWidget {
  const LuxeBiteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return MaterialApp(
      title: 'LuxeBite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
        Locale('fr', ''), // French
      ],
      home: const SplashScreen(),
    );
  }
}
