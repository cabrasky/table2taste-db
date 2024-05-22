-- Create the "language" table for storing available languages
CREATE TABLE IF NOT EXISTS language (id TEXT PRIMARY KEY);

-- Create the "category" table for storing category information
CREATE TABLE IF NOT EXISTS category (
    id TEXT PRIMARY KEY,
    media_url TEXT,
    parent_category_id TEXT,
    visible BOOLEAN default TRUE,
    FOREIGN KEY (parent_category_id) REFERENCES category (id) ON DELETE
    SET
        NULL
);

-- Create the "menu_item" table for storing menu Item information
CREATE TABLE IF NOT EXISTS menu_item (
    id TEXT PRIMARY KEY,
    price float(53) NOT NULL,
    media_url TEXT NOT NULL,
    category_id TEXT,
    visible BOOLEAN default TRUE,
    FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE
    SET
        NULL
);

-- Create the "allergen" table for storing allergen information
CREATE TABLE IF NOT EXISTS allergen (
    id TEXT PRIMARY KEY,
    media_url TEXT NOT NULL,
    inclusive BOOLEAN NOT NULL
);

-- Create the "translation" table for storing translations
CREATE TABLE IF NOT EXISTS "translation" (
    id SERIAL PRIMARY KEY,
    language_id VARCHAR(10) NOT NULL,
    translation_key VARCHAR(50) NOT NULL,
    value VARCHAR(255) NOT NULL,
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE
);

-- Create the "menu_item_allergen" table for many-to-many relationship between menu items and allergens
CREATE TABLE IF NOT EXISTS menu_item_allergen (
    menu_item_id TEXT NOT NULL,
    allergen_id TEXT NOT NULL,
    PRIMARY KEY (menu_item_id, allergen_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE,
    FOREIGN KEY (allergen_id) REFERENCES allergen (id) ON DELETE CASCADE
);

-- Create the "menu_item_translation" table for associating menu items with translations
CREATE TABLE IF NOT EXISTS menu_item_translation (
    menu_item_id TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (menu_item_id, translation_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "allergen_translation" table for associating allergens with translations
CREATE TABLE IF NOT EXISTS allergen_translation (
    allergen_id TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (allergen_id, translation_id),
    FOREIGN KEY (allergen_id) REFERENCES allergen (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "category_translation" table for associating allergens with translations
CREATE TABLE IF NOT EXISTS category_translation (
    category_id TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (category_id, translation_id),
    FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "group" table for managing user groups
CREATE TABLE IF NOT EXISTS app_group (
    id TEXT PRIMARY KEY,
    color TEXT
);

-- create the "privilage" table for storing the all privilages
CREATE TABLE IF NOT EXISTS app_privilage (id TEXT PRIMARY KEY);

-- Create the "group_privilage" table to associate groups with multiple privilages
CREATE TABLE IF NOT EXISTS group_privilage (
    group_id TEXT NOT NULL,
    privilage_id TEXT NOT NULL,
    PRIMARY KEY (group_id, privilage_id),
    FOREIGN KEY (group_id) REFERENCES app_group (id) ON DELETE CASCADE,
    FOREIGN KEY (privilage_id) REFERENCES app_privilage (id) ON DELETE CASCADE
);

-- Create the "user" table for managing users
CREATE TABLE IF NOT EXISTS app_user (
    username TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    password TEXT NOT NULL,
    photo_url TEXT
);

-- Create the "user_group" table to associate users with multiple groups
CREATE TABLE IF NOT EXISTS user_group (
    user_id TEXT NOT NULL,
    group_id TEXT NOT NULL,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES app_user (username),
    FOREIGN KEY (group_id) REFERENCES app_group (id)
);

-- Create the "group_translation" table for associating group names with translations
CREATE TABLE IF NOT EXISTS group_translation (
    group_id TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (group_id, translation_id),
    FOREIGN KEY (group_id) REFERENCES app_group (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "table" table for managing tables
CREATE TABLE IF NOT EXISTS "table" (
    id SERIAL PRIMARY KEY,
    table_number INT,
    capacity INT
);

-- Create the "service" table for managing restaurant services
CREATE TABLE IF NOT EXISTS service (
    id SERIAL PRIMARY KEY,
    table_id INT NOT NULL,
    waiter_id TEXT NOT NULL,
    open_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    close_timestamp TIMESTAMP,
    is_open BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (table_id) REFERENCES "table" (id),
    FOREIGN KEY (waiter_id) REFERENCES app_user (username)
);

-- Create the "order" table for managing orders within each service
CREATE TABLE IF NOT EXISTS "order" (
    id SERIAL PRIMARY KEY,
    service_id INT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES "service" (id)
);

-- Create the "order_menu_item" table for associating menu items with orders
CREATE TABLE IF NOT EXISTS order_menu_item (
    order_id INT NOT NULL,
    menu_item_id TEXT NOT NULL,
    quantity INT DEFAULT 1,
    PRIMARY KEY (order_id, menu_item_id),
    FOREIGN KEY (order_id) REFERENCES "order" (id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id)
);

/*
INSERT INTO
    language (id)
VALUES
    ('en'),
    ('es'),
    ('fr'),
    ('de'),
    ('it'),
    ('pt'),
    ('nl'),
    ('ru'),
    ('zh'),
    ('ja'),
    ('ko'),
    ('ar'),
    ('hi'),
    ('bn'),
    ('vi'),
    ('tr'),
    ('pl'),
    ('sv'),
    ('fi'),
    ('no');

-- Inserting data for allergens
INSERT INTO
    allergen (id, media_url, inclusive)
VALUES
    (
        'celery',
        'https://example.com/celery_image.jpg',
        false
    ),
    (
        'crustaceans',
        'https://example.com/crustaceans_image.jpg',
        false
    ),
    (
        'eggs',
        'https://example.com/eggs_image.jpg',
        false
    ),
    (
        'fish',
        'https://example.com/fish_image.jpg',
        false
    ),
    (
        'lupin',
        'https://example.com/lupin_image.jpg',
        false
    ),
    (
        'milk',
        'https://example.com/milk_image.jpg',
        false
    ),
    (
        'molluscs',
        'https://example.com/molluscs_image.jpg',
        false
    ),
    (
        'mustard',
        'https://example.com/mustard_image.jpg',
        false
    ),
    (
        'peanuts',
        'https://example.com/peanuts_image.jpg',
        false
    ),
    (
        'sesame',
        'https://example.com/sesame_image.jpg',
        false
    ),
    (
        'soybeans',
        'https://example.com/soybeans_image.jpg',
        false
    ),
    (
        'sulphur_dioxide_sulphites',
        'https://example.com/sulphites_image.jpg',
        false
    ),
    (
        'gluten',
        'https://example.com/gluten_image.jpg',
        false
    ),
    (
        'nuts',
        'https://example.com/nuts_image.jpg',
        false
    ),
    (
        'vegan',
        'https://example.com/vegan_image.jpg',
        true
    ),
    (
        'vegetarian',
        'https://example.com/vegetarian_image.jpg',
        true
    );

-- Inserting data for user groups
INSERT INTO
    "group" (id, color)
VALUES
    ('admin', '#ff0000'),
    ('waiter', '#00ff00'),
    ('guest', '#0000ff');

-- Inserting data for default admin and waiter users
INSERT INTO
    "user" (username, photo_url)
VALUES
    ('Default Admin', 'admin_photo_url'),
    ('Default Waiter', 'waiter_photo_url');

-- Associate default admin and waiter users with their respective groups
INSERT INTO
    user_group (user_id, group_id)
SELECT
    username,
    CASE
        username
        WHEN 'Default Admin' THEN 'admin'
        WHEN 'Default Waiter' THEN 'waiter'
    END
FROM
    "user"
WHERE
    name IN ('Default Admin', 'Default Waiter');

-- Translations for Allergens
INSERT INTO
    translation (id, language_id, translation_key, value)
VALUES
    (1, 'en', 'name', 'Celery'),
    (2, 'es', 'name', 'Apio'),
    (3, 'en', 'name', 'Crustaceans'),
    (4, 'es', 'name', 'Crustáceos'),
    (5, 'en', 'name', 'Eggs'),
    (6, 'es', 'name', 'Huevos'),
    (7, 'en', 'name', 'Fish'),
    (8, 'es', 'name', 'Pescado'),
    (9, 'en', 'name', 'Lupin'),
    (10, 'es', 'name', 'Lupino'),
    (11, 'en', 'name', 'Milk'),
    (12, 'es', 'name', 'Leche'),
    (13, 'en', 'name', 'Molluscs'),
    (14, 'es', 'name', 'Moluscos'),
    (15, 'en', 'name', 'Mustard'),
    (16, 'es', 'name', 'Mostaza'),
    (17, 'en', 'name', 'Peanuts'),
    (18, 'es', 'name', 'Cacauetes'),
    (19, 'en', 'name', 'Sesame'),
    (20, 'es', 'name', 'Sésamo'),
    (21, 'en', 'name', 'Soybeans'),
    (22, 'es', 'name', 'Soja'),
    (23, 'en', 'name', 'Sulphur Dioxide/Sulphites'),
    (24, 'es', 'name', 'Dióxido de Azufre/Sulfitos'),
    (25, 'en', 'name', 'Gluten'),
    (26, 'es', 'name', 'Gluten'),
    (27, 'en', 'name', 'Nuts'),
    (28, 'es', 'name', 'Frutos Secos'),
    (29, 'en', 'name', 'Vegan'),
    (30, 'es', 'name', 'Vegano'),
    (31, 'en', 'name', 'Vegetarian'),
    (32, 'es', 'name', 'Vegetariano');

-- Inserting translations for allergens
INSERT INTO
    allergen_translation (allergen_id, translation_id)
VALUES
    ('celery', 1),
    ('celery', 2),
    ('crustaceans', 3),
    ('crustaceans', 4),    
    ('eggs', 5),    
    ('eggs', 6),    
    ('fish', 7),    
    ('fish', 8),    
    ('lupin', 9),
    ('lupin', 10),    
    ('milk', 11),    
    ('milk', 12),    
    ('molluscs', 13),    
    ('molluscs', 14),    
    ('mustard', 15),    
    ('mustard', 16),    
    ('peanuts', 17),    
    ('peanuts', 18),    
    ('sesame', 19),    
    ('sesame', 20),    
    ('soybeans', 21),    
    ('soybeans', 22),    
    ('sulphur_dioxide_sulphites', 23),    
    ('sulphur_dioxide_sulphites', 24),    
    ('gluten', 25),    
    ('gluten', 26),    
    ('nuts', 27),    
    ('nuts', 28),    
    ('vegan', 29),    
    ('vegan', 30),
    ('vegetarian', 31),    
    ('vegetarian', 32);

SELECT setval('order_id_seq', (SELECT MAX(id) FROM "order") + 1, true);
SELECT setval('service_id_seq', (SELECT MAX(id) FROM "service") + 1, true);
SELECT setval('table_id_seq', (SELECT MAX(id) FROM "table") + 1, true);
SELECT setval('translation_id_seq', (SELECT MAX(id) FROM "translation") + 1, true); 
*/