import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/menu/data/repositories/menu_repository.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'عروض حصرية' : 'EXCLUSIVE OFFERS',
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
      body: offersAsync.when(
        data: (offers) {
          if (offers.isEmpty) {
            return Center(
              child: Text(
                isAr ? 'لا يوجد عروض نشطة حالياً.' : 'No active offers at the moment.', 
                style: GoogleFonts.outfit(color: Colors.white30)
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Youthful Card Stack
              SizedBox(
                height: 480,
                child: Stack(
                  alignment: Alignment.center,
                  children: offers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final offer = entry.value;
                    final isTop = index == _currentIndex;
                    
                    if (index < _currentIndex) return const SizedBox.shrink();

                    return Positioned(
                      top: 20.0 * (index - _currentIndex),
                      child: GestureDetector(
                        onTap: isTop ? () => HapticsManager.light() : null,
                        child: Transform.scale(
                          scale: 1.0 - (0.05 * (index - _currentIndex)),
                          child: GlassCard(
                            width: 320,
                            height: 440,
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                // Image Header
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                                      image: DecorationImage(
                                        image: NetworkImage(offer.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(25),
                                      alignment: isAr ? Alignment.bottomRight : Alignment.bottomLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: theme.primaryColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 10)],
                                            ),
                                            child: Text(
                                              isAr ? '${offer.discountPercentage}٪ خصم' : '${offer.discountPercentage}% OFF',
                                              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            isAr ? offer.titleAr : offer.titleEn,
                                            style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Details
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isAr ? offer.descriptionAr : offer.descriptionEn,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70, height: 1.4),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              isAr ? 'صالح حتى: ٢٥ أكتوبر' : 'VALID UNTIL: 25 OCT',
                                              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 2),
                                            ),
                                            Icon(isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios, color: theme.primaryColor, size: 16),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate(target: isTop ? 1 : 0)
                     .fadeIn(duration: 500.ms)
                     .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOutBack);
                  }).toList().reversed.toList(),
                ),
              ),

              const SizedBox(height: 50),

              // Navigation Dot Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  offers.length,
                  (index) => Container(
                    width: index == _currentIndex ? 28 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index == _currentIndex ? theme.primaryColor : Colors.white10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ).animate().scale(),
                ),
              ),

              const SizedBox(height: 30),

              // Button to next
              GestureDetector(
                onTap: () {
                  HapticsManager.medium();
                  setState(() {
                    if (_currentIndex < offers.length - 1) {
                      _currentIndex++;
                    } else {
                      _currentIndex = 0;
                    }
                  });
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.primaryColor.withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: theme.primaryColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                  child: Icon(Icons.refresh_rounded, color: theme.primaryColor, size: 30),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 1000.ms),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
