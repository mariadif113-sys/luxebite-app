import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/shared/providers/restaurant_provider.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final settings = ref.watch(restaurantProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(
          isAr ? 'إعدادات المطعم' : (isFr ? 'PARAMÈTRES' : 'RESTAURANT SETTINGS'),
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
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
            // Admin Note Section
            _buildSectionHeader(isAr ? 'تنبيه الزبائن' : (isFr ? 'ALERTE CLIENT' : 'CUSTOMER ALERT'), theme),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  TextField(
                    maxLines: 3,
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: isAr ? 'اكتب ملاحظة للزبائن هنا...' : (isFr ? 'Écrire une alerte...' : 'Write an alert for customers...'),
                      hintStyle: const TextStyle(color: Colors.white30),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) => ref.read(restaurantProvider.notifier).updateNote(val),
                    controller: TextEditingController(text: settings.adminNote)..selection = TextSelection.collapsed(offset: settings.adminNote.length),
                  ),
                  const Divider(color: Colors.white10),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'ستظهر هذه الملاحظة في أعلى الشاشة الرئيسية' : (isFr ? 'Cette note apparaît sur l\'écran d\'accueil' : 'This note appears at the top of the Home Screen'),
                        style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // Open/Close Status Section
            _buildSectionHeader(isAr ? 'حالة المطعم الحالية' : (isFr ? 'ÉTAT DU RESTAURANT' : 'CURRENT RESTAURANT STATUS'), theme),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      color: settings.isOpen ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: (settings.isOpen ? Colors.green : Colors.red).withOpacity(0.3), blurRadius: 10, spreadRadius: 2)],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    settings.isOpen ? (isAr ? 'مفتوح الآن' : (isFr ? 'OUVERT' : 'OPEN NOW')) : (isAr ? 'مغلق الآن' : (isFr ? 'FERMÉ' : 'CLOSED NOW')),
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 15),
                  ),
                  const Spacer(),
                  Switch(
                    value: settings.isManualOverride ? settings.isManuallyOpen : settings.isOpen,
                    activeColor: theme.primaryColor,
                    onChanged: (val) {
                      HapticsManager.medium();
                      ref.read(restaurantProvider.notifier).setManualStatus(val);
                    },
                  ),
                ],
              ),
            ),
            if (settings.isManualOverride)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: GestureDetector(
                  onTap: () => ref.read(restaurantProvider.notifier).resetToAuto(),
                  child: Text(
                    isAr ? 'الرجوع للتوقيت التلقائي' : (isFr ? 'RÉTABLIR LE PROGRAMME' : 'RESET TO AUTOMATIC SCHEDULE'),
                    style: GoogleFonts.outfit(fontSize: 11, color: theme.primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ),
              ),

            const SizedBox(height: 35),

            // Operating Hours Section
            _buildSectionHeader(isAr ? 'توقيت العمل (تلقائي)' : (isFr ? 'HORAIRES (AUTOMATIQUE)' : 'OPERATING HOURS (AUTOMATIC)'), theme),
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    isAr ? 'وقت الفتح' : (isFr ? 'OUVERTURE' : 'OPENING'),
                    settings.openingTime,
                    context,
                    (time) => ref.read(restaurantProvider.notifier).setOpeningTime(time),
                    theme,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTimePicker(
                    isAr ? 'وقت الغلق' : (isFr ? 'FERMETURE' : 'CLOSING'),
                    settings.closingTime,
                    context,
                    (time) => ref.read(restaurantProvider.notifier).setClosingTime(time),
                    theme,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
            
            // Footer
            Center(
              child: Opacity(
                opacity: 0.3,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png', height: 40, errorBuilder: (_,__,___) => const Icon(Icons.restaurant, color: Colors.white, size: 30)),
                    const SizedBox(height: 10),
                    Text('LuxeBite Management Console v2.0', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 15),
      child: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, BuildContext context, Function(TimeOfDay) onSelect, ThemeData theme) {
    return GestureDetector(
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(primary: theme.primaryColor, onPrimary: Colors.black, surface: const Color(0xFF1A1A1A)),
              ),
              child: child!,
            );
          },
        );
        if (newTime != null) {
          HapticsManager.light();
          onSelect(newTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: theme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
