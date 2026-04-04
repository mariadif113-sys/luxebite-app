import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_application_1/features/cart/presentation/controllers/cart_controller.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/currency_formatter.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int selectedPayment = 0;
  static const double _deliveryFee = 350;
  final TextEditingController _addressController = TextEditingController(text: 'الجزائر العاصمة، بن عكنون، حي باديس');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF150926), // Royal background
      appBar: AppBar(
        title: Text(
          isAr ? 'إتمام الطلب' : 'CHECKOUT',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Section
            _sectionTitle(isAr ? 'عنوان التوصيل' : 'DELIVERY ADDRESS', theme),
            const SizedBox(height: 15),
            GlassCard(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: theme.primaryColor),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: theme.primaryColor.withValues(alpha: 0.5), size: 18),
                ],
              ),
            ).animate().fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 30),

            // Payment Methods
            _sectionTitle(isAr ? 'طريقة الدفع' : 'PAYMENT METHOD', theme),
            const SizedBox(height: 15),
            _paymentOption(0, isAr ? 'بطاقة الائتمان' : 'Credit Card', Icons.credit_card, theme),
            const SizedBox(height: 12),
            _paymentOption(1, isAr ? 'دفع إلكتروني' : 'Online Payment', Icons.account_balance_wallet_outlined, theme),
            const SizedBox(height: 12),
            _paymentOption(2, isAr ? 'الدفع عند الاستلام' : 'Cash on Delivery', Icons.payments_outlined, theme),

            const SizedBox(height: 40),

            // Order Summary
            _sectionTitle(isAr ? 'ملخص الطلب' : 'ORDER SUMMARY', theme),
            const SizedBox(height: 15),
            GlassCard(
              height: 160,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _summaryLine(
                    isAr ? 'مجموع الأصناف' : 'Items Total',
                    CurrencyFormatter.dzd(cartNotifier.totalPrice, isAr: isAr),
                    theme,
                  ),
                  const SizedBox(height: 10),
                  _summaryLine(
                    isAr ? 'رسوم التوصيل' : 'Delivery Fee',
                    CurrencyFormatter.dzd(_deliveryFee, isAr: isAr),
                    theme,
                  ),
                  const Divider(height: 25, color: Colors.white10),
                  _summaryLine(
                    isAr ? 'المجموع الكلي' : 'Grand Total',
                    CurrencyFormatter.dzd(cartNotifier.totalPrice + _deliveryFee, isAr: isAr),
                    theme,
                    isBold: true,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 50),

            // Place Order Button
            GestureDetector(
              onTap: () => _handlePlaceOrder(context, isAr, theme),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: theme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Center(
                  child: Text(
                    isAr ? 'تأكيد الطلب' : 'CONFIRM ORDER',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 3),
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
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _paymentOption(int index, String label, IconData icon, ThemeData theme) {
    final isSelected = selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = index),
      child: GlassCard(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        borderColor: isSelected ? theme.primaryColor : Colors.white10,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.4)),
            const SizedBox(width: 15),
            Text(label, style: GoogleFonts.outfit(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: theme.primaryColor),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 200 + (index * 100)));
  }

  Widget _summaryLine(String label, String value, ThemeData theme, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 14, color: isBold ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.6))),
        Text(value, style: GoogleFonts.outfit(fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isBold ? theme.primaryColor : theme.colorScheme.onSurface)),
      ],
    );
  }

  void _handlePlaceOrder(BuildContext context, bool isAr, ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _OrderSuccessDialog(theme: theme, isAr: isAr),
    );
  }
}

class _OrderSuccessDialog extends StatelessWidget {
  final ThemeData theme;
  final bool isAr;
  const _OrderSuccessDialog({required this.theme, this.isAr = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassmorphicContainer(
        width: 300,
        height: 420,
        borderRadius: 40,
        blur: 30,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            theme.brightness == Brightness.dark 
              ? const Color(0xFF2B1B47).withValues(alpha: 0.8) 
              : Colors.black.withValues(alpha: 0.05),
            const Color(0xFF150926).withValues(alpha: 0.9)
          ],
        ),
        borderGradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, size: 55, color: Colors.black),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            const SizedBox(height: 30),
            Text(
              isAr ? 'تم الطلب بنجاح!' : 'Order Confirmed!',
              style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              isAr ? 'يتم تحضير طلبك بعناية فائقة.' : 'Your gourmet experience is\nbeing prepared with care.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.white60, height: 1.5),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Container(
                width: 200,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    isAr ? 'العودة للرئيسية' : 'BACK TO HOME',
                    style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
