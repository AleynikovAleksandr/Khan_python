use AleynikovAD_db1;
create database AleynikovAD_db1;
SHOW TABLES;

CREATE TABLE Zone_Type (
    zone_type_id INT PRIMARY KEY AUTO_INCREMENT,
    zone_type VARCHAR(50) NOT NULL
);

CREATE TABLE `Table` (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    zone_id INT NOT NULL,
    table_label VARCHAR(50) NOT NULL,
    seat_count INT NOT NULL CHECK (seat_count >= 0),
    FOREIGN KEY (zone_id) REFERENCES Zone_Type(zone_type_id)
);

CREATE TABLE Visitor (
    passport VARCHAR(10) PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT '-' NULL,
    bank_card_number VARCHAR(16) NOT NULL,
    login VARCHAR(50) NOT NULL,
    `password` VARCHAR(36) NOT NULL,
    CHECK (LENGTH(password) >= 8 AND 
		password REGEXP '[a-zA-Z]' AND 
        password REGEXP '[0-9]' AND 
        password REGEXP '[!@#$%^&*()]')
);

CREATE TABLE Dishes_in_Order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    menu_item_id INT NOT NULL,
    order_number INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    FOREIGN KEY (menu_item_id) REFERENCES Menu(menu_id),
	FOREIGN KEY (order_number) REFERENCES `Order`(order_number)
);

CREATE TABLE Menu (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    menu_name VARCHAR(100) NOT NULL,
    weight DECIMAL(10,2) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Composition (
    ingredient_id INT NOT NULL,
    menu_id INT NOT NULL,
    PRIMARY KEY (ingredient_id, menu_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id),
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id)
);

CREATE TABLE Ingredient (
    ingredient_id INT PRIMARY KEY AUTO_INCREMENT,
    ingredient_name VARCHAR(100) NOT NULL
);

CREATE TABLE Estimate (
    estimate_number INT PRIMARY KEY AUTO_INCREMENT,
    ingredient_id INT NOT NULL,
    weight DECIMAL(10,2) NOT NULL,
    okpo VARCHAR(10) NOT NULL,
    formation_date DATE NOT NULL,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id),
    FOREIGN KEY (okpo) REFERENCES Supplier(okpo)
);


CREATE TABLE Supplier (
    okpo VARCHAR(10) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(10) NOT NULL
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
    FOREIGN KEY (check_number) REFERENCES `Check`(check_number),
    FOREIGN KEY (employee) REFERENCES  Waiter(login),
    FOREIGN KEY (`table`) REFERENCES `Table`(table_id),
    FOREIGN KEY (`status`) REFERENCES  Statuses(status_id),
    FOREIGN KEY (visitor) REFERENCES Visitor(passport)
);

CREATE TABLE Waiter (
    login VARCHAR(50) PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT '-',
    `password` VARCHAR(36) NOT NULL,
    CHECK (LENGTH(password) >= 8 AND 
           password REGEXP '[a-zA-Z]' AND 
           password REGEXP '[0-9]' AND 
           password REGEXP '[!@#$%^&*()]')
);

CREATE TABLE `Check` (
    check_number INT PRIMARY KEY AUTO_INCREMENT,
    date_time DATETIME NOT NULL,
    payment_type INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    `change` DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (payment_type) REFERENCES Payment_Type(payment_id)
);

CREATE TABLE Additional_Dish (
    id INT PRIMARY KEY AUTO_INCREMENT,
    menu_item_id INT NULL,
    order_number INT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    guest VARCHAR(15) NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES Menu(menu_id),
    FOREIGN KEY (order_number) REFERENCES `Order`(order_number),
    FOREIGN KEY (guest) REFERENCES  Guest (phone_number)
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
    middle_name VARCHAR(50) DEFAULT '-'
);

CREATE INDEX idx_zone_id ON `Table` (zone_id);

CREATE INDEX idx_last_name ON Visitor (last_name);
CREATE INDEX idx_first_name ON Visitor (first_name);
CREATE INDEX idx_login ON Visitor (login);

CREATE INDEX idx_menu_item_id ON Dishes_in_Order (menu_item_id);
CREATE INDEX idx_order_number ON Dishes_in_Order (order_number);


CREATE INDEX idx_menu_name ON Menu (menu_name);


CREATE INDEX idx_ingredient_id ON Composition (ingredient_id);
CREATE INDEX idx_menu_id ON Composition (menu_id);


CREATE INDEX idx_ingredient_id_estimate ON Estimate (ingredient_id);
CREATE INDEX idx_okpo ON Estimate (okpo);
CREATE INDEX idx_formation_date ON Estimate (formation_date);


CREATE INDEX idx_supplier_name ON Supplier (supplier_name);
CREATE INDEX idx_city ON Supplier (city);


CREATE INDEX idx_check_number ON `Order` (check_number);
CREATE INDEX idx_employee ON `Order` (employee);
CREATE INDEX idx_table ON `Order` (`table`);
CREATE INDEX idx_status ON `Order` (`status`);
CREATE INDEX idx_visitor ON `Order` (visitor);
CREATE INDEX idx_open_date_time ON `Order` (open_date_time);


CREATE INDEX idx_last_name_waiter ON Waiter (last_name);
CREATE INDEX idx_first_name_waiter ON Waiter (first_name);


CREATE INDEX idx_date_time ON `Check` (date_time);
CREATE INDEX idx_payment_type ON `Check` (payment_type);


CREATE INDEX idx_menu_item_id_additional ON Additional_Dish (menu_item_id);
CREATE INDEX idx_order_number_additional ON Additional_Dish (order_number);
CREATE INDEX idx_guest ON Additional_Dish (guest);


CREATE INDEX idx_status ON Statuses (`status`);


CREATE INDEX idx_payment_type_name ON Payment_Type (payment_type);


CREATE INDEX idx_last_name_guest ON Guest (last_name);
CREATE INDEX idx_first_name_guest ON Guest (first_name);
