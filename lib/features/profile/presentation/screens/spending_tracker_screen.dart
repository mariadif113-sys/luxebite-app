import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/menu/data/repositories/menu_repository.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/core/utils/currency_formatter.dart';

class SpendingTrackerScreen extends ConsumerWidget {
  const SpendingTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final budgetAsync = ref.watch(budgetProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'محفظة لوكس' : 'LUXE WALLET',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 20),
          onPressed: () {
            HapticsManager.light();
            Navigator.pop(context);
          },
        ),
      ),
      body: budgetAsync.when(
        data: (budget) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Gaming-style Radial Progress
              Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow Effect
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.2),
                              blurRadius: 50,
                              spreadRadius: 10,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                       .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2000.ms),

                      CircularProgressIndicator(
                        value: budget.percent,
                        strokeWidth: 15,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      ).animate().custom(
                        duration: 1500.ms,
                        curve: Curves.easeOutExpo,
                        builder: (context, value, child) => CircularProgressIndicator(
                          value: value * budget.percent,
                          strokeWidth: 15,
                          backgroundColor: Colors.white10,
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                        ),
                      ),
                      
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isAr ? 'المصروف' : 'SPENT',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Colors.white30,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            CurrencyFormatter.dzd(budget.currentSpend, isAr: isAr),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '/ ${CurrencyFormatter.dzd(budget.monthlyLimit, isAr: isAr)}',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: theme.primaryColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Breakdown Cards
              _buildMetricCard(
                isAr ? 'المتبقي' : 'REMAINING',
                CurrencyFormatter.dzd(budget.remaining, isAr: isAr),
                Icons.account_balance_wallet_outlined,
                theme,
              ),
              const SizedBox(height: 15),
              _buildMetricCard(
                isAr ? 'المعدل اليومي' : 'DAILY AVERAGE',
                CurrencyFormatter.dzd(budget.currentSpend / 15, isAr: isAr),
                Icons.analytics_outlined,
                theme,
              ),

              const SizedBox(height: 40),

              // Set Goal Button
              GestureDetector(
                onTap: () => HapticsManager.medium(),
                child: GlassCard(
                  height: 65,
                  child: Center(
                    child: Text(
                      isAr ? 'تعديل الحد الشهري' : 'ADJUST MONTHLY LIMIT',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, ThemeData theme) {
    return GlassCard(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white30,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
