import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isAr ? 'إحصائيات المطعم' : (isFr ? 'STATISTIQUES' : 'RESTAURANT ANALYTICS'),
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard(isAr ? 'إجمالي الدخل' : 'REVENUE', '485.5K', 'DZD', theme, Icons.payments_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(isAr ? 'الطلبات' : 'ORDERS', '1,248', '', theme, Icons.shopping_bag_rounded)),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(isAr ? 'متوسط السلة' : 'AVG ORDER', '3,890', 'DZD', theme, Icons.analytics_rounded),

            const SizedBox(height: 40),

            // Best Sellers
            _buildSectionHeader(isAr ? 'الأكثر مبيعاً' : 'TOP BESTSELLERS', theme),
            const SizedBox(height: 15),
            _buildPopularItem('Truffle Ribeye Steak', '458', '8.2%', true, theme, isAr, isFr),
            _buildPopularItem('Premium Tacos', '312', '5.4%', true, theme, isAr, isFr),
            _buildPopularItem('Mixed Grill', '285', '4.1%', false, theme, isAr, isFr),

            const SizedBox(height: 40),

            // Category Distribution
            _buildSectionHeader(isAr ? 'توزيع الأقسام' : 'CATEGORY PERFORMANCE', theme),
            const SizedBox(height: 20),
            _buildCategoryBar(isAr ? 'أطباق رئيسية' : 'Main Dishes', 0.85, theme),
            _buildCategoryBar(isAr ? 'برجر' : 'Burgers', 0.65, theme),
            _buildCategoryBar(isAr ? 'أكل سريع' : 'Fast Food', 0.45, theme),
            _buildCategoryBar(isAr ? 'مشروبات' : 'Drinks', 0.30, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, ThemeData theme, IconData icon) {
    return GlassCard(
      height: 120,
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 1.5)),
              Icon(icon, color: theme.primaryColor.withOpacity(0.5), size: 16),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(width: 4),
              Text(unit, style: GoogleFonts.outfit(fontSize: 10, color: theme.primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(duration: 600.ms);
  }

  Widget _buildPopularItem(String name, String count, String growth, bool isUp, ThemeData theme, bool isAr, bool isFr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        borderRadius: 20,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Center(child: Text(name.substring(0, 1), style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$count sold', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70)),
                Row(
                  children: [
                    Icon(isUp ? Icons.trending_up : Icons.trending_flat, color: isUp ? Colors.green : Colors.grey, size: 12),
                    const SizedBox(width: 4),
                    Text(growth, style: GoogleFonts.outfit(fontSize: 10, color: isUp ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildCategoryBar(String title, double progress, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70)),
            Text('${(progress * 100).toInt()}%', style: GoogleFonts.outfit(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.5)]),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Row(
      children: [
        Container(width: 2, height: 12, color: theme.primaryColor),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white)),
      ],
    );
  }
}
