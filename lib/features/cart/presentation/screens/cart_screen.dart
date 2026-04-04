import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/cart/presentation/controllers/cart_controller.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/core/utils/currency_formatter.dart';
import 'package:flutter_application_1/shared/widgets/success_dialog.dart';
import 'package:flutter_application_1/shared/providers/restaurant_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final restaurantSettings = ref.watch(restaurantProvider);
    final isOpen = restaurantSettings.isOpen;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'سلة المشتريات' : (isFr ? 'VOTRE PANIER' : 'THE LUXE BASKET'),
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
      body: cartItems.isEmpty
          ? _buildEmptyState(theme, isAr, isFr)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(item, cartNotifier, theme, isAr, isFr);
                    },
                  ),
                ),
                _buildSummary(cartItems, cartNotifier, theme, isAr, isFr, context, isOpen),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isAr, bool isFr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 100, color: theme.primaryColor.withOpacity(0.2)),
          const SizedBox(height: 30),
          Text(
            isAr ? 'سلتك فارغة' : (isFr ? 'VOTRE PANIER EST VIDE' : 'YOUR BASKET IS EMPTY'),
            style: GoogleFonts.outfit(
              fontSize: 22, 
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isAr ? 'استكشف قائمتنا الرائعة وأضف بعض الأصناف.' : (isFr ? 'Explorez notre menu et faites-vous plaisir.' : 'Explore our world-class menu and treat yourself.'),
            style: GoogleFonts.outfit(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.4)),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn().scale(),
    );
  }

  Widget _buildCartItem(CartItem item, CartNotifier notifier, ThemeData theme, bool isAr, bool isFr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassCard(
        height: 110,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                item.menuItem.imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[800], width: 85, height: 85),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isAr ? item.menuItem.nameAr : (isFr ? item.menuItem.nameFr : item.menuItem.nameEn),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18, 
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.dzd(item.menuItem.price, isAr: isAr),
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16, color: Colors.white54),
                    onPressed: () {
                      HapticsManager.light();
                      notifier.updateQuantity(item.menuItem.id, item.quantity - 1);
                    },
                  ),
                  Text(
                    item.quantity.toString(),
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 16, color: theme.primaryColor),
                    onPressed: () {
                      HapticsManager.light();
                      notifier.updateQuantity(item.menuItem.id, item.quantity + 1);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildSummary(List<CartItem> items, CartNotifier notifier, ThemeData theme, bool isAr, bool isFr, BuildContext context, bool isOpen) {
    final subtotal = notifier.totalPrice;
    final delivery = 350.0;
    final total = subtotal + delivery;

    return GlassCard(
      height: 240,
      borderRadius: 40,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          _summaryRow(isAr ? 'المجموع الفرعي' : (isFr ? 'SOUS-TOTAL' : 'SUBTOTAL'), CurrencyFormatter.dzd(subtotal, isAr: isAr), theme, isAr),
          const SizedBox(height: 12),
          _summaryRow(isAr ? 'التوصيل' : (isFr ? 'LIVRAISON' : 'DELIVERY'), CurrencyFormatter.dzd(delivery, isAr: isAr), theme, isAr),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Colors.white10),
          ),
          _summaryRow(isAr ? 'الإجمالي' : (isFr ? 'TOTAL' : 'TOTAL'), CurrencyFormatter.dzd(total, isAr: isAr), theme, isAr, isTotal: true),
          const Spacer(),
          GestureDetector(
            onTap: () {
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
                title: isAr ? 'تم الطلب بنجاح' : (isFr ? 'COMMANDE PASSÉE' : 'ORDER PLACED'),
                message: isAr ? 'سيصلك طعامك الراقي قريباً جداً.' : (isFr ? 'Votre commande arrive bientôt.' : 'Your gourmet experience will arrive shortly.'),
              );
            },
            child: Opacity(
              opacity: isOpen ? 1.0 : 0.5,
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (isOpen) BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Center(
                  child: Text(
                    isAr ? 'تأكيد الطلب' : (isFr ? 'CONFIRMER' : 'CONFIRM ORDER'),
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _summaryRow(String label, String value, ThemeData theme, bool isAr, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 16 : 12,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            letterSpacing: 2,
            color: theme.colorScheme.onSurface.withOpacity(isTotal ? 1 : 0.4),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: isTotal ? theme.primaryColor : Colors.white,
          ),
        ),
      ],
    );
  }
}
