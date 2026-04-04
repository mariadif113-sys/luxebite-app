import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/admin/presentation/screens/manage_orders_screen.dart';
import 'package:flutter_application_1/features/admin/presentation/screens/manage_menu_screen.dart';
import 'package:flutter_application_1/features/admin/presentation/screens/admin_settings_screen.dart';
import 'package:flutter_application_1/features/admin/presentation/screens/analytics_screen.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(
          isAr ? 'لوحة تحكم المدير' : (isFr ? 'DASHBOARD ADMIN' : 'ADMIN PORTAL'),
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildAdminCard(
              context,
              title: isAr ? 'إعدادات المتجر' : 'RESTAURANT SETTINGS',
              subtitle: isAr ? 'الملاحظات، التوقيت، وحالة الفتح' : 'Alerts, hours, and open/closed status',
              icon: Icons.settings_suggest_rounded,
              onTap: () {
                HapticsManager.light();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              context,
              title: isAr ? 'إدارة الطلبات' : 'MANAGE ORDERS',
              subtitle: isAr ? 'عرض وتحديث حالات الطلبات الجارية' : 'Monitor and update active orders',
              icon: Icons.receipt_long_rounded,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageOrdersScreen()));
              },
            ),
            const SizedBox(height: 20),
            _buildAdminCard(
              context,
              title: isAr ? 'إدارة القائمة' : 'MANAGE MENU',
              subtitle: isAr ? 'إضافة أو تعديل أو حذف الأطباق' : 'Add, edit, or remove menu items',
              icon: Icons.restaurant_menu_rounded,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageMenuScreen()));
              },
            ),
            const SizedBox(height: 20),
            _buildAdminCard(
              context,
              title: isAr ? 'إحصائيات المطعم' : (isFr ? 'STATISTIQUES' : 'RESTAURANT ANALYTICS'),
              subtitle: isAr ? 'عرض الإيرادات والبيانات' : (isFr ? 'Voir les revenus et les données' : 'View revenue and sales insights'),
              icon: Icons.analytics_rounded,
              onTap: () {
                HapticsManager.light();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            Center(
              child: TextButton.icon(
                onPressed: () {
                  HapticsManager.medium();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent, size: 18),
                label: Text(
                  isAr ? 'تسجيل الخروج من الإدارة' : 'LOGOUT ADMIN',
                  style: GoogleFonts.outfit(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: theme.primaryColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 16),
          ],
        ),
      ),
    );
  }
}
