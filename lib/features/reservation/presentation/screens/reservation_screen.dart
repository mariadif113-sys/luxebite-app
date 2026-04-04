import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/shared/widgets/success_dialog.dart';
import 'package:flutter_application_1/shared/providers/restaurant_provider.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key});

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '19:00';
  int persons = 2;

  final List<String> timeSlots = [
    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'حجز طاولة' : (isFr ? 'RÉSERVER' : 'BOOK A TABLE'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              isAr ? 'عش تجربة استثنائية' : (isFr ? 'VIVEZ L\'EXTRAORDINAIRE' : 'EXPERIENCE THE EXTRAORDINARY'),
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: theme.primaryColor,
              ),
            ).animate().fadeIn().slideX(begin: -0.1),
            const SizedBox(height: 10),
            Text(
              isAr ? 'احجز لحظتك الحصرية' : (isFr ? 'Réservez votre moment' : 'Reserve Your Exclusive Moment'),
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
            ).animate().fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 40),

            // Date Selection
            _sectionTitle(isAr ? 'اختر التاريخ' : (isFr ? 'CHOISIR LA DATE' : 'SELECT DATE'), theme),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                HapticsManager.light();
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: theme.colorScheme.copyWith(
                          primary: theme.primaryColor,
                          onPrimary: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) setState(() => selectedDate = date);
              },
              child: GlassCard(
                height: 75,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(isAr ? 'EEEE، d MMMM' : (isFr ? 'EEEE d MMMM y' : 'EEEE, MMMM d, y'), isAr ? 'ar' : (isFr ? 'fr' : 'en')).format(selectedDate),
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Icon(Icons.calendar_month_outlined, color: theme.primaryColor, size: 24),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 30),

            // Time Selection
            _sectionTitle(isAr ? 'اختر الوقت' : (isFr ? 'CHOISIR L\'HEURE' : 'SELECT TIME'), theme),
            const SizedBox(height: 15),
            SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final time = timeSlots[index];
                  final isSelected = selectedTime == time;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        HapticsManager.light();
                        setState(() => selectedTime = time);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.primaryColor : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected ? [BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 15)] : [],
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: isSelected ? Colors.black : Colors.white30,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 30),

            // Persons
            _sectionTitle(isAr ? 'عدد الضيوف' : (isFr ? 'NOMBRE D\'INVITÉS' : 'NUMBER OF GUESTS'), theme),
            const SizedBox(height: 15),
            GlassCard(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_outline, color: theme.primaryColor, size: 24),
                      const SizedBox(width: 20),
                      Text(
                        isAr ? '$persons أشخاص' : (isFr ? '$persons PERSONNES' : '$persons PERSONS'),
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _counterBtn(Icons.remove, () {
                        HapticsManager.light();
                        setState(() => persons = persons > 1 ? persons - 1 : 1);
                      }),
                      const SizedBox(width: 10),
                      _counterBtn(Icons.add, () {
                        HapticsManager.light();
                        setState(() => persons++);
                      }, color: theme.primaryColor),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 50),

            // Confirm Button
            GestureDetector(
              onTap: () {
                final isOpen = ref.watch(restaurantProvider).isOpen;
                if (!isOpen) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(isAr ? 'نعتذر، المطعم مغلق حالياً' : (isFr ? 'Désolé, le restaurant est fermé' : 'Sorry, the restaurant is currently closed')),
                    ),
                  );
                  return;
                }
                HapticsManager.medium();
                SuccessDialog.show(
                  context, 
                  title: isAr ? 'جاهزون لاستقبالك' : (isFr ? 'TABLE RÉSERVÉE' : 'TABLE RESERVED'),
                  message: isAr ? 'تم حجز طاولتك ليوم ${DateFormat('MMM d').format(selectedDate)} في الساعة $selectedTime.' : (isFr ? 'Votre table est réservée pour le ${DateFormat('d MMM').format(selectedDate)} à $selectedTime.' : 'Your table is secured for ${DateFormat('MMM d').format(selectedDate)} at $selectedTime.'),
                );
              },
              child: Opacity(
                opacity: ref.watch(restaurantProvider).isOpen ? 1.0 : 0.5,
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (ref.watch(restaurantProvider).isOpen) BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isAr ? 'تأكيد الحجز' : (isFr ? 'CONFIRMER' : 'CONFIRM RESERVATION'),
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 3),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
        color: theme.primaryColor.withOpacity(0.6),
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ?? Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color?.withOpacity(0.3) ?? Colors.white10),
        ),
        child: Icon(icon, size: 18, color: color ?? Colors.white54),
      ),
    );
  }
}
