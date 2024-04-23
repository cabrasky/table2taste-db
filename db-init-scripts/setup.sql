-- Create the "language" table for storing available languages
CREATE TABLE IF NOT EXISTS language (id TEXT PRIMARY KEY);

INSERT INTO
    language (id)
VALUES
    ('en'),
    -- English
    ('es'),
    -- Spanish
    ('fr'),
    -- French
    ('de'),
    -- German
    ('it'),
    -- Italian
    ('pt'),
    -- Portuguese
    ('nl'),
    -- Dutch
    ('ru'),
    -- Russian
    ('zh'),
    -- Chinese
    ('ja'),
    -- Japanese
    ('ko'),
    -- Korean
    ('ar'),
    -- Arabic
    ('hi'),
    -- Hindi
    ('bn'),
    -- Bengali
    ('vi'),
    -- Vietnamese
    ('tr'),
    -- Turkish
    ('pl'),
    -- Polish
    ('sv'),
    -- Swedish
    ('fi'),
    -- Finnish
    ('no');

-- Norwegian
-- Create the "restaurant_info" table for storing restaurant-specific information
CREATE TABLE IF NOT EXISTS restaurant_info (
    id SERIAL PRIMARY KEY,
    default_language_id VARCHAR(10) DEFAULT 'en',
    restaurant_name TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    address TEXT,
    opening_hours JSONB,
    website_url TEXT,
    media_url TEXT,
    FOREIGN KEY (default_language_id) REFERENCES language (id) ON DELETE
    SET
        DEFAULT
);

-- Create the "menu_item" table for storing menu Item information
CREATE TABLE IF NOT EXISTS menu_item (
    id TEXT PRIMARY KEY,
    price DECIMAL,
    preparation_time INT,
    media_url TEXT
);

-- Create the "category" table for storing category information
CREATE TABLE IF NOT EXISTS category (
    id TEXT PRIMARY KEY,
    name TEXT,
    media_url TEXT
);

-- Create the "allergen" table for storing allergen information
CREATE TABLE IF NOT EXISTS allergen (id TEXT PRIMARY KEY, media_url TEXT);

-- Create the "restaurant_language" table for managing enabled languages per restaurant
CREATE TABLE IF NOT EXISTS restaurant_language (
    restaurant_id INT NOT NULL,
    language_id TEXT NOT NULL,
    enabled BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (restaurant_id, language_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant_info (id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE
);

-- Create the "translation" table for storing translations
CREATE TABLE IF NOT EXISTS translation (
    id SERIAL PRIMARY KEY,
    language_id VARCHAR(10) NOT NULL,
    translation_key VARCHAR(50) NOT NULL,
    value VARCHAR(255) NOT NULL,
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE
);

-- Create the "menu_item_category" table for many-to-many relationship between menu items and categories
CREATE TABLE IF NOT EXISTS menu_item_category (
    menu_item_id TEXT NOT NULL,
    category_id TEXT DEFAULT NULL,
    PRIMARY KEY (menu_item_id, category_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE
    SET
        DEFAULT
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

-- Create the "language_translation" table for associating languages with translations
CREATE TABLE IF NOT EXISTS language_translation (
    language_id TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (language_id, translation_id),
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "app_translation" table for associating app translations with main translations
CREATE TABLE IF NOT EXISTS app_translation (
    translation_id INT NOT NULL,
    PRIMARY KEY (translation_id),
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "group" table for managing user groups and their privileges
CREATE TABLE IF NOT EXISTS "group" (
    id TEXT PRIMARY KEY,
    privileges JSONB -- Storing privileges as JSONB for flexibility
);

-- Create the "user" table for managing users
CREATE TABLE IF NOT EXISTS "user" (
    id SERIAL PRIMARY KEY,
    name TEXT,
    photo_url TEXT
);

-- Create the "user_group" table to associate users with multiple groups
CREATE TABLE IF NOT EXISTS user_group (
    user_id INT NOT NULL,
    group_id TEXT NOT NULL,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES "group" (id) ON DELETE CASCADE
);

-- Create the "group_translation" table for associating group names with translations
CREATE TABLE IF NOT EXISTS group_translation (
    group_id TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (group_id, translation_id),
    FOREIGN KEY (group_id) REFERENCES "group" (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Inserting data for the admin and waiter groups
INSERT INTO "group" (id, privileges) 
VALUES 
    ('admin', '{"manage_users": true, "manage_orders": true, "manage_menus": true}'),
    ('waiter', '{"manage_orders": true}'),
    ('guest', '{"view_menus": true, "place_orders": true}');

-- Inserting data for default admin and waiter users
INSERT INTO "user" (name, photo_url) 
VALUES 
    ('Default Admin', 'admin_photo_url'),
    ('Default Waiter', 'waiter_photo_url');

-- Associate default admin and waiter users with their respective groups
INSERT INTO user_group (user_id, group_id)
VALUES 
    ((SELECT id FROM "user" WHERE name = 'Default Admin'), 'admin'),
    ((SELECT id FROM "user" WHERE name = 'Default Waiter'), 'waiter');


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
    waiter_id INT NOT NULL,
    open_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    close_timestamp TIMESTAMP,
    is_open BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (table_id) REFERENCES "table" (id),
    FOREIGN KEY (waiter_id) REFERENCES "user" (id)
);

-- Create the "order" table for managing orders within each service
CREATE TABLE IF NOT EXISTS "order" (
    id SERIAL PRIMARY KEY,
    service_id INT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    FOREIGN KEY (service_id) REFERENCES service (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "user" (id)
);

-- Create the "order_menu_item" table for associating menu items with orders
CREATE TABLE IF NOT EXISTS order_menu_item (
    order_id INT NOT NULL,
    menu_item_id TEXT NOT NULL,
    quantity INT DEFAULT 1,
    PRIMARY KEY (order_id, menu_item_id),
    FOREIGN KEY (order_id) REFERENCES "order" (id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE
);