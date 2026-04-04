import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/home/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.primaryColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 50,
                color: theme.primaryColor,
              ),
            )
            .animate()
            .scale(duration: 1200.ms, curve: Curves.elasticOut)
            .shimmer(delay: 1500.ms, duration: 1800.ms),

            const SizedBox(height: 30),

            // App Name
            Text(
              'LUXEBITE',
              style: GoogleFonts.playfairDisplay(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: theme.primaryColor,
              ),
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 1000.ms)
            .slideY(begin: 0.2, end: 0, duration: 1200.ms, curve: Curves.easeOutCubic),

            const SizedBox(height: 10),

            // Tagline in Arabic/English
            Text(
              'EXPERIENCE EXCELLENCE • تجربة التميز',
              style: GoogleFonts.outfit(
                fontSize: 12,
                letterSpacing: 2,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            )
            .animate()
            .fadeIn(delay: 1200.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
