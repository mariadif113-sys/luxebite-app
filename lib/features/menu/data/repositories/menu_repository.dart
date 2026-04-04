import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/menu_models.dart';

class MenuRepository {
  final SupabaseClient _client;
  MenuRepository(this._client);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.from('categories').select();
      return (response as List).map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      return [
        Category(id: '12', nameEn: 'Algerian Heritage', nameAr: 'التراث الجزائري', nameFr: 'Héritage Algérien', icon: 'mosque'),
        Category(id: '3', nameEn: 'Main Dishes', nameAr: 'أطباق رئيسية', nameFr: 'Plats Principaux', icon: 'restaurant'),
        Category(id: '11', nameEn: 'Algerian Fast Food', nameAr: 'أكل جزائري سريع', nameFr: 'Fast Food Algérien', icon: 'fastfood'),
        Category(id: '2', nameEn: 'Grills & BBQ', nameAr: 'مشاوي وباربيكيو', nameFr: 'Grillades & BBQ', icon: 'outdoor_grill'),
        Category(id: '4', nameEn: 'Sandwiches', nameAr: 'سندويتشات', nameFr: 'Sandwichs', icon: 'lunch_dining'),
        Category(id: '5', nameEn: 'Desserts', nameAr: 'حلويات', nameFr: 'Desserts', icon: 'icecream'),
        Category(id: '6', nameEn: 'Pizza', nameAr: 'بيتزا', nameFr: 'Pizza', icon: 'local_pizza'),
        Category(id: '7', nameEn: 'Pasta', nameAr: 'باستا', nameFr: 'Pâtes', icon: 'ramen_dining'),
        Category(id: '8', nameEn: 'Cold Drinks', nameAr: 'مشروبات باردة', nameFr: 'Boissons Froides', icon: 'local_bar'),
      ];
    }
  }

  Future<List<MenuItem>> getMenuItems({String? categoryId}) async {
    try {
      var query = _client.from('menu_items').select();
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      final response = await query;
      return (response as List).map((e) => MenuItem.fromJson(e)).toList();
    } catch (e) {
      if (categoryId == null) return _mockMenuItems;
      return _mockMenuItems.where((item) => item.categoryId == categoryId).toList();
    }
  }

  Future<List<Offer>> getOffers() async {
    try {
      final response = await _client.from('offers').select();
      return (response as List).map((e) => Offer.fromJson(e)).toList();
    } catch (e) {
      return [
        Offer(
          id: '1',
          titleEn: 'Gourmet Weekend',
          titleAr: 'نهاية أسبوع فاخرة',
          titleFr: 'Week-end Gourmet',
          descriptionEn: 'Get 25% off on all main dishes.',
          descriptionAr: 'احصل على خصم 25٪ على جميع الأطباق الرئيسية.',
          descriptionFr: 'Bénéficiez de 25% de réduction sur tous les plats principaux.',
          discountPercentage: 25,
          imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
        ),
        Offer(
          id: '2',
          titleEn: 'Dessert Heaven',
          titleAr: 'جنة الحلويات',
          titleFr: 'Paradis des Desserts',
          descriptionEn: 'Buy any main dish and get a free dessert.',
          descriptionAr: 'اطلب أي طبق رئيسي واحصل على حلوى مجانية.',
          descriptionFr: 'Achetez un plat principal et recevez un dessert gratuit.',
          discountPercentage: 100,
          imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb',
        ),
      ];
    }
  }

  Future<List<Review>> getReviews(String menuItemId) async {
    try {
      final response = await _client.from('reviews').select().eq('menu_item_id', menuItemId);
      return (response as List).map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<UserBudget> getUserBudget() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Not logged in');
      final response = await _client.from('user_budgets').select().eq('user_id', userId).single();
      return UserBudget(
        monthlyLimit: (response['monthly_limit'] as num).toDouble(),
        currentSpend: (response['current_spend'] as num).toDouble(),
      );
    } catch (e) {
      return UserBudget(monthlyLimit: 50000.0, currentSpend: 17250.0);
    }
  }
}

// ─── Mock Menu Data (DZD Prices) ────────────────────────────────────────────
final _mockMenuItems = [
  MenuItem(
    id: 'alg_1', categoryId: '12',
    nameEn: 'Couscous Algérois Royal', nameAr: 'كسكسي عاصمي ملكي', nameFr: 'Couscous Royal Algérois',
    descriptionEn: 'Traditional steamed semolina with lamb, seasonal vegetables and chickpeas.',
    descriptionAr: 'كسكسي تقليدي مفور مع لحم الغنم، خضار موسمية وحمص.',
    descriptionFr: 'Semoule traditionnelle à la vapeur avec agneau, légumes de saison et pois chiches.',
    price: 2400, imageUrl: 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: 'alg_2', categoryId: '12',
    nameEn: 'Tajine Zitoun', nameAr: 'طاجين زيتون فاخر', nameFr: 'Tajine Zitoun de Luxe',
    descriptionEn: 'Slow-cooked chicken with olives, carrots and a rich saffron sauce.',
    descriptionAr: 'دجاج مطهو ببطء مع الزيتون، الجزر ومعرق بالزعفران الفاخر.',
    descriptionFr: 'Poulet mijoté avec olives, carottes et une riche sauce au safran.',
    price: 1850, imageUrl: 'https://images.unsplash.com/photo-1512485800893-b08ec1ea59b1',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: 'alg_3', categoryId: '12',
    nameEn: 'Shorba Frik', nameAr: 'شربة فريك أصلية', nameFr: 'Chorba Frik Traditionnelle',
    descriptionEn: 'Spicy Algerian tomato soup with cracked green wheat and lamb.',
    descriptionAr: 'شوربة جزائرية حارة بالفريك، الطماطم ولحم الغنم.',
    descriptionFr: 'Soupe algérienne épicée au blé vert concassé et agneau.',
    price: 650, imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: 'alg_4', categoryId: '12',
    nameEn: 'Rechta Algéroise', nameAr: 'رشتة عاصمية بالدجاج', nameFr: 'Rechta Algéroise au Poulet',
    descriptionEn: 'Hand-made thin noodles with chicken, turnip and a mild white sauce.',
    descriptionAr: 'خيوط رشتة مصنوعة يدوياً مع الدجاج، اللفت ومعرقة بمرق أبيض خفيف.',
    descriptionFr: 'Nouilles fines faites main avec poulet, navet et une sauce blanche douce.',
    price: 1600, imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: 'alg_5', categoryId: '12',
    nameEn: 'Traditional Borek', nameAr: 'بوراك عاصمي مقرمش', nameFr: 'Bourek Algérien',
    descriptionEn: 'Thin pastry leaves stuffed with minced meat, eggs and cheese.',
    descriptionAr: 'أوراق ديول رقيقة محشوة باللحم المفروم، البيض والجبن.',
    descriptionFr: 'Feuilles de brick farcies à la viande hachée, œufs et fromage.',
    price: 450, imageUrl: 'https://images.unsplash.com/photo-1601050633729-19548483832d',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '1', categoryId: '3',
    nameEn: 'Truffle Ribeye Steak', nameAr: 'ريب آي بالترفل', nameFr: 'Entrecôte à la Truffe',
    descriptionEn: 'Premium Angus beef with black truffle butter and seasonal vegetables.',
    descriptionAr: 'لحم أنجوس فاخر مع زبدة الترفل الأسود وخضروات موسمية.',
    descriptionFr: 'Bœuf Angus de première qualité avec beurre de truffe noire et légumes de saison.',
    price: 4500, imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '2', categoryId: '1',
    nameEn: 'Gold Leaf Cappuccino', nameAr: 'كابوتشينو بورق الذهب', nameFr: 'Cappuccino à la Feuille d\'Or',
    descriptionEn: 'Arabica coffee topped with 24k edible gold leaf and latte art.',
    descriptionAr: 'قهوة أرابيكا مع ورق ذهب صالح للأكل وفن الحليب.',
    descriptionFr: 'Café Arabica garni de feuilles d\'or 24 carats comestibles et latte art.',
    price: 750, imageUrl: 'https://images.unsplash.com/photo-1541167760496-162955ed2a95',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '3', categoryId: '5',
    nameEn: 'Velvet Lava Cake', nameAr: 'كيكة لافا مخملية', nameFr: 'Fondant au Chocolat Velours',
    descriptionEn: 'Dark Belgian chocolate with a molten heart of salted caramel.',
    descriptionAr: 'شوكولاتة بلجيكية داكنة مع قلب ذائب من الكراميل المملح.',
    descriptionFr: 'Chocolat belge noir avec un cœur fondant au caramel au beurre salé.',
    price: 980, imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '4', categoryId: '4',
    nameEn: 'Wagyu Smash Burger', nameAr: 'واغيو سماش برجر', nameFr: 'Wagyu Smash Burger',
    descriptionEn: 'Double smashed wagyu patty with truffle mayo and aged cheddar.',
    descriptionAr: 'باتي واغيو مضغوط مزدوج مع مايونيز الترفل وشيدر معتق.',
    descriptionFr: 'Double steak de Wagyu avec mayonnaise à la truffe et cheddar affiné.',
    price: 1800, imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '5', categoryId: '5',
    nameEn: 'Gold Leaf Tiramisu', nameAr: 'تيراميسو بورق الذهب', nameFr: 'Tiramisu à la Feuille d\'Or',
    descriptionEn: 'Classic Italian tiramisu topped with 24k edible gold leaf.',
    descriptionAr: 'تيراميسو إيطالي كلاسيكي مزين بورق الذهب الصالح للأكل.',
    descriptionFr: 'Tiramisu italien classique garni de feuilles d\'or 24 carats comestibles.',
    price: 1100, imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '6', categoryId: '2',
    nameEn: 'Mixed Grill Platter', nameAr: 'تشكيلة مشاوي', nameFr: 'Assiette de Grillades Mixtes',
    descriptionEn: 'Lamb chops, chicken skewer, kofta and grilled vegetables.',
    descriptionAr: 'ضلوع خروف، أسياخ دجاج، كفتة وخضروات مشوية.',
    descriptionFr: 'Côtelettes d\'agneau, brochettes de poulet, kofta et légumes grillés.',
    price: 3500, imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '7', categoryId: '8',
    nameEn: 'Azure Berry Mocktail', nameAr: 'موكتيل توت لازوردي', nameFr: 'Mocktail aux Baies d\'Azur',
    descriptionEn: 'Butterfly pea tea with mixed berries, mint and lychee foam.',
    descriptionAr: 'شاي البازلاء الفراشية مع توت مشكل ونعناع وكريمة اللتشي.',
    descriptionFr: 'Thé de pois papillon avec baies mixtes, menthe et mousse de litchi.',
    price: 680, imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '8', categoryId: '3',
    nameEn: 'Shrimp Thermidor', nameAr: 'روبيان ثيرميدور', nameFr: 'Crevettes Thermidor',
    descriptionEn: 'King prawns in a rich creamy sauce with parmesan gratin.',
    descriptionAr: 'روبيان ملكي في صلصة كريمية غنية مع جراتان البارميزان.',
    descriptionFr: 'Crevettes géantes dans une sauce crémeuse riche avec gratin de parmesan.',
    price: 3200, imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '9', categoryId: '6',
    nameEn: 'Truffle Prosciutto Pizza', nameAr: 'بيتزا ترفل وبروشوتو', nameFr: 'Pizza Truffe et Prosciutto',
    descriptionEn: 'Sourdough base with truffle cream, prosciutto and fresh arugula.',
    descriptionAr: 'عجينة محمصة مع كريمة الترفل والبروشوتو والجرجير الطازج.',
    descriptionFr: 'Base au levain avec crème de truffe, prosciutto et roquette fraîche.',
    price: 2200, imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '10', categoryId: '7',
    nameEn: 'Black Truffle Carbonara', nameAr: 'كاربونارا بالترفل الأسود', nameFr: 'Carbonara à la Truffe Noire',
    descriptionEn: 'Silky carbonara with crispy pancetta and shaved black truffle.',
    descriptionAr: 'كاربونارا حريرية مع بانشيتا مقرمشة وشرائح الترفل الأسود.',
    descriptionFr: 'Carbonara onctueuse avec pancetta croustillante et copeaux de truffe noire.',
    price: 2600, imageUrl: 'https://images.unsplash.com/photo-1612874742237-6527d0d42132',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '11', categoryId: '3',
    nameEn: 'Grilled Sea Bass', nameAr: 'لوباس مشوي', nameFr: 'Bar Grillé',
    descriptionEn: 'Whole sea bass grilled with herbs, lemon and garlic butter.',
    descriptionAr: 'سمك لوباس كامل مشوي مع الأعشاب وزبدة الثوم والليمون.',
    descriptionFr: 'Bar entier grillé aux herbes, citron et beurre d\'ail.',
    price: 3800, imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '12', categoryId: '9',
    nameEn: 'Burrata & Heirloom Tomato', nameAr: 'بوراتا مع طماطم بلدية', nameFr: 'Burrata & Tomates d\'Antan',
    descriptionEn: 'Creamy burrata with heirloom tomatoes, basil oil and sea salt.',
    descriptionAr: 'بوراتا كريمية مع طماطم بلدية وزيت الريحان وملح البحر.',
    descriptionFr: 'Burrata crémeuse avec tomates d\'antan, huile de basilic et sel de mer.',
    price: 1200, imageUrl: 'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14a5',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '13', categoryId: '10',
    nameEn: 'Crispy Calamari', nameAr: 'كاليماري مقرمش', nameFr: 'Calmars Croustillants',
    descriptionEn: 'Golden fried squid rings with garlic aioli and fresh lemon.',
    descriptionAr: 'حلقات حبار مقلية ذهبية مع صلصة الثوم والليمون الطازج.',
    descriptionFr: 'Rondelles de calmar frites dorées avec aïoli à l\'ail et citron frais.',
    price: 890, imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '14', categoryId: '2',
    nameEn: 'BBQ Beef Ribs', nameAr: 'ضلوع بقري باربيكيو', nameFr: 'Côtes de Bœuf BBQ',
    descriptionEn: 'Slow-smoked beef ribs with house BBQ sauce and coleslaw.',
    descriptionAr: 'ضلوع بقري مدخن ببطء مع صلصة الباربيكيو الخاصة وسلطة الكرنب.',
    descriptionFr: 'Côtes de bœuf fumées lentement avec sauce BBQ maison et salade de chou.',
    price: 4200, imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '15', categoryId: '4',
    nameEn: 'Crispy Chicken Sandwich', nameAr: 'ساندويتش دجاج مقرمش', nameFr: 'Sandwich au Poulet Croustillant',
    descriptionEn: 'Southern fried chicken breast with pickles and spicy mayo.',
    descriptionAr: 'صدر دجاج مقلي على الطريقة الجنوبية مع المخلل والمايونيز الحار.',
    descriptionFr: 'Blanc de poulet frit à la sudiste avec cornichons et mayo épicée.',
    price: 1200, imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '16', categoryId: '5',
    nameEn: 'Creme Brulee Royal', nameAr: 'كريم بروليه رويال', nameFr: 'Crème Brûlée Royale',
    descriptionEn: 'Vanilla bean custard with a perfectly caramelized sugar crust.',
    descriptionAr: 'كاسترد حبة الفانيليا مع قشرة سكر مكرملة بشكل مثالي.',
    descriptionFr: 'Crème anglaise à la vanille avec une croûte de sucre parfaitement caramélisée.',
    price: 850, imageUrl: 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '17', categoryId: '1',
    nameEn: 'Royal Moroccan Tea', nameAr: 'شاي مغربي ملكي', nameFr: 'Thé Marocain Royal',
    descriptionEn: 'Premium green tea with fresh mint and pine nuts.',
    descriptionAr: 'شاي أخضر فاخر مع نعناع طازج وصنوبر.',
    descriptionFr: 'Thé vert de première qualité avec menthe fraîche et pignons de pin.',
    price: 350, imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '18', categoryId: '8',
    nameEn: 'Mango Lassi Royale', nameAr: 'لاسي المانغو الملكي', nameFr: 'Lassi à la Mangue Royale',
    descriptionEn: 'Alphonso mango blended with yogurt, cardamom and saffron.',
    descriptionAr: 'مانغو ألفونسو ممزوج بالزبادي والهيل والزعفران.',
    descriptionFr: 'Mangue Alphonso mélangée à du yaourt, de la cardamome et du safran.',
    price: 520, imageUrl: 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '19', categoryId: '11',
    nameEn: 'Tacos Poulet', nameAr: 'طاكوس دجاج', nameFr: 'Tacos au Poulet',
    descriptionEn: 'French tacos filled with chicken, fries and signature cheese sauce.',
    descriptionAr: 'طاكوس فرنسي محشو بالدجاج والبطاطس المقلية وصلصة الجبن الخاصة.',
    descriptionFr: 'Tacos français garni de poulet, frites et notre sauce fromagère signature.',
    price: 650, imageUrl: 'https://images.unsplash.com/photo-1613514785940-daed07799d9b',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '20', categoryId: '11',
    nameEn: 'Mlawi Farcie', nameAr: 'ملاوي محشية', nameFr: 'Mlawi Farci',
    descriptionEn: 'Traditional flaky flatbread stuffed with spiced meat and cheese.',
    descriptionAr: 'خبز ملاوي تقليدي مورق محشو باللحم المفروم المتبل والجبن.',
    descriptionFr: 'Pain plat traditionnel feuilleté farci de viande épicée et de fromage.',
    price: 350, imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641',
    isFeatured: false, reviews: [],
  ),
  MenuItem(
    id: '21', categoryId: '3',
    nameEn: 'Grilled Dorado Fish', nameAr: 'سمك دوراد مشوي', nameFr: 'Dorade Grillée',
    descriptionEn: 'Fresh dorado grilled with chermaoula marinade and lemon.',
    descriptionAr: 'سمك دوراد طازج مشوي بتتبيلة الشرمولة والليمون.',
    descriptionFr: 'Dorade fraîche grillée avec marinade chermoula et citron.',
    price: 1800, imageUrl: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4',
    isFeatured: true, reviews: [],
  ),
  MenuItem(
    id: '22', categoryId: '11',
    nameEn: 'Frites Omelette', nameAr: 'فريت أومليت (كاسكروط)', nameFr: 'Frites Omelette',
    descriptionEn: 'Classic Algerian street food sandwich with fries and omelette.',
    descriptionAr: 'ساندويتش جزائري كلاسيكي محشو بالبطاطس المقلية والأومليت.',
    descriptionFr: 'Sandwich de rue algérien classique avec frites et omelette.',
    price: 250, imageUrl: 'https://images.unsplash.com/photo-1628191010210-a59de33e5941',
    isFeatured: false, reviews: [],
  ),
];

// ─── Providers ───────────────────────────────────────────────────────────────
final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository(ref.watch(supabaseProvider));
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(menuRepositoryProvider).getCategories();
});

final menuItemsProvider = FutureProvider.family<List<MenuItem>, String?>((ref, categoryId) {
  return ref.watch(menuRepositoryProvider).getMenuItems(categoryId: categoryId);
});

final offersProvider = FutureProvider<List<Offer>>((ref) {
  return ref.watch(menuRepositoryProvider).getOffers();
});

final reviewsProvider = FutureProvider.family<List<Review>, String>((ref, menuItemId) {
  return ref.watch(menuRepositoryProvider).getReviews(menuItemId);
});

final budgetProvider = FutureProvider<UserBudget>((ref) {
  return ref.watch(menuRepositoryProvider).getUserBudget();
});