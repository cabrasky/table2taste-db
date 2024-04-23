-- Create the "language" table for storing available languages
CREATE TABLE IF NOT EXISTS language
(
    id TEXT PRIMARY KEY
);

INSERT INTO language (id)
VALUES ('en'), -- English
       ('es'), -- Spanish
       ('fr'), -- French
       ('de'), -- German
       ('it'), -- Italian
       ('pt'), -- Portuguese
       ('nl'), -- Dutch
       ('ru'), -- Russian
       ('zh'), -- Chinese
       ('ja'), -- Japanese
       ('ko'), -- Korean
       ('ar'), -- Arabic
       ('hi'), -- Hindi
       ('bn'), -- Bengali
       ('vi'), -- Vietnamese
       ('tr'), -- Turkish
       ('pl'), -- Polish
       ('sv'), -- Swedish
       ('fi'), -- Finnish
       ('no'); -- Norwegian


-- Create the "restaurant_info" table for storing restaurant-specific information
CREATE TABLE IF NOT EXISTS restaurant_info
(
    id                  SERIAL PRIMARY KEY,
    default_language_id VARCHAR(10) DEFAULT 'en',
    restaurant_name     TEXT,
    contact_email       TEXT,
    contact_phone       TEXT,
    address             TEXT,
    opening_hours       JSONB,
    website_url         TEXT,
    media_url           TEXT,
    FOREIGN KEY (default_language_id) REFERENCES language (id) ON DELETE SET DEFAULT
);


-- Create the "menu_item" table for storing menu Item information
CREATE TABLE IF NOT EXISTS menu_item
(
    id               TEXT PRIMARY KEY,
    price            DECIMAL,
    preparation_time INT,
    media_url        TEXT
);

-- Create the "category" table for storing category information
CREATE TABLE IF NOT EXISTS category
(
    id            SERIAL PRIMARY KEY,
    name          TEXT,
    media_url     TEXT
);

-- Create the "allergen" table for storing allergen information
CREATE TABLE IF NOT EXISTS allergen
(
    id            TEXT PRIMARY KEY,
    media_url     TEXT
);

-- Create the "restaurant_language" table for managing enabled languages per restaurant
CREATE TABLE IF NOT EXISTS restaurant_language
(
    restaurant_id  INT  NOT NULL,
    language_id    TEXT  NOT NULL,
    enabled        BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (restaurant_id, language_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant_info (id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE
);

-- Create the "translation" table for storing translations
CREATE TABLE IF NOT EXISTS translation
(
    id              SERIAL PRIMARY KEY,
    language_id     VARCHAR(10)  NOT NULL,
    translation_key VARCHAR(50)  NOT NULL,
    value           VARCHAR(255) NOT NULL,
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE
);

-- Create the "menu_item_category" table for many-to-many relationship between menu items and categories
CREATE TABLE IF NOT EXISTS menu_item_category
(
    menu_item_id      TEXT NOT NULL,
    category_id   INT NOT NULL,
    PRIMARY KEY (menu_item_id, category_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE
);

-- Create the "menu_item_allergen" table for many-to-many relationship between menu items and allergens
CREATE TABLE IF NOT EXISTS menu_item_allergen
(
    menu_item_id      TEXT NOT NULL,
    allergen_id   TEXT NOT NULL,
    PRIMARY KEY (menu_item_id, allergen_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE,
    FOREIGN KEY (allergen_id) REFERENCES allergen (id) ON DELETE CASCADE
);

-- Create the "menu_item_translation" table for associating menu items with translations
CREATE TABLE IF NOT EXISTS menu_item_translation
(
    menu_item_id       TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (menu_item_id, translation_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "allergen_translation" table for associating allergens with translations
CREATE TABLE IF NOT EXISTS allergen_translation
(
    allergen_id    TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (allergen_id, translation_id),
    FOREIGN KEY (allergen_id) REFERENCES allergen (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "language_translation" table for associating languages with translations
CREATE TABLE IF NOT EXISTS language_translation
(
    language_id    TEXT NOT NULL,
    translation_id INT NOT NULL,
    PRIMARY KEY (language_id, translation_id),
    FOREIGN KEY (language_id) REFERENCES language (id) ON DELETE CASCADE,
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "app_translation" table for associating app translations with main translations
CREATE TABLE IF NOT EXISTS app_translation
(
    translation_id INT NOT NULL,
    PRIMARY KEY (translation_id),
    FOREIGN KEY (translation_id) REFERENCES translation (id) ON DELETE CASCADE
);

-- Create the "service" table for managing restaurant services
CREATE TABLE IF NOT EXISTS service
(
    id                SERIAL PRIMARY KEY,
    restaurant_id     INT NOT NULL,
    open_timestamp    TIMESTAMP,
    close_timestamp   TIMESTAMP,
    is_open           BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurant_info (id) ON DELETE CASCADE
);

-- Create the "order" table for managing orders within each service
CREATE TABLE IF NOT EXISTS "order"
(
    id             SERIAL PRIMARY KEY,
    service_id     INT NOT NULL,
    table_id       INT NOT NULL,
    FOREIGN KEY (service_id) REFERENCES service (id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES "table" (id) ON DELETE CASCADE
);