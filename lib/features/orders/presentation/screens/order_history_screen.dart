import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/core/utils/currency_formatter.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final orders = [
      {
        'date': isAr ? '24\nأكتوبر' : '24\nOCT',
        'id': '#LX-8892',
        'price': 8500.0,
        'items': isAr ? 'ريب آي بالترفل، موكتيل لازوردي' : 'Truffle Ribeye, Azure Mocktail',
        'status': isAr ? 'تم التوصيل' : 'DELIVERED',
      },
      {
        'date': isAr ? '18\nأكتوبر' : '18\nOCT',
        'id': '#LX-8721',
        'price': 4200.0,
        'items': isAr ? 'كاربونارا بالترفل، تيراميسو ذهبي' : 'Truffle Carbonara, Gold Tiramisu',
        'status': isAr ? 'تم التوصيل' : 'DELIVERED',
      },
      {
        'date': isAr ? '12\nأكتوبر' : '12\nOCT',
        'id': '#LX-8650',
        'price': 12400.0,
        'items': isAr ? 'تشكيلة مشاوي، بيتزا ترفل، شاي مغربي' : 'Mixed Grill, Truffle Pizza, Moroccan Tea',
        'status': isAr ? 'تم التوصيل' : 'DELIVERED',
      },
      {
        'date': isAr ? '5\nأكتوبر' : '5\nOCT',
        'id': '#LX-8490',
        'price': 6800.0,
        'items': isAr ? 'واغيو سماش برجر، لاسي المانغو' : 'Wagyu Smash Burger, Mango Lassi',
        'status': isAr ? 'تم التوصيل' : 'DELIVERED',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF150926), // Deep Royal Velvet background
      appBar: AppBar(
        title: Text(
          isAr ? 'سجل الطلبات' : 'ORDER HISTORY',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 20),
          onPressed: () { HapticsManager.light(); Navigator.pop(context); },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Magazine Date Column
                Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 2,
                        height: index == 0 ? 0 : 15,
                        color: theme.primaryColor.withValues(alpha: 0.2),
                      ),
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: theme.primaryColor.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order['date'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20, fontWeight: FontWeight.w900,
                          color: theme.primaryColor, height: 1.0,
                        ),
                      ),
                      Container(
                        width: 2, height: 80,
                        color: theme.primaryColor.withValues(alpha: 0.15),
                        margin: const EdgeInsets.only(top: 6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassCard(
                    height: 160,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['id'] as String,
                              style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 2)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(order['status'] as String,
                                style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: theme.primaryColor, letterSpacing: 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          CurrencyFormatter.dzd(order['price'] as double, isAr: isAr),
                          style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w900, color: theme.primaryColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order['items'] as String,
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70, height: 1.4),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () { HapticsManager.medium(); },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  isAr ? 'إعادة الطلب' : 'REORDER',
                                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 * (index + 1))).slideX(begin: 0.1);
        },
      ),
    );
  }
}