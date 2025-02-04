CREATE DATABASE AleynikovAD_db1;
USE AleynikovAD_db1;

CREATE TABLE Zone_Type (
    zone_type_id INT PRIMARY KEY AUTO_INCREMENT,
    zone_type VARCHAR(50) NOT NULL
);

CREATE TABLE Menu (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    menu_name VARCHAR(100) NOT NULL,
    weight DECIMAL(10,2) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Ingredient (
    ingredient_id INT PRIMARY KEY AUTO_INCREMENT,
    ingredient_name VARCHAR(100) NOT NULL
);

CREATE TABLE Supplier (
    okpo VARCHAR(10) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(50) NOT NULL
);

CREATE TABLE Statuses (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    `status` VARCHAR(50) NOT NULL
);

CREATE TABLE Payment_Type (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_type VARCHAR(50) NOT NULL
);

CREATE TABLE Guest (
    phone_number VARCHAR(15) PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL
);

CREATE TABLE Composition (
    ingredient_id INT NOT NULL,
    menu_id INT NOT NULL,
    PRIMARY KEY (ingredient_id, menu_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Estimate (
    estimate_number INT PRIMARY KEY AUTO_INCREMENT,
    ingredient_id INT NOT NULL,
    weight DECIMAL(10,2) NOT NULL,
    okpo VARCHAR(10) NOT NULL,
    formation_date DATE NOT NULL,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (okpo) REFERENCES Supplier(okpo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `Table` (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    zone_id INT NOT NULL,
    table_label VARCHAR(50) NOT NULL,
    seat_count INT NOT NULL CHECK (seat_count >= 0),
    FOREIGN KEY (zone_id) REFERENCES Zone_Type(zone_type_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Visitor (
    passport VARCHAR(10) PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL,
    bank_card_number VARCHAR(16) NOT NULL,
    login VARCHAR(50) NOT NULL,
    `password` VARCHAR(255) NOT NULL
);

CREATE TABLE Waiter (
    login VARCHAR(50) PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL,
    `password` VARCHAR(255) NOT NULL
);

CREATE TABLE `Check` (
    check_number INT PRIMARY KEY AUTO_INCREMENT,
    date_time DATETIME NOT NULL,
    payment_type INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    `change` DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (payment_type) REFERENCES Payment_Type(payment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `Order` (
    order_number INT PRIMARY KEY AUTO_INCREMENT,
    check_number INT NOT NULL,
    employee VARCHAR(50) NOT NULL,
    open_date_time DATETIME NOT NULL,
    `table` INT NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    `status` INT NOT NULL,
    visitor VARCHAR(10) NOT NULL,
    FOREIGN KEY (check_number) REFERENCES `Check`(check_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (employee) REFERENCES Waiter(login) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`table`) REFERENCES `Table`(table_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`status`) REFERENCES Statuses(status_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (visitor) REFERENCES Visitor(passport) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Dishes_in_Order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    menu_item_id INT NOT NULL,
    order_number INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    FOREIGN KEY (menu_item_id) REFERENCES Menu(menu_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (order_number) REFERENCES `Order`(order_number) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Additional_Dish (
    id INT PRIMARY KEY AUTO_INCREMENT,
    menu_item_id INT NULL,
    order_number INT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    guest VARCHAR(15) NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES Menu(menu_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (order_number) REFERENCES `Order`(order_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (guest) REFERENCES Guest(phone_number) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Индексы
CREATE INDEX idx_table_label ON `Table` (table_label);
CREATE INDEX idx_last_first_name_visitor ON Visitor (last_name, first_name);
CREATE INDEX idx_last_first_name_waiter ON Waiter (last_name, first_name);
CREATE INDEX idx_last_first_name_guest ON Guest (last_name, first_name);
CREATE INDEX idx_check_employee_table_status_visitor ON `Order` (check_number, employee, `table`, status, visitor);
CREATE INDEX idx_menu_name ON Menu (menu_name);
CREATE INDEX idx_formation_date ON Estimate (formation_date);
CREATE INDEX idx_okpo ON Estimate (okpo);
CREATE INDEX idx_supplier_name ON Supplier (supplier_name);
CREATE INDEX idx_city ON Supplier (city);
CREATE INDEX idx_menu_item_id_additional ON Additional_Dish (menu_item_id);
CREATE INDEX idx_order_number_additional ON Additional_Dish (order_number);
CREATE INDEX idx_guest ON Additional_Dish (guest);
CREATE INDEX idx_menu_item_id ON Dishes_in_Order (menu_item_id);
CREATE INDEX idx_order_number ON Dishes_in_Order (order_number);
CREATE INDEX idx_status ON Statuses (`status`);

-- Пользователи и привилегии
CREATE USER rl_administrator@'127.0.0.1' IDENTIFIED BY 'Pa$$w0rd';
CREATE USER rl_visitor@'127.0.0.1' IDENTIFIED BY 'Pa$$w0rd';
CREATE USER rl_waiter@'127.0.0.1' IDENTIFIED BY 'Pa$$w0rd';

GRANT ALL PRIVILEGES ON AleynikovAD_db1.* TO 'rl_administrator'@'127.0.0.1';

GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Visitor TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Menu TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Zone_Type TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.`Table` TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Statuses TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Payment_Type TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Ingredient TO 'rl_visitor'@'127.0.0.1';

GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.`Order` TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Dishes_in_Order TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.`Check` TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Menu TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.`Table` TO 'rl_waiter'@'127.0.0.1';