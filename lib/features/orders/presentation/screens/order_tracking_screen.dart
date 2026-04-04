import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ORDER STATUS',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Current Status Card
            GlassCard(
              height: 120,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.soup_kitchen_outlined, color: theme.primaryColor, size: 30),
                  ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Preparing order...', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('Estimated delivery: 25 min', style: GoogleFonts.outfit(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.1),

            const SizedBox(height: 40),

            // Timeline
            _buildTimelineStep('Order Placed', 'Your order has been received.', true, true, theme),
            _buildTimelineStep('Preparing', 'Our chef is crafting your gourmet experience.', true, true, theme),
            _buildTimelineStep('On the way', 'A courier is heading to your location.', false, false, theme),
            _buildTimelineStep('Delivered', 'Enjoy your exquisite meal!', false, false, theme, isLast: true),

            const SizedBox(height: 50),

            // Help/Support
            GlassmorphicContainer(
              width: double.infinity,
              height: 60,
              borderRadius: 30,
              blur: 15,
              alignment: Alignment.center,
              border: 1,
              linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
              borderGradient: LinearGradient(colors: [theme.primaryColor.withOpacity(0.3), theme.primaryColor.withOpacity(0.1)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headset_mic_outlined, color: theme.primaryColor, size: 20),
                  const SizedBox(width: 15),
                  Text('NEED ASSISTANCE?', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, bool isCompleted, bool isActive, ThemeData theme, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? theme.primaryColor : Colors.transparent,
                  border: Border.all(color: isCompleted ? theme.primaryColor : Colors.white24, width: 2),
                ),
                child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.black) : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? theme.primaryColor.withOpacity(0.5) : Colors.white10,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isCompleted ? theme.colorScheme.onSurface.withOpacity(0.6) : theme.colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 200 * (4))); // Simplified delay
  }
}
