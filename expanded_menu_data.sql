-- ===================================================
-- LuxeBite - Expanded Menu Data (Run in Supabase SQL Editor)
-- ===================================================

-- First clear existing sample data to avoid duplicates
TRUNCATE TABLE offers RESTART IDENTITY CASCADE;

-- Re-insert Categories with more variety
INSERT INTO categories (name_en, name_ar, icon) VALUES 
('Starters', 'مقبلات', 'soup_kitchen'),
('Main Dishes', 'أطباق رئيسية', 'restaurant'),
('Grills & BBQ', 'مشاوي وباربيكيو', 'outdoor_grill'),
('Sandwiches', 'سندويتشات', 'lunch_dining'),
('Pizza', 'بيتزا', 'local_pizza'),
('Pasta', 'باستا', 'ramen_dining'),
('Desserts', 'حلويات', 'icecream'),
('Hot Drinks', 'مشروبات ساخنة', 'coffee'),
('Cold Drinks', 'مشروبات باردة', 'local_bar'),
('Salads', 'سلطات', 'eco')
ON CONFLICT DO NOTHING;

-- ===================================================
-- MENU ITEMS - Rich variety with DZD prices
-- ===================================================

-- STARTERS
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Crispy Calamari', 'كاليماري مقرمش', 
  'Golden fried squid rings with garlic aioli and lemon.', 
  'حلقات حبار مقلية ذهبية مع صلصة الثوم والليمون.', 
  890, 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0', true
FROM categories c WHERE c.name_en = 'Starters' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Cheese Spring Rolls', 'سبرينج رول بالجبن', 
  'Crispy rolls filled with three types of melted cheese.', 
  'أصابع مقرمشة محشوة بثلاثة أنواع من الجبن المذاب.', 
  650, 'https://images.unsplash.com/photo-1603133872878-684f208fb84b', false
FROM categories c WHERE c.name_en = 'Starters' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Mushroom Bruschetta', 'بروسكيتا بالفطر', 
  'Toasted baguette with sautéed mushrooms, garlic and herbs.', 
  'خبز باغيت محمص مع فطر مقلي بالثوم والخضروات العطرية.', 
  720, 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f', false
FROM categories c WHERE c.name_en = 'Starters' LIMIT 1;

-- MAIN DISHES
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Truffle Ribeye Steak', 'ريب آي بالترفل', 
  'Premium Angus beef with black truffle butter and seasonal vegetables.', 
  'لحم أنجوس فاخر مع زبدة الترفل الأسود وخضروات موسمية.', 
  4500, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c', true
FROM categories c WHERE c.name_en = 'Main Dishes' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Grilled Sea Bass', 'لوباس مشوي', 
  'Whole sea bass grilled with herbs, lemon and garlic butter.', 
  'سمك لوباس كامل مشوي مع الأعشاب وزبدة الثوم والليمون.', 
  3800, 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2', true
FROM categories c WHERE c.name_en = 'Main Dishes' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Chicken Cordon Bleu', 'كوردون بلو دجاج', 
  'Stuffed chicken breast with ham and melted cheese in crispy crust.', 
  'صدر دجاج محشو باللحم والجبن المذاب في قشرة مقرمشة.', 
  2200, 'https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8', false
FROM categories c WHERE c.name_en = 'Main Dishes' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Lamb Tagine', 'طاجن لحم الضأن', 
  'Slow-cooked lamb with dried fruits, almonds and Moroccan spices.', 
  'لحم ضأن مطهو ببطء مع الفواكه المجففة واللوز والبهارات المغربية.', 
  2800, 'https://images.unsplash.com/photo-1585325701954-a7f2f37ee6ee', false
FROM categories c WHERE c.name_en = 'Main Dishes' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Shrimp Thermidor', 'روبيان ثيرميدور', 
  'King prawns in a rich creamy sauce with parmesan gratin.', 
  'روبيان ملكي في صلصة كريمية غنية مع جراتان البارميزان.', 
  3200, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641', true
FROM categories c WHERE c.name_en = 'Main Dishes' LIMIT 1;

-- GRILLS & BBQ
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Mixed Grill Platter', 'تشكيلة مشاوي', 
  'Lamb chops, chicken skewer, kofta and grilled vegetables.', 
  'ضلوع خروف، أسياخ دجاج، كفتة وخضروات مشوية.', 
  3500, 'https://images.unsplash.com/photo-1544025162-d76694265947', true
FROM categories c WHERE c.name_en = 'Grills & BBQ' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'BBQ Beef Ribs', 'ضلوع بقري باربيكيو', 
  'Slow-smoked beef ribs with house BBQ sauce and coleslaw.', 
  'ضلوع بقري مدخن ببطء مع صلصة الباربيكيو الخاصة وسلطة الكرنب.', 
  4200, 'https://images.unsplash.com/photo-1544025162-d76694265947', false
FROM categories c WHERE c.name_en = 'Grills & BBQ' LIMIT 1;

-- SANDWICHES
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Wagyu Smash Burger', 'واغيو سماش برجر', 
  'Double smashed wagyu patty with truffle mayo and aged cheddar.', 
  'باتي واغيو مضغوط مزدوج مع مايونيز الترفل وشيدر معتق.', 
  1800, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', true
FROM categories c WHERE c.name_en = 'Sandwiches' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Crispy Chicken Sandwich', 'ساندويتش دجاج مقرمش', 
  'Southern fried chicken breast with pickles and spicy mayo.', 
  'صدر دجاج مقلي على الطريقة الجنوبية مع المخلل والمايونيز الحار.', 
  1200, 'https://images.unsplash.com/photo-1606755962773-d324e0a13086', false
FROM categories c WHERE c.name_en = 'Sandwiches' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Club Sandwich LuxeBite', 'كلوب ساندويتش لوكسبايت', 
  'Triple decker with grilled chicken, turkey, bacon and avocado.', 
  'ثلاث طبقات مع دجاج مشوي وتركي وبيكون وأفوكادو.', 
  1400, 'https://images.unsplash.com/photo-1528736235302-52922df5c122', false
FROM categories c WHERE c.name_en = 'Sandwiches' LIMIT 1;

-- PIZZA
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Truffle Prosciutto Pizza', 'بيتزا ترفل وبروشوتو', 
  'Sourdough base with truffle cream, prosciutto and arugula.', 
  'عجينة محمصة مع كريمة الترفل والبروشوتو والجرجير.', 
  2200, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', true
FROM categories c WHERE c.name_en = 'Pizza' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Four Cheese Volcano', 'فولكانو أربع جبن', 
  'Loaded with mozzarella, gorgonzola, parmesan and brie.', 
  'محشوة بالموزاريلا، الغورغونزولا، البارميزان والبري.', 
  1900, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002', false
FROM categories c WHERE c.name_en = 'Pizza' LIMIT 1;

-- PASTA
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Lobster Linguine', 'لينغويني بالكركند', 
  'Fresh pasta with lobster bisque, cherry tomatoes and basil.', 
  'باستا طازجة مع بيسك الكركند وطماطم كرزية وريحان.', 
  3200, 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5', false
FROM categories c WHERE c.name_en = 'Pasta' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Black Truffle Carbonara', 'كاربونارا بالترفل الأسود', 
  'Silky carbonara with crispy pancetta and shaved black truffle.', 
  'كاربونارا حريرية مع بانشيتا مقرمشة وشرائح الترفل الأسود.', 
  2600, 'https://images.unsplash.com/photo-1612874742237-6527d0d42132', true
FROM categories c WHERE c.name_en = 'Pasta' LIMIT 1;

-- DESSERTS
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Velvet Lava Cake', 'كيكة لافا مخملية', 
  'Dark Belgian chocolate with a molten salted caramel heart.', 
  'شوكولاتة بلجيكية داكنة مع قلب ذائب من الكراميل المملح.', 
  980, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb', true
FROM categories c WHERE c.name_en = 'Desserts' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Pistachio Baklava Tower', 'برج بقلاوة فستق', 
  'Layers of crispy filo with Algerian pistachio and orange blossom honey.', 
  'طبقات من عجينة الفيلو مع فستق جزائري وعسل زهر البرتقال.', 
  750, 'https://images.unsplash.com/photo-1571397133301-a2c4df8e3f5e', false
FROM categories c WHERE c.name_en = 'Desserts' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Crème Brûlée Royal', 'كريم بروليه رويال', 
  'Vanilla bean custard with a perfectly caramelized sugar crust.', 
  'كاسترد حبة الفانيليا مع قشرة سكر مكرملة بشكل مثالي.', 
  850, 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc', false
FROM categories c WHERE c.name_en = 'Desserts' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Gold Leaf Tiramisu', 'تيراميسو بورق الذهب', 
  'Classic Italian tiramisu topped with 24k edible gold leaf.', 
  'تيراميسو إيطالي كلاسيكي مزين بورق الذهب الصالح للأكل عيار 24 قيراط.', 
  1100, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9', true
FROM categories c WHERE c.name_en = 'Desserts' LIMIT 1;

-- HOT DRINKS
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Gold Leaf Cappuccino', 'كابوتشينو بورق الذهب', 
  'Arabica coffee topped with 24k edible gold leaf and latte art.', 
  'قهوة أرابيكا مع ورق ذهب صالح للأكل وفن الحليب.', 
  750, 'https://images.unsplash.com/photo-1541167760496-162955ed2a95', true
FROM categories c WHERE c.name_en = 'Hot Drinks' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Royal Moroccan Tea', 'شاي مغربي ملكي', 
  'Premium green tea with fresh mint and pine nuts.', 
  'شاي أخضر فاخر مع نعناع طازج وصنوبر.', 
  350, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc', false
FROM categories c WHERE c.name_en = 'Hot Drinks' LIMIT 1;

-- COLD DRINKS
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Azure Berry Mocktail', 'موكتيل توت لازوردي', 
  'Butterfly pea tea with mixed berries, mint and lychee foam.', 
  'شاي البازلاء الفراشية مع توت مشكل ونعناع وكريمة اللتشي.', 
  680, 'https://images.unsplash.com/photo-1544145945-f90425340c7e', true
FROM categories c WHERE c.name_en = 'Cold Drinks' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Mango Lassi Royale', 'لاسي المانغو الملكي', 
  'Alphonso mango blended with yogurt, cardamom and saffron.', 
  'مانغو ألفونسو ممزوج بالزبادي والهيل والزعفران.', 
  520, 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d', false
FROM categories c WHERE c.name_en = 'Cold Drinks' LIMIT 1;

-- SALADS
INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Burrata & Heirloom Tomato', 'بوراتا مع طماطم بلدية', 
  'Creamy burrata with heirloom tomatoes, basil oil and sea salt.', 
  'بوراتا كريمية مع طماطم بلدية وزيت الريحان وملح البحر.', 
  1200, 'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14a5', true
FROM categories c WHERE c.name_en = 'Salads' LIMIT 1;

INSERT INTO menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
SELECT c.id, 'Caesar Supreme', 'سيزر سوبريم', 
  'Romaine hearts, anchovy dressing, parmesan shavings and croutons.', 
  'قلوب خس روماني مع صلصة الأنشوجة وشرائح البارميزان والخبز المحمص.', 
  950, 'https://images.unsplash.com/photo-1546793665-c74683f339c1', false
FROM categories c WHERE c.name_en = 'Salads' LIMIT 1;

-- ===================================================
-- UPDATED OFFERS with DZD Prices
-- ===================================================
INSERT INTO offers (title_en, title_ar, description_en, description_ar, discount_percentage, image_url, valid_until) VALUES
('Gourmet Weekend Deal', 'عرض نهاية الأسبوع الفاخر', 
 'Get 25% off all main dishes this weekend. A taste of luxury awaits.', 
 'احصل على خصم 25٪ على جميع الأطباق الرئيسية هذا الأسبوع. تجربة فاخرة تنتظرك.', 
 25, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
 NOW() + INTERVAL '7 days'),
 
('Dessert Heaven', 'جنة الحلويات', 
 'Buy any main dish and get a free dessert. Sweet moments included.', 
 'اطلب أي طبق رئيسي واحصل على حلوى مجانية. لحظات حلوة مشمولة.', 
 100, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb',
 NOW() + INTERVAL '3 days'),
 
('Drinks Fiesta', 'مهرجان المشروبات', 
 '50% discount on all cold drinks and mocktails. Beat the heat in style.', 
 'خصم 50٪ على جميع المشروبات الباردة والموكتيل. انعش نفسك بأناقة.', 
 50, 'https://images.unsplash.com/photo-1544145945-f90425340c7e',
 NOW() + INTERVAL '5 days');
