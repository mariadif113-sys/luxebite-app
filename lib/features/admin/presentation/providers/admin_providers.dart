import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/menu/domain/models/menu_models.dart';

// ─── Item Stats Model ────────────────────────────────────────────────────────
class ItemStats {
  final int orders;
  final int views;
  final double rating;
  final double revenue;

  const ItemStats({
    this.orders = 0,
    this.views = 0,
    this.rating = 0.0,
    this.revenue = 0.0,
  });
}

// ─── Admin Menu State ────────────────────────────────────────────────────────
class AdminMenuState {
  final List<MenuItem> items;
  final Map<String, ItemStats> stats;

  const AdminMenuState({required this.items, required this.stats});

  AdminMenuState copyWith({List<MenuItem>? items, Map<String, ItemStats>? stats}) {
    return AdminMenuState(items: items ?? this.items, stats: stats ?? this.stats);
  }
}

// ─── Admin Menu Notifier ─────────────────────────────────────────────────────
class AdminMenuNotifier extends StateNotifier<AdminMenuState> {
  AdminMenuNotifier() : super(const AdminMenuState(items: [], stats: {})) {
    _loadInitialData();
  }

  void _loadInitialData() {
    final items = [
      MenuItem(id: 'alg_1', categoryId: '12', nameEn: 'Couscous Algérois Royal', nameAr: 'كسكسي عاصمي ملكي', nameFr: 'Couscous Royal Algérois', descriptionEn: 'Traditional steamed semolina with lamb and chickpeas.', descriptionAr: 'كسكسي تقليدي مع لحم الغنم والحمص.', descriptionFr: 'Semoule vapeur avec agneau et pois chiches.', price: 2400, imageUrl: 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea', isFeatured: true, reviews: []),
      MenuItem(id: 'alg_2', categoryId: '12', nameEn: 'Tajine Zitoun', nameAr: 'طاجين زيتون فاخر', nameFr: 'Tajine Zitoun de Luxe', descriptionEn: 'Slow-cooked chicken with olives and saffron.', descriptionAr: 'دجاج مطهو مع الزيتون والزعفران.', descriptionFr: 'Poulet mijoté aux olives et safran.', price: 1850, imageUrl: 'https://images.unsplash.com/photo-1512485800893-b08ec1ea59b1', isFeatured: true, reviews: []),
      MenuItem(id: 'alg_3', categoryId: '12', nameEn: 'Shorba Frik', nameAr: 'شربة فريك أصلية', nameFr: 'Chorba Frik Traditionnelle', descriptionEn: 'Algerian tomato soup with green wheat and lamb.', descriptionAr: 'شوربة جزائرية بالفريك ولحم الغنم.', descriptionFr: 'Soupe algérienne au blé vert et agneau.', price: 650, imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd', isFeatured: false, reviews: []),
      MenuItem(id: 'alg_4', categoryId: '12', nameEn: 'Rechta Algéroise', nameAr: 'رشتة عاصمية بالدجاج', nameFr: 'Rechta Algéroise au Poulet', descriptionEn: 'Hand-made noodles with chicken and white sauce.', descriptionAr: 'رشتة يدوية مع الدجاج ومرق أبيض.', descriptionFr: 'Nouilles maison avec poulet et sauce blanche.', price: 1600, imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd', isFeatured: true, reviews: []),
      MenuItem(id: 'alg_5', categoryId: '12', nameEn: 'Traditional Borek', nameAr: 'بوراك عاصمي مقرمش', nameFr: 'Bourek Algérien', descriptionEn: 'Pastry stuffed with minced meat, eggs and cheese.', descriptionAr: 'ديول محشو باللحم المفروم والبيض والجبن.', descriptionFr: 'Brick farci à la viande, œufs et fromage.', price: 450, imageUrl: 'https://images.unsplash.com/photo-1601050633729-19548483832d', isFeatured: false, reviews: []),
      MenuItem(id: '1', categoryId: '3', nameEn: 'Truffle Ribeye Steak', nameAr: 'ريب آي بالترفل', nameFr: 'Entrecôte à la Truffe', descriptionEn: 'Premium Angus beef with black truffle butter.', descriptionAr: 'لحم أنجوس مع زبدة الترفل الأسود.', descriptionFr: 'Bœuf Angus au beurre de truffe noire.', price: 4500, imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c', isFeatured: true, reviews: []),
      MenuItem(id: '2', categoryId: '1', nameEn: 'Gold Leaf Cappuccino', nameAr: 'كابوتشينو بورق الذهب', nameFr: 'Cappuccino Feuille d\'Or', descriptionEn: 'Arabica coffee with 24k edible gold leaf.', descriptionAr: 'قهوة أرابيكا مع ورق الذهب الصالح للأكل.', descriptionFr: 'Arabica avec feuille d\'or 24 carats.', price: 750, imageUrl: 'https://images.unsplash.com/photo-1541167760496-162955ed2a95', isFeatured: true, reviews: []),
      MenuItem(id: '3', categoryId: '5', nameEn: 'Velvet Lava Cake', nameAr: 'كيكة لافا مخملية', nameFr: 'Fondant au Chocolat Velours', descriptionEn: 'Belgian chocolate with molten salted caramel.', descriptionAr: 'شوكولاتة بلجيكية مع كراميل مملح ذائب.', descriptionFr: 'Chocolat belge au cœur de caramel salé.', price: 980, imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb', isFeatured: true, reviews: []),
      MenuItem(id: '4', categoryId: '4', nameEn: 'Wagyu Smash Burger', nameAr: 'واغيو سماش برجر', nameFr: 'Wagyu Smash Burger', descriptionEn: 'Double wagyu with truffle mayo and aged cheddar.', descriptionAr: 'واغيو مزدوج مع مايونيز الترفل وشيدر معتق.', descriptionFr: 'Double Wagyu, mayo truffe et cheddar affiné.', price: 1800, imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', isFeatured: true, reviews: []),
      MenuItem(id: '5', categoryId: '5', nameEn: 'Gold Leaf Tiramisu', nameAr: 'تيراميسو بورق الذهب', nameFr: 'Tiramisu Feuille d\'Or', descriptionEn: 'Classic tiramisu with 24k edible gold leaf.', descriptionAr: 'تيراميسو كلاسيكي بورق الذهب الصالح للأكل.', descriptionFr: 'Tiramisu classique à la feuille d\'or.', price: 1100, imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9', isFeatured: true, reviews: []),
      MenuItem(id: '6', categoryId: '2', nameEn: 'Mixed Grill Platter', nameAr: 'تشكيلة مشاوي', nameFr: 'Assiette de Grillades Mixtes', descriptionEn: 'Lamb chops, chicken skewer, kofta and veggies.', descriptionAr: 'ضلوع خروف، شيش طاووق، كفتة وخضار مشوية.', descriptionFr: 'Côtelettes, brochettes, kofta et légumes.', price: 3500, imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947', isFeatured: true, reviews: []),
      MenuItem(id: '7', categoryId: '8', nameEn: 'Azure Berry Mocktail', nameAr: 'موكتيل توت لازوردي', nameFr: 'Mocktail Baies d\'Azur', descriptionEn: 'Butterfly pea tea with berries and lychee foam.', descriptionAr: 'شاي البازلاء مع التوت وكريمة اللتشي.', descriptionFr: 'Thé pois papillon, baies et mousse litchi.', price: 680, imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e', isFeatured: false, reviews: []),
      MenuItem(id: '8', categoryId: '3', nameEn: 'Shrimp Thermidor', nameAr: 'روبيان ثيرميدور', nameFr: 'Crevettes Thermidor', descriptionEn: 'King prawns in rich creamy sauce with parmesan.', descriptionAr: 'روبيان ملكي في صلصة كريمية مع البارميزان.', descriptionFr: 'Crevettes royales en sauce crémeuse au parmesan.', price: 3200, imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641', isFeatured: false, reviews: []),
      MenuItem(id: '9', categoryId: '6', nameEn: 'Truffle Prosciutto Pizza', nameAr: 'بيتزا ترفل وبروشوتو', nameFr: 'Pizza Truffe et Prosciutto', descriptionEn: 'Sourdough with truffle cream, prosciutto, arugula.', descriptionAr: 'عجينة مع كريمة الترفل والبروشوتو والجرجير.', descriptionFr: 'Levain, crème truffe, prosciutto, roquette.', price: 2200, imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', isFeatured: true, reviews: []),
      MenuItem(id: '10', categoryId: '7', nameEn: 'Black Truffle Carbonara', nameAr: 'كاربونارا بالترفل الأسود', nameFr: 'Carbonara Truffe Noire', descriptionEn: 'Silky carbonara with pancetta and black truffle.', descriptionAr: 'كاربونارا حريرية مع بانشيتا وشرائح الترفل.', descriptionFr: 'Carbonara soyeuse, pancetta et truffe noire.', price: 2600, imageUrl: 'https://images.unsplash.com/photo-1612874742237-6527d0d42132', isFeatured: true, reviews: []),
      MenuItem(id: '19', categoryId: '11', nameEn: 'Tacos Poulet', nameAr: 'طاكوس دجاج', nameFr: 'Tacos au Poulet', descriptionEn: 'French tacos with chicken, fries and cheese sauce.', descriptionAr: 'طاكوس فرنسي بالدجاج والبطاطس وصلصة الجبن.', descriptionFr: 'Tacos français poulet, frites et sauce fromagère.', price: 650, imageUrl: 'https://images.unsplash.com/photo-1613514785940-daed07799d9b', isFeatured: true, reviews: []),
      MenuItem(id: '20', categoryId: '11', nameEn: 'Mlawi Farcie', nameAr: 'ملاوي محشية', nameFr: 'Mlawi Farci', descriptionEn: 'Flaky flatbread stuffed with spiced meat and cheese.', descriptionAr: 'ملاوي مورق محشو باللحم المتبل والجبن.', descriptionFr: 'Pain feuilleté farci viande épicée et fromage.', price: 350, imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641', isFeatured: false, reviews: []),
      MenuItem(id: '15', categoryId: '4', nameEn: 'Crispy Chicken Sandwich', nameAr: 'ساندويتش دجاج مقرمش', nameFr: 'Sandwich Poulet Croustillant', descriptionEn: 'Southern fried chicken with pickles and spicy mayo.', descriptionAr: 'دجاج مقلي مع المخلل والمايونيز الحار.', descriptionFr: 'Poulet frit, cornichons et mayo épicée.', price: 1200, imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086', isFeatured: false, reviews: []),
    ];

    // Simulated realistic stats per item
    final stats = <String, ItemStats>{
      'alg_1': const ItemStats(orders: 128, views: 540, rating: 4.8, revenue: 307200),
      'alg_2': const ItemStats(orders: 97, views: 420, rating: 4.7, revenue: 179450),
      'alg_3': const ItemStats(orders: 64, views: 310, rating: 4.5, revenue: 41600),
      'alg_4': const ItemStats(orders: 83, views: 380, rating: 4.6, revenue: 132800),
      'alg_5': const ItemStats(orders: 112, views: 490, rating: 4.4, revenue: 50400),
      '1': const ItemStats(orders: 89, views: 620, rating: 4.9, revenue: 400500),
      '2': const ItemStats(orders: 203, views: 870, rating: 4.7, revenue: 152250),
      '3': const ItemStats(orders: 145, views: 560, rating: 4.8, revenue: 142100),
      '4': const ItemStats(orders: 178, views: 730, rating: 4.6, revenue: 320400),
      '5': const ItemStats(orders: 134, views: 485, rating: 4.7, revenue: 147400),
      '6': const ItemStats(orders: 76, views: 390, rating: 4.5, revenue: 266000),
      '7': const ItemStats(orders: 91, views: 340, rating: 4.3, revenue: 61880),
      '8': const ItemStats(orders: 52, views: 270, rating: 4.6, revenue: 166400),
      '9': const ItemStats(orders: 118, views: 510, rating: 4.8, revenue: 259600),
      '10': const ItemStats(orders: 87, views: 400, rating: 4.7, revenue: 226200),
      '19': const ItemStats(orders: 215, views: 920, rating: 4.5, revenue: 139750),
      '20': const ItemStats(orders: 167, views: 680, rating: 4.2, revenue: 58450),
      '15': const ItemStats(orders: 143, views: 600, rating: 4.4, revenue: 171600),
    };

    state = AdminMenuState(items: items, stats: stats);
  }

  void addItem(MenuItem newItem) {
    final newStats = Map<String, ItemStats>.from(state.stats);
    newStats[newItem.id] = const ItemStats();
    state = state.copyWith(
      items: [...state.items, newItem],
      stats: newStats,
    );
  }

  void updateItem(MenuItem updatedItem) {
    state = state.copyWith(
      items: [for (final item in state.items) if (item.id == updatedItem.id) updatedItem else item],
    );
  }

  void deleteItem(String id) {
    final newStats = Map<String, ItemStats>.from(state.stats)..remove(id);
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
      stats: newStats,
    );
  }

  void toggleFeatured(String id) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.id == id)
            MenuItem(
              id: item.id, categoryId: item.categoryId,
              nameEn: item.nameEn, nameAr: item.nameAr, nameFr: item.nameFr,
              descriptionEn: item.descriptionEn, descriptionAr: item.descriptionAr, descriptionFr: item.descriptionFr,
              price: item.price, imageUrl: item.imageUrl,
              isFeatured: !item.isFeatured, reviews: item.reviews,
            )
          else item,
      ],
    );
  }
}

final adminMenuProvider = StateNotifierProvider<AdminMenuNotifier, AdminMenuState>((ref) {
  return AdminMenuNotifier();
});

// Legacy alias for backward compatibility
final adminMenuItemsProvider = Provider<List<MenuItem>>((ref) {
  return ref.watch(adminMenuProvider).items;
});
