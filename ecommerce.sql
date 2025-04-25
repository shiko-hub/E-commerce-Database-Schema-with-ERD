-- Create the database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Brand table
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (brand_name)
);

-- Product category table
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id) ON DELETE SET NULL,
    UNIQUE (category_name)
);

-- Product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE CASCADE
);

-- Color table
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (color_name)
);

-- Size category table
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (category_name)
);

-- Size option table
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id) ON DELETE CASCADE,
    UNIQUE (size_category_id, size_value)
);

-- Product variation table
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT,
    size_id INT,
    sku VARCHAR(50) NOT NULL,
    additional_price DECIMAL(10,2) DEFAULT 0.00,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(color_id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE SET NULL,
    UNIQUE (sku),
    CHECK (stock_quantity >= 0)
);

-- Product image table
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

-- Attribute category table
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (category_name)
);

-- Attribute type table
CREATE TABLE attribute_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (type_name)
);

-- Product attribute table
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_category_id INT NOT NULL,
    type_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    string_value TEXT,
    number_value DECIMAL(10,2),
    boolean_value BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES attribute_type(type_id) ON DELETE CASCADE
);

-- Product item table
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL,
    barcode VARCHAR(50),
    stock_quantity INT DEFAULT 0,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id) ON DELETE CASCADE,
    UNIQUE (sku),
    UNIQUE (barcode),
    CHECK (stock_quantity >= 0)
);

-- Create indexes for performance
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_name ON product(product_name);
CREATE INDEX idx_variation_product ON product_variation(product_id);
CREATE INDEX idx_variation_color ON product_variation(color_id);
CREATE INDEX idx_variation_size ON product_variation(size_id);
CREATE INDEX idx_product_image ON product_image(product_id);
CREATE INDEX idx_product_attr ON product_attribute(product_id);
CREATE INDEX idx_item_variation ON product_item(variation_id);
