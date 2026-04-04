import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/admin/presentation/screens/admin_login_screen.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';
import 'package:flutter_application_1/features/orders/presentation/screens/order_history_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/spending_tracker_screen.dart';
import 'package:flutter_application_1/features/reservation/presentation/screens/reservation_screen.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/core/providers/notifications_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final user = ref.watch(userProvider);
    final notificationsEnabled = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isAr ? 'حسابي و الإعدادات' : 'ACCOUNT & SETTINGS',
          style: GoogleFonts.outfit(
            fontSize: 16,
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primaryColor, width: 2),
                      boxShadow: [
                        BoxShadow(color: theme.primaryColor.withOpacity(0.15), blurRadius: 25, spreadRadius: 2),
                      ],
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.person_outline_rounded, size: 55, color: Colors.white38),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, size: 16, color: Colors.black),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(duration: 600.ms),

            const SizedBox(height: 20),
            Text(user?.email?.split('@').first.toUpperCase() ?? 'GUEST CUSTOMER', 
                 style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 4),
            Text(isAr ? 'عضو ذهبي' : 'GOLD MEMBER', 
                 style: GoogleFonts.outfit(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.w900, letterSpacing: 1.5)),

            const SizedBox(height: 40),

            // Settings Group: Account
            _buildSectionHeader(isAr ? 'الحساب' : 'ACCOUNT', theme),
            _buildSettingsItem(
              isAr ? 'المعلومات الشخصية' : 'Personal Information', 
              Icons.person_outline, 
              theme,
              onTap: () {
                 HapticsManager.light();
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const SpendingTrackerScreen()));
              }
            ),
            _buildSettingsItem(
              isAr ? 'سجل الطلبات' : 'Order History', 
              Icons.receipt_long_outlined, 
              theme,
              onTap: () {
                 HapticsManager.light();
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
              }
            ),
            _buildSettingsItem(
              isAr ? 'حجوزاتي' : 'My Reservations', 
              Icons.calendar_today_outlined, 
              theme,
              onTap: () {
                 HapticsManager.light();
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationScreen()));
              }
            ),
            
            const SizedBox(height: 30),

            // Settings Group: App
            _buildSectionHeader(isAr ? 'التطبيق' : 'APP SETTINGS', theme),
            _buildSettingsItem(
              isAr ? 'اللغة' : 'Language', 
              Icons.language_outlined, 
              theme,
              onTap: () { 
                HapticsManager.light();
                _showLanguageDialog(context, ref);
              }
            ),
            _buildSettingsItem(
              isAr ? 'الإشعارات' : (isFr ? 'Notifications' : 'Notifications'), 
              Icons.notifications_none_outlined, 
              theme,
              trailing: Switch(
                value: notificationsEnabled,
                activeColor: theme.primaryColor,
                onChanged: (val) {
                   HapticsManager.success();
                   ref.read(notificationsProvider.notifier).state = val;
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text(val 
                         ? (isAr ? 'تم تفعيل الإشعارات' : (isFr ? 'Notifications activées' : 'Notifications enabled'))
                         : (isAr ? 'تم إيقاف الإشعارات' : (isFr ? 'Notifications désactivées' : 'Notifications disabled'))),
                       duration: const Duration(seconds: 1),
                       backgroundColor: theme.primaryColor,
                     ),
                   );
                },
              ),
            ),
            
            const SizedBox(height: 30),

            // Settings Group: Admin (The key part)
            _buildSectionHeader(isAr ? 'نظام الإدارة' : 'ADMINISTRATION', theme),
            _buildSettingsItem(
              isAr ? 'دخول المدير' : 'Admin Access', 
              Icons.admin_panel_settings_rounded, 
              theme, 
              isSpecial: true,
              onTap: () {
                HapticsManager.medium();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                );
              },
            ),

            const SizedBox(height: 50),

            // Logout (Changed to go back home in this context as we removed the old login)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(isAr ? 'الخروج' : 'EXIT SETTINGS', 
                             style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white30)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.read(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isAr ? 'اختر اللغة' : (isFr ? 'Choisir la langue' : 'Select Language'),
          style: GoogleFonts.outfit(color: theme.primaryColor, fontWeight: FontWeight.bold),
          textAlign: isAr ? TextAlign.right : TextAlign.left,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, ref, 'العربية', const Locale('ar'), locale.languageCode == 'ar'),
            _languageOption(context, ref, 'English', const Locale('en'), locale.languageCode == 'en'),
            _languageOption(context, ref, 'Français', const Locale('fr'), locale.languageCode == 'fr'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, WidgetRef ref, String label, Locale locale, bool isSelected) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(label, style: GoogleFonts.outfit(color: isSelected ? theme.primaryColor : Colors.white70)),
      trailing: isSelected ? Icon(Icons.check_circle, color: theme.primaryColor) : null,
      onTap: () {
        ref.read(languageProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 15),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: theme.primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, ThemeData theme, {bool isSpecial = false, VoidCallback? onTap, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        height: 60,
        padding: EdgeInsets.zero,
        borderRadius: 20,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(icon, color: isSpecial ? theme.primaryColor : Colors.white70, size: 20),
                  const SizedBox(width: 15),
                  Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: isSpecial ? FontWeight.w900 : FontWeight.w500, color: isSpecial ? theme.primaryColor : Colors.white)),
                  const Spacer(),
                  if (trailing != null) trailing else Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }
}
