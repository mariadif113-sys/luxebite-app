import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/menu/domain/models/menu_models.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';
import 'package:flutter_application_1/features/admin/presentation/providers/admin_providers.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';

class ManageMenuScreen extends ConsumerStatefulWidget {
  const ManageMenuScreen({super.key});

  @override
  ConsumerState<ManageMenuScreen> createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends ConsumerState<ManageMenuScreen> with TickerProviderStateMixin {
  String? selectedCategoryId;
  late TabController _tabController;

  final categories = [
    {'id': null,   'nameEn': 'All',             'nameAr': 'الكل',                'nameFr': 'Tout'},
    {'id': '12',   'nameEn': 'Algerian',         'nameAr': 'التراث الجزائري',     'nameFr': 'Héritage Algérien'},
    {'id': '3',    'nameEn': 'Main Dishes',      'nameAr': 'أطباق رئيسية',        'nameFr': 'Plats Principaux'},
    {'id': '4',    'nameEn': 'Sandwiches',       'nameAr': 'سندويتشات',           'nameFr': 'Sandwichs'},
    {'id': '2',    'nameEn': 'Grills',           'nameAr': 'مشاوي',               'nameFr': 'Grillades'},
    {'id': '5',    'nameEn': 'Desserts',         'nameAr': 'حلويات',              'nameFr': 'Desserts'},
    {'id': '6',    'nameEn': 'Pizza',            'nameAr': 'بيتزا',               'nameFr': 'Pizza'},
    {'id': '7',    'nameEn': 'Pasta',            'nameAr': 'باستا',               'nameFr': 'Pâtes'},
    {'id': '8',    'nameEn': 'Cold Drinks',      'nameAr': 'مشروبات باردة',       'nameFr': 'Boissons Froides'},
    {'id': '11',   'nameEn': 'Fast Food',        'nameAr': 'أكل جزائري سريع',     'nameFr': 'Fast Food'},
    {'id': '1',    'nameEn': 'Hot Drinks',       'nameAr': 'مشروبات ساخنة',       'nameFr': 'Boissons Chaudes'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = ref.watch(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final adminState = ref.watch(adminMenuProvider);
    final allItems = adminState.items;
    final stats = adminState.stats;

    final filteredItems = selectedCategoryId == null
        ? allItems
        : allItems.where((item) => item.categoryId == selectedCategoryId).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isAr ? 'إدارة القائمة' : (isFr ? 'GÉRER LE MENU' : 'MANAGE MENU'),
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 20),
            ),
            onPressed: () => _showItemDialog(context, null, isAr, isFr, theme),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: Colors.white38,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: isAr ? 'الأطباق' : 'DISHES'),
            Tab(text: isAr ? 'الإحصائيات' : 'ANALYTICS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ─── TAB 1: DISHES MANAGEMENT ──────────────────────────────────
          _buildDishesTab(context, filteredItems, allItems, stats, isAr, isFr, theme),

          // ─── TAB 2: ANALYTICS ──────────────────────────────────────────
          _buildAnalyticsTab(context, allItems, stats, isAr, isFr, theme),
        ],
      ),
    );
  }

  // ─── DISHES TAB ─────────────────────────────────────────────────────────────
  Widget _buildDishesTab(
    BuildContext context,
    List<MenuItem> filteredItems,
    List<MenuItem> allItems,
    Map<String, ItemStats> stats,
    bool isAr, bool isFr, ThemeData theme,
  ) {
    return Column(
      children: [
        // Stats Summary Row
        _buildSummaryRow(allItems, stats, isAr, theme),

        // Category Filter
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategoryId == cat['id'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    HapticsManager.light();
                    setState(() => selectedCategoryId = cat['id']);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primaryColor : Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? theme.primaryColor : Colors.white12),
                    ),
                    child: Center(
                      child: Text(
                        isAr ? (cat['nameAr'] ?? '') : (isFr ? (cat['nameFr'] ?? '') : (cat['nameEn'] ?? '')),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        // Items List
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.no_food_rounded, color: Colors.white12, size: 60),
                      const SizedBox(height: 12),
                      Text(isAr ? 'لا توجد أطباق في هذا القسم' : 'No dishes in this category',
                          style: GoogleFonts.outfit(color: Colors.white30, fontSize: 14)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final itemStats = stats[item.id] ?? const ItemStats();
                    return _buildDishCard(context, item, itemStats, isAr, isFr, theme)
                        .animate(delay: Duration(milliseconds: index * 40))
                        .fadeIn()
                        .slideX(begin: 0.05);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(List<MenuItem> items, Map<String, ItemStats> stats, bool isAr, ThemeData theme) {
    final totalOrders = stats.values.fold(0, (sum, s) => sum + s.orders);
    final totalRevenue = stats.values.fold(0.0, (sum, s) => sum + s.revenue);
    final avgRating = stats.isEmpty ? 0.0 : stats.values.fold(0.0, (sum, s) => sum + s.rating) / stats.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor.withOpacity(0.12), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryChip(Icons.restaurant_menu_rounded, '${items.length}', isAr ? 'طبق' : 'Dishes', theme),
          _divider(),
          _summaryChip(Icons.shopping_bag_rounded, '$totalOrders', isAr ? 'طلب' : 'Orders', theme),
          _divider(),
          _summaryChip(Icons.star_rounded, avgRating.toStringAsFixed(1), isAr ? 'تقييم' : 'Rating', theme, color: Colors.amber),
          _divider(),
          _summaryChip(Icons.payments_rounded, '${(totalRevenue / 1000).toStringAsFixed(0)}K', isAr ? 'DZD' : 'DZD', theme, color: Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _summaryChip(IconData icon, String value, String label, ThemeData theme, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color ?? theme.primaryColor),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w900, color: color ?? Colors.white)),
        Text(label, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white38)),
      ],
    );
  }

  Widget _divider() => Container(height: 30, width: 1, color: Colors.white10);

  Widget _buildDishCard(BuildContext context, MenuItem item, ItemStats stats, bool isAr, bool isFr, ThemeData theme) {
    final successScore = stats.orders > 0 ? (stats.orders / 215 * 100).clamp(0, 100) : 0.0;
    final isHit = stats.orders >= 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isHit ? theme.primaryColor.withOpacity(0.4) : Colors.white10),
        boxShadow: isHit ? [BoxShadow(color: theme.primaryColor.withOpacity(0.1), blurRadius: 12)] : null,
      ),
      child: Column(
        children: [
          // Main row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item.imageUrl,
                        width: 72, height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.fastfood, color: Colors.white24),
                        ),
                      ),
                    ),
                    if (item.isFeatured)
                      Positioned(
                        top: 4, right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.star, color: Colors.black, size: 10),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isAr ? item.nameAr : (isFr ? item.nameFr : item.nameEn),
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isHit)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFFB8860B)]),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(isAr ? '🔥 رائج' : '🔥 HIT',
                                  style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.price.toInt()} DZD',
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: theme.primaryColor),
                      ),
                      const SizedBox(height: 4),
                      // Mini stats
                      Row(
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 11, color: Colors.white38),
                          const SizedBox(width: 3),
                          Text('${stats.orders}', style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)),
                          const SizedBox(width: 10),
                          Icon(Icons.star, size: 11, color: Colors.amber.withOpacity(0.7)),
                          const SizedBox(width: 3),
                          Text(stats.rating.toStringAsFixed(1), style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)),
                          const SizedBox(width: 10),
                          Icon(Icons.payments_outlined, size: 11, color: Colors.greenAccent.withOpacity(0.7)),
                          const SizedBox(width: 3),
                          Text('${(stats.revenue / 1000).toStringAsFixed(0)}K', style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action buttons
                Column(
                  children: [
                    _actionBtn(Icons.edit_rounded, Colors.white70, () => _showItemDialog(context, item, isAr, isFr, theme)),
                    const SizedBox(height: 4),
                    _actionBtn(
                      item.isFeatured ? Icons.star_rounded : Icons.star_border_rounded,
                      item.isFeatured ? Colors.amber : Colors.white38,
                      () {
                        HapticsManager.light();
                        ref.read(adminMenuProvider.notifier).toggleFeatured(item.id);
                      },
                    ),
                    const SizedBox(height: 4),
                    _actionBtn(Icons.delete_rounded, Colors.redAccent.withOpacity(0.7), () => _confirmDelete(context, item, isAr, theme)),
                  ],
                ),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'نسبة النجاح' : 'Success Rate',
                      style: GoogleFonts.outfit(fontSize: 10, color: Colors.white38),
                    ),
                    Text(
                      '${successScore.toStringAsFixed(0)}%',
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold,
                          color: successScore > 60 ? Colors.greenAccent : successScore > 30 ? Colors.amber : Colors.redAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: successScore / 100,
                    minHeight: 4,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      successScore > 60 ? Colors.greenAccent : successScore > 30 ? Colors.amber : Colors.redAccent,
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

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  // ─── ANALYTICS TAB ──────────────────────────────────────────────────────────
  Widget _buildAnalyticsTab(
    BuildContext context,
    List<MenuItem> allItems,
    Map<String, ItemStats> stats,
    bool isAr, bool isFr, ThemeData theme,
  ) {
    // Sort by orders descending
    final sortedItems = [...allItems]..sort((a, b) {
        final statsA = stats[a.id] ?? const ItemStats();
        final statsB = stats[b.id] ?? const ItemStats();
        return statsB.orders.compareTo(statsA.orders);
      });

    final maxOrders = sortedItems.isNotEmpty ? (stats[sortedItems.first.id]?.orders ?? 1) : 1;
    final totalRevenue = stats.values.fold(0.0, (sum, s) => sum + s.revenue);
    final totalOrders = stats.values.fold(0, (sum, s) => sum + s.orders);
    final topItem = sortedItems.isNotEmpty ? sortedItems.first : null;
    final flopItem = sortedItems.isNotEmpty ? sortedItems.last : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // KPI Cards
        Row(
          children: [
            Expanded(child: _kpiCard(isAr ? 'إجمالي الطلبات' : 'Total Orders', '$totalOrders', Icons.shopping_bag_rounded, Colors.blueAccent, theme)),
            const SizedBox(width: 12),
            Expanded(child: _kpiCard(isAr ? 'إجمالي الإيراد' : 'Total Revenue', '${(totalRevenue / 1000).toStringAsFixed(0)}K DZD', Icons.payments_rounded, Colors.greenAccent, theme)),
          ],
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 12),

        Row(
          children: [
            if (topItem != null)
              Expanded(child: _kpiCard(
                isAr ? '🔥 الأفضل مبيعاً' : '🔥 Best Seller',
                isAr ? topItem.nameAr : topItem.nameEn,
                Icons.trending_up_rounded, Colors.amber, theme,
              )),
            const SizedBox(width: 12),
            if (flopItem != null)
              Expanded(child: _kpiCard(
                isAr ? '❌ الأقل مبيعاً' : '❌ Least Sold',
                isAr ? flopItem.nameAr : flopItem.nameEn,
                Icons.trending_down_rounded, Colors.redAccent, theme,
              )),
          ],
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 20),

        Text(
          isAr ? 'ترتيب الأطباق حسب المبيعات' : 'DISHES RANKED BY SALES',
          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: theme.primaryColor, letterSpacing: 2),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 12),

        // Bar Chart
        ...sortedItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final itemStats = stats[item.id] ?? const ItemStats();
          final ratio = maxOrders > 0 ? itemStats.orders / maxOrders : 0.0;
          final isTop3 = index < 3;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22, height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isTop3 ? theme.primaryColor : Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${index + 1}',
                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: isTop3 ? Colors.black : Colors.white38)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isAr ? item.nameAr : (isFr ? item.nameFr : item.nameEn),
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${itemStats.orders} ${isAr ? "طلب" : "orders"}',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isTop3 ? theme.primaryColor : Colors.white30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(children: [
                      const Icon(Icons.star, size: 10, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(itemStats.rating.toStringAsFixed(1),
                          style: GoogleFonts.outfit(fontSize: 10, color: Colors.amber)),
                    ]),
                  ],
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: 300 + index * 30)).fadeIn().slideX(begin: 0.05);
        }),
      ],
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white38)),
        ],
      ),
    );
  }

  // ─── ADD / EDIT DIALOG ───────────────────────────────────────────────────────
  void _showItemDialog(BuildContext context, MenuItem? item, bool isAr, bool isFr, ThemeData theme) {
    final nameArCtrl = TextEditingController(text: item?.nameAr ?? '');
    final nameEnCtrl = TextEditingController(text: item?.nameEn ?? '');
    final nameFrCtrl = TextEditingController(text: item?.nameFr ?? '');
    final descArCtrl = TextEditingController(text: item?.descriptionAr ?? '');
    final descEnCtrl = TextEditingController(text: item?.descriptionEn ?? '');
    final priceCtrl = TextEditingController(text: item?.price.toInt().toString() ?? '');
    final imageCtrl = TextEditingController(text: item?.imageUrl ?? '');
    String selectedCat = item?.categoryId ?? '3';

    final catOptions = [
      {'id': '12', 'label': isAr ? 'التراث الجزائري' : 'Algerian Heritage'},
      {'id': '3',  'label': isAr ? 'أطباق رئيسية' : 'Main Dishes'},
      {'id': '4',  'label': isAr ? 'سندويتشات' : 'Sandwiches'},
      {'id': '2',  'label': isAr ? 'مشاوي' : 'Grills'},
      {'id': '5',  'label': isAr ? 'حلويات' : 'Desserts'},
      {'id': '6',  'label': isAr ? 'بيتزا' : 'Pizza'},
      {'id': '7',  'label': isAr ? 'باستا' : 'Pasta'},
      {'id': '8',  'label': isAr ? 'مشروبات باردة' : 'Cold Drinks'},
      {'id': '1',  'label': isAr ? 'مشروبات ساخنة' : 'Hot Drinks'},
      {'id': '11', 'label': isAr ? 'أكل سريع' : 'Fast Food'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => Dialog(
          backgroundColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
                      child: Icon(item == null ? Icons.add_rounded : Icons.edit_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item == null ? (isAr ? 'إضافة طبق جديد' : 'Add New Dish') : (isAr ? 'تعديل الطبق' : 'Edit Dish'),
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white38),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Image URL + Preview
                _dialogField(isAr ? 'رابط الصورة (URL)' : 'Image URL', imageCtrl, theme),
                const SizedBox(height: 8),
                if (imageCtrl.text.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageCtrl.text,
                      height: 120, width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 80, color: Colors.white10, child: const Icon(Icons.broken_image, color: Colors.white24)),
                    ),
                  ),
                const SizedBox(height: 16),

                // Name Fields
                Text('📝 ${isAr ? "الاسم" : "Name"}', style: GoogleFonts.outfit(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _dialogField('العربية', nameArCtrl, theme),
                const SizedBox(height: 8),
                _dialogField('English', nameEnCtrl, theme),
                const SizedBox(height: 8),
                _dialogField('Français', nameFrCtrl, theme),
                const SizedBox(height: 16),

                // Description
                Text('📄 ${isAr ? "الوصف" : "Description"}', style: GoogleFonts.outfit(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _dialogField('الوصف بالعربي', descArCtrl, theme, maxLines: 2),
                const SizedBox(height: 8),
                _dialogField('Description in English', descEnCtrl, theme, maxLines: 2),
                const SizedBox(height: 16),

                // Price
                Text('💰 ${isAr ? "السعر" : "Price"}', style: GoogleFonts.outfit(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _dialogField('${isAr ? "السعر" : "Price"} (DZD)', priceCtrl, theme, isNumber: true),
                const SizedBox(height: 16),

                // Category
                Text('📂 ${isAr ? "القسم" : "Category"}', style: GoogleFonts.outfit(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: DropdownButton<String>(
                    value: selectedCat,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1C1C1C),
                    underline: const SizedBox.shrink(),
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                    onChanged: (v) => setStateDialog(() => selectedCat = v!),
                    items: catOptions.map((c) => DropdownMenuItem<String>(
                      value: c['id']!,
                      child: Text(c['label']!),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_rounded, color: Colors.black),
                    label: Text(
                      isAr ? 'حفظ الطبق' : 'Save Dish',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final price = double.tryParse(priceCtrl.text) ?? 0;
                      if (nameArCtrl.text.isEmpty || price <= 0) return;

                      final newItem = MenuItem(
                        id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        categoryId: selectedCat,
                        nameAr: nameArCtrl.text.trim(),
                        nameEn: nameEnCtrl.text.trim().isEmpty ? nameArCtrl.text.trim() : nameEnCtrl.text.trim(),
                        nameFr: nameFrCtrl.text.trim().isEmpty ? nameEnCtrl.text.trim() : nameFrCtrl.text.trim(),
                        descriptionAr: descArCtrl.text.trim(),
                        descriptionEn: descEnCtrl.text.trim().isEmpty ? descArCtrl.text.trim() : descEnCtrl.text.trim(),
                        descriptionFr: descEnCtrl.text.trim(),
                        price: price,
                        imageUrl: imageCtrl.text.trim().isEmpty
                            ? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c'
                            : imageCtrl.text.trim(),
                        isFeatured: item?.isFeatured ?? false,
                        reviews: item?.reviews ?? [],
                      );

                      if (item == null) {
                        ref.read(adminMenuProvider.notifier).addItem(newItem);
                      } else {
                        ref.read(adminMenuProvider.notifier).updateItem(newItem);
                      }

                      HapticsManager.success();
                      Navigator.pop(ctx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isAr ? '✅ تم حفظ الطبق بنجاح' : '✅ Dish saved successfully'),
                          backgroundColor: const Color(0xFF1A1A1A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogField(String label, TextEditingController ctrl, ThemeData theme, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
      maxLines: maxLines,
      style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.primaryColor)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  void _confirmDelete(BuildContext context, MenuItem item, bool isAr, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isAr ? 'حذف الطبق؟' : 'Delete Dish?',
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          isAr ? 'هل أنت متأكد من حذف "${item.nameAr}"؟\nلا يمكن التراجع عن هذه العملية.' : 'Are you sure you want to delete "${item.nameEn}"?\nThis action cannot be undone.',
          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel', style: GoogleFonts.outfit(color: Colors.white38)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever_rounded, size: 16),
            label: Text(isAr ? 'نعم، احذف' : 'Delete', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ref.read(adminMenuProvider.notifier).deleteItem(item.id);
              HapticsManager.medium();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isAr ? '🗑 تم حذف الطبق' : '🗑 Dish deleted'),
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
