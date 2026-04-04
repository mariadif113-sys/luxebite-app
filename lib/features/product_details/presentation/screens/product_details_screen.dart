import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_application_1/features/menu/domain/models/menu_models.dart';
import 'package:flutter_application_1/features/cart/presentation/controllers/cart_controller.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';
import 'package:flutter_application_1/core/utils/currency_formatter.dart';
import 'package:flutter_application_1/features/menu/data/repositories/menu_repository.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final MenuItem item;
  const ProductDetailsScreen({super.key, required this.item});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final reviewsAsync = ref.watch(reviewsProvider(widget.item.id));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GlassmorphicContainer(
            width: 40,
            height: 40,
            borderRadius: 20,
            blur: 10,
            alignment: Alignment.center,
            border: 1,
            linearGradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            ),
            borderGradient: LinearGradient(
              colors: [theme.primaryColor.withOpacity(0.5), theme.primaryColor.withOpacity(0.2)],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 18),
              onPressed: () {
                HapticsManager.light();
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GlassmorphicContainer(
              width: 40,
              height: 40,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 1,
              linearGradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
              ),
              borderGradient: LinearGradient(
                colors: [theme.primaryColor.withOpacity(0.5), theme.primaryColor.withOpacity(0.2)],
              ),
              child: IconButton(
                icon: Icon(Icons.favorite_border, color: theme.primaryColor, size: 20),
                onPressed: () => HapticsManager.light(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image with Parallax
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Hero(
              tag: 'product_image_${widget.item.id}',
              child: Image.network(
                widget.item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ).animate().fadeIn(duration: 800.ms),

          // Content Scroll
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.45),
                GlassmorphicContainer(
                  width: size.width,
                  height: size.height * 1.2, // Taller for reviews
                  borderRadius: 40,
                  blur: 25,
                  alignment: Alignment.topLeft,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.brightness == Brightness.dark 
                        ? const Color(0xFF1A1A1A).withOpacity(0.9) 
                        : Colors.white.withOpacity(0.9),
                      theme.brightness == Brightness.dark 
                        ? const Color(0xFF0F0F0F).withOpacity(0.8) 
                        : Colors.white.withOpacity(0.8),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor.withOpacity(0.5),
                      theme.primaryColor.withOpacity(0.1),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAr ? widget.item.nameAr : (isFr ? widget.item.nameFr : widget.item.nameEn),
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isAr ? widget.item.nameAr : (isFr ? widget.item.nameFr : widget.item.nameEn),
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyFormatter.dzd(widget.item.price, isAr: isAr),
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                        const SizedBox(height: 30),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statTile(Icons.timer_outlined, '25 MIN', theme),
                            _statTile(Icons.local_fire_department_outlined, '450 CAL', theme),
                            _statTile(Icons.star, '4.9 RATING', theme),
                          ],
                        ).animate().fadeIn(delay: 400.ms),

                        const SizedBox(height: 30),

                        Text(
                          isAr ? 'تجربة الذواقة' : (isFr ? 'L\'EXPÉRIENCE GOURMET' : 'THE GOURMET EXPERIENCE'),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isAr ? widget.item.descriptionAr : (isFr ? widget.item.descriptionFr : widget.item.descriptionEn),
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            height: 1.6,
                          ),
                        ).animate().fadeIn(delay: 600.ms),

                        const SizedBox(height: 40),

                        // Reviews Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAr ? 'آراء العملاء' : (isFr ? 'AVIS CLIENTS' : 'CUSTOMER REVIEWS'),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                                color: theme.primaryColor,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white24),
                          ],
                        ),
                        const SizedBox(height: 15),
                        reviewsAsync.when(
                          data: (reviews) {
                            if (reviews.isEmpty) {
                              return Text(isAr ? 'لا يوجد آراء بعد. كن الأول!' : (isFr ? 'Aucun avis pour le moment.' : 'No reviews yet. Be the first!'), style: GoogleFonts.outfit(color: Colors.white24, fontSize: 14));
                            }
                            return Column(
                              children: reviews.take(2).map((r) => _buildReviewCard(r, theme)).toList(),
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Text(isAr ? 'خطأ في تحميل المراجعات' : (isFr ? 'Erreur de chargement' : 'Error loading reviews'), style: GoogleFonts.outfit(color: Colors.red)),
                        ),

                        const SizedBox(height: 40),

                        // Controls
                        Row(
                          children: [
                            GlassCard(
                              width: 140,
                              height: 60,
                              borderRadius: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 20),
                                    onPressed: () {
                                      HapticsManager.light();
                                      setState(() => quantity = quantity > 1 ? quantity - 1 : 1);
                                    },
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 20),
                                    onPressed: () {
                                      HapticsManager.light();
                                      setState(() => quantity++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  HapticsManager.success();
                                  for (int i = 0; i < quantity; i++) {
                                    ref.read(cartProvider.notifier).addItem(widget.item);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isAr ? 'تمت الإضافة بنجاح' : (isFr ? 'Ajouté au panier' : 'Added to basket')),
                                      backgroundColor: theme.primaryColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      isAr ? 'أضف للسلة' : (isFr ? 'AJOUTER AU PANIER' : 'ADD TO BASKET'),
                                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(IconData icon, String label, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.primaryColor, size: 20),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Review review, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: GlassCard(
        height: 80,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: const Icon(Icons.person, size: 15, color: Colors.white24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 10,
                        color: index < review.rating ? Colors.amber : Colors.white10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.comment,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
