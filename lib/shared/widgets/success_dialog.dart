import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<void> show(BuildContext context, {required String title, required String message}) {
    HapticsManager.success();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(title: title, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GlassCard(
          height: 400,
          borderRadius: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Lottie.network(
                  'https://lottie.host/8554284d-2a14-4a25-a1c1-4b13689c1694/K7yF9V9Q9m.json',
                  repeat: false,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  HapticsManager.light();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'GRANDIOSE',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
