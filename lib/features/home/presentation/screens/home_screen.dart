import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/menu/data/repositories/menu_repository.dart';
import 'package:flutter_application_1/features/menu/domain/models/menu_models.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/features/product_details/presentation/screens/product_details_screen.dart';
import 'package:flutter_application_1/features/cart/presentation/screens/cart_screen.dart';
import 'package:flutter_application_1/features/reservation/presentation/screens/reservation_screen.dart';
import 'package:flutter_application_1/features/cart/presentation/controllers/cart_controller.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/core/utils/currency_formatter.dart';
import 'package:flutter_application_1/features/menu/presentation/screens/offers_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/spending_tracker_screen.dart';
import 'package:flutter_application_1/features/orders/presentation/screens/order_history_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_application_1/shared/providers/restaurant_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final categoriesAsync = ref.watch(categoriesProvider);
    final menuItemsAsync = ref.watch(menuItemsProvider(selectedCategoryId));
    final offersAsync = ref.watch(offersProvider);
    final restaurantSettings = ref.watch(restaurantProvider);
    final isOpen = restaurantSettings.isOpen;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: theme.brightness == Brightness.dark
                      ? [const Color(0xFF0F0F0F), const Color(0xFF1A1A1A), const Color(0xFF0F0F0F)]
                      : [const Color(0xFFFDFBF7), Colors.white, const Color(0xFFFDFBF7)],
                ),
              ),
            ),
          ),

          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header & Wallet
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'صباح الخير، زبوننا' : (isFr ? 'Bonjour, cher client' : 'Good Morning, Guest'),
                            style: GoogleFonts.outfit(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                isAr ? 'اكتشف أطباقنا' : (isFr ? 'Découvrez les saveurs' : 'Discover Flavors'),
                                style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w900, color: theme.primaryColor, height: 1.1),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isOpen ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: (isOpen ? Colors.green : Colors.red).withOpacity(0.5)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6, height: 6,
                                      decoration: BoxDecoration(color: isOpen ? Colors.green : Colors.red, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isOpen ? (isAr ? 'مفتوح' : (isFr ? 'OUVERT' : 'OPEN')) : (isAr ? 'مغلق' : (isFr ? 'FERMÉ' : 'CLOSED')),
                                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: isOpen ? Colors.green : Colors.red, letterSpacing: 1),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(delay: 500.ms).scale(),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                      
                      Row(
                        children: [
                          _headerAction(Icons.account_balance_wallet_rounded, () {
                            HapticsManager.medium();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SpendingTrackerScreen()));
                          }),
                          const SizedBox(width: 10),
                          _headerAction(Icons.receipt_rounded, () {
                            HapticsManager.light();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Offers Carousel
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: offersAsync.when(
                    data: (offers) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              HapticsManager.light();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
                            },
                            child: GlassCard(
                              width: 300,
                              height: 160,
                              padding: EdgeInsets.zero,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Image.network(offer.imageUrl, fit: BoxFit.cover, width: 300, height: 160),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SPECIAL OFFER',
                                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: theme.primaryColor, letterSpacing: 2),
                                        ),
                                        Text(
                                          isAr ? offer.titleAr : (isFr ? offer.titleFr : offer.titleEn),
                                          style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'CLAIM NOW',
                                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => const SizedBox.shrink(),
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ),

              // Admin Note Banner
              if (restaurantSettings.adminNote.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 25, 24, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.campaign_rounded, color: Colors.black, size: 28),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAr ? 'تنبيه من الإدارة' : 'ADMIN NOTICE',
                                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.5),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isAr ? 'اطلب الآن وقرب وجبتك' : (isFr ? 'Commandez maintenant' : 'Order Now & Enjoy'),
                                  style: GoogleFonts.outfit(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().shimmer(duration: 2.seconds).shake(hz: 0.5),
                  ),
                ),

              // Categories
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 35, 24, 15),
                      child: Text(
                        isAr ? 'الأقسام' : 'CATEGORIES',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      child: categoriesAsync.when(
                        data: (categories) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final isSelected = selectedCategoryId == cat.id;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: GestureDetector(
                                onTap: () {
                                  HapticsManager.light();
                                  setState(() => selectedCategoryId = cat.id);
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
                                      isAr ? cat.nameAr : (isFr ? cat.nameFr : cat.nameEn),
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
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
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms),
              ),

              // Menu Items Grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 120),
                sliver: menuItemsAsync.when(
                  data: (items) => SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 20,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return MenuGridItem(item: item, isAr: isAr, isFr: isFr);
                      },
                      childCount: items.length,
                    ),
                  ),
                  loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                  error: (err, stack) => const SliverFillRemaining(child: Center(child: Text('Error loading menu'))),
                ),
              ),
            ],
          ),

          // Bottom Navigation (Solid dark for clarity)
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _navBtn(Icons.grid_view_rounded, isAr ? 'الرئيسية' : 'Home', true, theme, () {})),
                    Expanded(child: _navBtn(Icons.restaurant_rounded, isAr ? 'القائمة' : 'Menu', false, theme, () {
                      HapticsManager.light();
                      setState(() => selectedCategoryId = null);
                      _scrollController.animateTo(
                        400, // Approximate position of categories
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutBack,
                      );
                    })),
                    _navCircleBtn(Icons.add, theme, () {
                      HapticsManager.medium();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationScreen()));
                    }),
                    Expanded(child: _navBtn(Icons.shopping_cart_rounded, isAr ? 'السلة' : 'Cart', false, theme, () {
                      HapticsManager.light();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                    }, isCart: true)),
                    Expanded(child: _navBtn(Icons.person_pin_rounded, isAr ? 'زبون' : 'Customer', false, theme, () {
                      HapticsManager.light();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    }, badge: '4')),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5, end: 0),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        width: 45,
        height: 45,
        borderRadius: 15,
        padding: EdgeInsets.zero,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _navCircleBtn(IconData icon, ThemeData theme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _navBtn(IconData icon, String label, bool isActive, ThemeData theme, VoidCallback onTap, {bool isCart = false, String? badge}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? theme.primaryColor : Colors.white54,
                size: 24,
              ),
              if (isCart || badge != null)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final content = isCart ? '${ref.watch(cartProvider).length}' : badge!;
                      if (isCart && content == '0') return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isCart ? Colors.red : theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          content,
                          style: TextStyle(
                            color: isCart ? Colors.white : Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().scale();
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? theme.primaryColor : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuGridItem extends ConsumerWidget {
  final MenuItem item;
  final bool isAr;
  final bool isFr;
  const MenuGridItem({super.key, required this.item, required this.isAr, required this.isFr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartProvider);
    final isInCart = cart.any((i) => i.menuItem.id == item.id);
    final isOpen = ref.watch(restaurantProvider).isOpen;

    return GestureDetector(
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
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(item: item)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.white10, child: const Icon(Icons.restaurant, color: Colors.white24)),
                      ),
                      if (!isOpen)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                              child: Text(isAr ? 'مغلق' : (isFr ? 'FERMÉ' : 'CLOSED'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    isAr ? item.nameAr : item.nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CurrencyFormatter.dzd(item.price, isAr: isAr),
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: theme.primaryColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!isOpen) return;
                          HapticsManager.light();
                          ref.read(cartProvider.notifier).addItem(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isOpen ? (isInCart ? theme.primaryColor : Colors.white10) : Colors.white10,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isInCart ? Icons.check : Icons.add,
                            size: 16,
                            color: isOpen ? (isInCart ? Colors.black : Colors.white) : Colors.white24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
