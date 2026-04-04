-- SQL Setup for LuxeBite Restaurant App (DZD Pricing)

-- 1. Categories Table
create table if not exists categories (
  id uuid default gen_random_uuid() primary key,
  name_en text not null,
  name_ar text not null,
  icon text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Menu Items Table
create table if not exists menu_items (
  id uuid default gen_random_uuid() primary key,
  category_id uuid references categories(id) on delete cascade,
  name_en text not null,
  name_ar text not null,
  description_en text,
  description_ar text,
  price decimal(10,2) not null,
  image_url text,
  is_featured boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Reservations Table
create table if not exists reservations (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id),
  reservation_date date not null,
  reservation_time time not null,
  pax integer not null,
  special_requests text,
  status text default 'pending',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Offers Table
create table if not exists offers (
  id uuid default gen_random_uuid() primary key,
  title_en text not null,
  title_ar text not null,
  description_en text,
  description_ar text,
  discount_percentage integer,
  image_url text,
  valid_until timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. Reviews Table
create table if not exists reviews (
  id uuid default gen_random_uuid() primary key,
  menu_item_id uuid references menu_items(id) on delete cascade,
  user_id uuid references auth.users(id),
  rating integer check (rating >= 1 and rating <= 5),
  comment text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 6. User Budgets Table
create table if not exists user_budgets (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) unique,
  monthly_limit decimal(10,2) not null,
  current_spend decimal(10,2) default 0,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 7. Seed Categories
insert into categories (name_en, name_ar, icon)
values
  ('Drinks', 'ãÔÑæÈÇÊ', 'local_bar'),
  ('Sandwiches', 'ÓÇäÏæíÊÔÇÊ', 'lunch_dining'),
  ('Main Dishes', 'ÃØÈÇŞ ÑÆíÓíÉ', 'restaurant'),
  ('Desserts', 'ÍáæíÇÊ', 'icecream'),
  ('Fast Food', 'æÌÈÇÊ ÓÑíÚÉ', 'fastfood')
on conflict do nothing;

-- 8. Seed Menu Items (prices in DZD)
with c as (
  select name_en, id from categories
)
insert into menu_items (category_id, name_en, name_ar, description_en, description_ar, price, image_url, is_featured)
values
  ((select id from c where name_en = 'Main Dishes' limit 1), 'Truffle Ribeye Steak', 'ÓÊíß ÑíÈ Âí ÈÇáÊÑİ', 'Premium Angus beef with black truffle butter and seasonal vegetables.', 'áÍã ÃäÛæÓ İÇÎÑ ãÚ ÒÈÏÉ ÇáÊÑİá æÎÖÇÑ ãæÓãíÉ.', 5200, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c', true),
  ((select id from c where name_en = 'Main Dishes' limit 1), 'Grilled Salmon Plate', 'ØÈŞ Óáãæä ãÔæí', 'Atlantic salmon with lemon herb sauce and wild rice.', 'Óáãæä ÃØáÓí ãÚ ÕáÕÉ Çááíãæä æÇáÃÚÔÇÈ æÃÑÒ ÈÑí.', 3900, 'https://images.unsplash.com/photo-1467003909585-2f8a72700288', true),
  ((select id from c where name_en = 'Main Dishes' limit 1), 'Chicken Alfredo Pasta', 'ÈÇÓÊÇ ÃáİÑíÏæ ÈÇáÏÌÇÌ', 'Creamy parmesan sauce with grilled chicken strips.', 'ÕáÕÉ ßÑíãíÉ ÈÌÈä ÈÇÑãíÒÇä ãÚ ÔÑÇÆÍ ÏÌÇÌ ãÔæí.', 2450, 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9', false),
  ((select id from c where name_en = 'Main Dishes' limit 1), 'Seafood Risotto', 'ÑíÒæÊæ ÈÍÑí', 'Creamy arborio rice with shrimp, mussels and saffron.', 'ÃÑÒ ÑíÒæÊæ ßÑíãí ãÚ ÌãÈÑí æÈáÍ ÈÍÑ æÒÚİÑÇä.', 3200, 'https://images.unsplash.com/photo-1611270634830-81d7f6ab3e8c', false),

  ((select id from c where name_en = 'Drinks' limit 1), 'Gold Leaf Cappuccino', 'ßÇÈÊÔíäæ ÈæÑŞ ÇáĞåÈ', 'Arabica coffee topped with edible gold flakes.', 'ŞåæÉ ÃÑÇÈíßÇ ãÚ ØÈŞÉ ĞåÈ ÕÇáÍÉ ááÃßá.', 950, 'https://images.unsplash.com/photo-1541167760496-162955ed2a95', true),
  ((select id from c where name_en = 'Drinks' limit 1), 'Fresh Mojito', 'ãæÎíÊæ ãäÚÔ', 'Lime, mint and sparkling soda over crushed ice.', 'áíãæä æäÚäÇÚ æÕæÏÇ İæÇÑÉ ãÚ ËáÌ ãÌÑæÔ.', 650, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735', false),
  ((select id from c where name_en = 'Drinks' limit 1), 'Iced Spanish Latte', 'áÇÊíå ÅÓÈÇäí ãËáÌ', 'Espresso with milk and condensed sweetness, served cold.', 'ÅÓÈÑíÓæ ãÚ ÍáíÈ æáãÓÉ ÍáÇæÉ¡ íŞÏã ÈÇÑÏÇ.', 780, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c', false),

  ((select id from c where name_en = 'Sandwiches' limit 1), 'Club Sandwich', 'ßáæÈ ÓÇäÏæíÊÔ', 'Triple-layer sandwich with turkey, cheese and crisp lettuce.', 'ÓÇäÏæíÊÔ ËáÇËí ÇáØÈŞÇÊ ÈÊÑßí æÌÈä æÎÓ ãŞÑãÔ.', 1350, 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af', true),
  ((select id from c where name_en = 'Sandwiches' limit 1), 'Philly Cheese Steak', 'ÓÇäÏæíÊÔ İíáí ÓÊíß', 'Sliced beef, caramelized onions and melted cheese.', 'ÔÑÇÆÍ áÍã ÈŞÑ ãÚ ÈÕá ãßÑãá æÌÈä ĞÇÆÈ.', 1600, 'https://images.unsplash.com/photo-1550547660-d9450f859349', false),

  ((select id from c where name_en = 'Fast Food' limit 1), 'Smash Burger', 'ÓãøÇÔ ÈÑÛÑ', 'Double smashed beef patties with cheddar and house sauce.', 'ŞØÚÊÇä áÍã ÈŞÑí ãÔæíÊÇä ãÚ ÔíÏÑ æÕæÕ ÎÇÕ.', 1750, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', true),
  ((select id from c where name_en = 'Fast Food' limit 1), 'Crispy Chicken Burger', 'ÈÑÛÑ ÏÌÇÌ ãŞÑãÔ', 'Crunchy chicken fillet with pickles and spicy mayo.', 'İíáíå ÏÌÇÌ ãŞÑãÔ ãÚ ãÎáá æãÇíæäíÒ ÍÇÑ.', 1500, 'https://images.unsplash.com/photo-1606755962773-d324e0a13086', false),
  ((select id from c where name_en = 'Fast Food' limit 1), 'Loaded Fries', 'ÈØÇØÇ ãÛØÇÉ', 'Fries topped with beef bits, cheddar sauce and jalapeno.', 'ÈØÇØÇ ãÚ ŞØÚ áÍã æÕæÕ ÔíÏÑ æåÇáÈíäæ.', 900, 'https://images.unsplash.com/photo-1585238342024-78d387f4a707', false),

  ((select id from c where name_en = 'Desserts' limit 1), 'Velvet Lava Cake', 'ßíßÉ áÇİÇ ãÎãáíÉ', 'Dark Belgian chocolate with a molten heart of salted caramel.', 'ÔæßæáÇÊÉ ÈáÌíßíÉ ÏÇßäÉ ãÚ ŞáÈ ßÑÇãíá ããáÍ.', 1100, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb', false),
  ((select id from c where name_en = 'Desserts' limit 1), 'Cheesecake Lotus', 'ÊÔíÒßíß áæÊÓ', 'Creamy baked cheesecake with lotus caramel crumble.', 'ÊÔíÒßíß ßÑíãí ãÚ ØÈŞÉ áæÊÓ æßÑÇãíá.', 1200, 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad', true),
  ((select id from c where name_en = 'Desserts' limit 1), 'Chocolate Brownie', 'ÈÑÇæäí ÔæßæáÇÊÉ', 'Warm fudge brownie served with vanilla cream.', 'ÈÑÇæäí ÓÇÎä Ûäí ÈÇáÔæßæáÇÊÉ ãÚ ßÑíãÉ İÇäíáÇ.', 950, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c', false)
on conflict do nothing;

-- 9. Sample Offers
insert into offers (title_en, title_ar, description_en, description_ar, discount_percentage, image_url)
values
  ('Gourmet Weekend', 'äåÇíÉ ÃÓÈæÚ İÇÎÑÉ', 'Get 25% off on all main dishes.', 'ÊÍÕá Úáì ÎÕã 25? Úáì ßá ÇáÃØÈÇŞ ÇáÑÆíÓíÉ.', 25, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'),
  ('Combo Night', 'áíáÉ ÇáßæãÈæ', 'Burger + Mojito combo at a special price.', 'ÈÑÛÑ ãÚ ãæÎíÊæ ÈÓÚÑ ÎÇÕ áİÊÑÉ ãÍÏæÏÉ.', 18, 'https://images.unsplash.com/photo-1550547660-d9450f859349'),
  ('Sweet Hour', 'ÓÇÚÉ ÇáÊÍáíÉ', 'Buy one dessert and get the second at 50% off.', 'ÚäÏ ÔÑÇÁ Íáæì¡ ÇáËÇäíÉ ÈÎÕã 50?.', 50, 'https://images.unsplash.com/photo-1488477181946-6428a0291777')
on conflict do nothing;
