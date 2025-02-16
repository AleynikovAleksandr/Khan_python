DROP DATABASE AleynikovAD_db1;


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
    estimate_number INT NOT NULL,
    ingredient_id INT NOT NULL,
    weight DECIMAL(12,3) NOT NULL,
    okpo CHAR(10) NOT NULL,
    formation_date DATE NOT NULL,
    PRIMARY KEY (estimate_number, ingredient_id),
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


INSERT INTO Zone_Type (zone_type) VALUES ('Общая зона'), ('Детская зона'), ('Частная зона');

INSERT INTO Waiter (login, last_name, first_name, middle_name, `password`) VALUES
('of_SemenovKN', 'Семёнов', 'Кирилл', 'Николаевич', 'Pa$$w0rd'),
('of_AndreevAA', 'Андреев', 'Андрей', 'Андреевич', 'Pa$$w0rd'),
('of_DmitrievOI', 'Дмитриев', 'Олег', 'Иванович', 'Pa$$w0rd');

INSERT INTO Visitor (passport, last_name, first_name, middle_name, bank_card_number, login, `password`) VALUES
('4510665764', 'Иванов', 'Иван', 'Иванович', '4825773177881752', 'IvanovII', 'Pa$$w0rd'),
('4678239712', 'Петров', 'Алексей', 'Алексеевич', '565211479921', 'PetrovAA', 'Pa$$w0rd'),
('4515009426', 'Павлов', 'Евгений', 'Геннадьевич', '313477425677', 'PavlovEG', 'Pa$$w0rd');

INSERT INTO Guest (phone_number, last_name, first_name, middle_name) VALUES
('1234567890', 'Фёдоров', 'Владимир', 'Алексеевич'),
('0987654321', 'Владимиров', 'Андрей', 'Иванович'),
('1122334455', 'Романова', 'Екатерина', 'Анатольевна');

INSERT INTO Menu (menu_name, weight, price) VALUES
('Филе порося', 350, 950),
('Суп мечты', 200, 750),
('Гарнир овощной', 250, 650),
('Мясная тарелка', 1200, 1670),
('Как бы здоровое питание', 1100, 1500),
('Картофель по-своему', 120, 120);

INSERT INTO Ingredient (ingredient_name) VALUES
('Свиная шейка'), ('Мясной маринад'), ('Лук'), ('Чеснок'), ('Собственный сок'),
('Говядина'), ('Вода (чистая)'), ('Морковь'), ('Капуста'), ('Приправы'),
('Помидоры черри'), ('Огурцы'), ('Сельдерей'), ('Листья салата'), ('Оливковое масло'),
('Куриные крылья'), ('Копчёные колбаски'), ('Вяленное мясо'),
('Яблоки'), ('Свежевыжатый сок'),
('Картофель'), ('Перец'), ('Соль');

INSERT INTO Composition (ingredient_id, menu_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
(11, 3), (12, 3), (13, 3), (14, 3), (15, 3),
(16, 4), (17, 4), (18, 4),
(19, 5), (8, 5), (13, 5), (20, 5),
(21, 6), (22, 6), (4, 6), (23, 6);

INSERT INTO Supplier (okpo, supplier_name, city, street, building) VALUES
('5981561046', 'ООО «Овощ тут»', 'Москва', 'ул. Тимерязевская', 'д.15, стр. 8'),
('8311967835', 'ООО «Мясной завод»', 'Москва', 'Нахимовский проспект', 'д. 45, к. 1');

INSERT INTO Estimate (estimate_number, ingredient_id, weight, okpo, formation_date) VALUES
(1, 11, 50, '5981561046', '2023-09-15'),
(1, 9, 45, '5981561046', '2023-09-15'),
(1, 19, 30, '5981561046', '2023-09-15'),
(2, 6, 150, '8311967835', '2023-09-16'),
(2, 16, 150, '8311967835', '2023-09-16');

INSERT INTO Statuses (`status`) VALUES ('Ожидается'), ('Выдан');

INSERT INTO Payment_Type (payment_type) VALUES ('Наличный'), ('Безналичный');

INSERT INTO `Check` (check_number, date_time, payment_type, amount_paid, total_amount, `change`) VALUES
(1, '2023-09-01 18:56:54', 1, 3500, 3468, 32),
(2, '2023-09-03 15:21:47', 2, 5484, 5484, 0),
(3, '2023-09-04 20:02:52', 1, 3000, 2700, 300);

INSERT INTO `Table` (zone_id, table_label, seat_count) VALUES
(1, 'ОБ1', 4), (1, 'ОБ2', 4), (1, 'ОБ3', 2), (1, 'ОБ4', 2),
(2, 'Д1', 5), (2, 'Д2', 5), (2, 'Д3', 5),
(3, 'Ч1', 4), (3, 'Ч2', 2);

INSERT INTO `Order` (order_number, check_number, employee, open_date_time, `table`, total_cost, `status`, visitor) VALUES
(1, 1, 'of_SemenovKN', '2023-09-01 14:00:24', 10, 2890, 2, '4510665764'),
(2, 2, 'of_DmitrievOI', '2023-09-01 16:17:37', 11, 1070, 1, '4515009426'),
(3, 3, 'of_AndreevAA', '2023-09-03 12:10:41', 12, 4570, 2, '4678239712');

INSERT INTO Dishes_in_Order (menu_item_id, order_number, quantity) VALUES
(1, 1, 2),
(2, 1, 1),
(6, 1, 2),
(6, 2, 1),
(1, 2, 1),
(3, 3, 2),
(1, 3, 1),
(3, 3, 1),
(4, 3, 1),
(2, 2, 3);

INSERT INTO Additional_Dish (menu_item_id, order_number, quantity, guest) VALUES
(1, 1, 2, '1234567890'),
(2, 1, 1, '1234567890'),
(6, 1, 2, '1234567890'),
(1, 3, 1, '0987654321'),
(4, 3, 1, '1122334455');

-- Проверка наличия данных в таблицах
SELECT * FROM Zone_Type;
SELECT * FROM `Table`;
SELECT * FROM Waiter;
SELECT * FROM Visitor;
SELECT * FROM Guest;
SELECT * FROM Menu;
SELECT * FROM Ingredient;
SELECT * FROM Composition;
SELECT * FROM Supplier;
SELECT * FROM Estimate;
SELECT * FROM Statuses;
SELECT * FROM Payment_Type;
SELECT * FROM `Order`;
SELECT * FROM Dishes_in_Order;
SELECT * FROM Additional_Dish;
SELECT * FROM `Check`;

DELIMITER //

CREATE PROCEDURE InsertZoneType(IN p_zone_type VARCHAR(50))
BEGIN
    INSERT INTO Zone_Type (zone_type) VALUES (p_zone_type);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateZoneType(IN p_zone_type_id INT, IN p_zone_type VARCHAR(50))
BEGIN
    UPDATE Zone_Type
    SET zone_type = p_zone_type
    WHERE zone_type_id = p_zone_type_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteZoneType(IN p_zone_type_id INT)
BEGIN
    DELETE FROM Zone_Type
    WHERE zone_type_id = p_zone_type_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertMenu(IN p_menu_name VARCHAR(100), IN p_weight DECIMAL(10,2), IN p_price DECIMAL(10,2))
BEGIN
    INSERT INTO Menu (menu_name, weight, price) VALUES (p_menu_name, p_weight, p_price);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateMenu(IN p_menu_id INT, IN p_menu_name VARCHAR(100), IN p_weight DECIMAL(10,2), IN p_price DECIMAL(10,2))
BEGIN
    UPDATE Menu
    SET menu_name = p_menu_name, weight = p_weight, price = p_price
    WHERE menu_id = p_menu_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteMenu(IN p_menu_id INT)
BEGIN
    DELETE FROM Menu
    WHERE menu_id = p_menu_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertIngredient(IN p_ingredient_name VARCHAR(100))
BEGIN
    INSERT INTO Ingredient (ingredient_name) VALUES (p_ingredient_name);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateIngredient(IN p_ingredient_id INT, IN p_ingredient_name VARCHAR(100))
BEGIN
    UPDATE Ingredient
    SET ingredient_name = p_ingredient_name
    WHERE ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteIngredient(IN p_ingredient_id INT)
BEGIN
    DELETE FROM Ingredient
    WHERE ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertSupplier(IN p_okpo VARCHAR(10), IN p_supplier_name VARCHAR(100), IN p_city VARCHAR(50), IN p_street VARCHAR(50), IN p_building VARCHAR(50))
BEGIN
    INSERT INTO Supplier (okpo, supplier_name, city, street, building) VALUES (p_okpo, p_supplier_name, p_city, p_street, p_building);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateSupplier(IN p_okpo VARCHAR(10), IN p_supplier_name VARCHAR(100), IN p_city VARCHAR(50), IN p_street VARCHAR(50), IN p_building VARCHAR(50))
BEGIN
    UPDATE Supplier
    SET supplier_name = p_supplier_name, city = p_city, street = p_street, building = p_building
    WHERE okpo = p_okpo;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteSupplier(IN p_okpo VARCHAR(10))
BEGIN
    DELETE FROM Supplier
    WHERE okpo = p_okpo;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertStatus(IN p_status VARCHAR(50))
BEGIN
    INSERT INTO Statuses (`status`) VALUES (p_status);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateStatus(IN p_status_id INT, IN p_status VARCHAR(50))
BEGIN
    UPDATE Statuses
    SET `status` = p_status
    WHERE status_id = p_status_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteStatus(IN p_status_id INT)
BEGIN
    DELETE FROM Statuses
    WHERE status_id = p_status_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertPaymentType(IN p_payment_type VARCHAR(50))
BEGIN
    INSERT INTO Payment_Type (payment_type) VALUES (p_payment_type);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdatePaymentType(IN p_payment_id INT, IN p_payment_type VARCHAR(50))
BEGIN
    UPDATE Payment_Type
    SET payment_type = p_payment_type
    WHERE payment_id = p_payment_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeletePaymentType(IN p_payment_id INT)
BEGIN
    DELETE FROM Payment_Type
    WHERE payment_id = p_payment_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertGuest(IN p_phone_number VARCHAR(15), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50))
BEGIN
    INSERT INTO Guest (phone_number, last_name, first_name, middle_name) VALUES (p_phone_number, p_last_name, p_first_name, p_middle_name);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateGuest(IN p_phone_number VARCHAR(15), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50))
BEGIN
    UPDATE Guest
    SET last_name = p_last_name, first_name = p_first_name, middle_name = p_middle_name
    WHERE phone_number = p_phone_number;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteGuest(IN p_phone_number VARCHAR(15))
BEGIN
    DELETE FROM Guest
    WHERE phone_number = p_phone_number;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertComposition(IN p_ingredient_id INT, IN p_menu_id INT)
BEGIN
    INSERT INTO Composition (ingredient_id, menu_id) VALUES (p_ingredient_id, p_menu_id);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateComposition(IN p_ingredient_id INT, IN p_menu_id INT, IN p_new_ingredient_id INT, IN p_new_menu_id INT)
BEGIN
    UPDATE Composition
    SET ingredient_id = p_new_ingredient_id, menu_id = p_new_menu_id
    WHERE ingredient_id = p_ingredient_id AND menu_id = p_menu_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteComposition(IN p_ingredient_id INT, IN p_menu_id INT)
BEGIN
    DELETE FROM Composition
    WHERE ingredient_id = p_ingredient_id AND menu_id = p_menu_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertEstimate(IN p_estimate_number INT, IN p_ingredient_id INT, IN p_weight DECIMAL(12,3), IN p_okpo CHAR(10), IN p_formation_date DATE)
BEGIN
    INSERT INTO Estimate (estimate_number, ingredient_id, weight, okpo, formation_date) VALUES (p_estimate_number, p_ingredient_id, p_weight, p_okpo, p_formation_date);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateEstimate(IN p_estimate_number INT, IN p_ingredient_id INT, IN p_weight DECIMAL(12,3), IN p_okpo CHAR(10), IN p_formation_date DATE)
BEGIN
    UPDATE Estimate
    SET weight = p_weight, okpo = p_okpo, formation_date = p_formation_date
    WHERE estimate_number = p_estimate_number AND ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteEstimate(IN p_estimate_number INT, IN p_ingredient_id INT)
BEGIN
    DELETE FROM Estimate
    WHERE estimate_number = p_estimate_number AND ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertTable(IN p_zone_id INT, IN p_table_label VARCHAR(50), IN p_seat_count INT)
BEGIN
    INSERT INTO `Table` (zone_id, table_label, seat_count) VALUES (p_zone_id, p_table_label, p_seat_count);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateTable(IN p_table_id INT, IN p_zone_id INT, IN p_table_label VARCHAR(50), IN p_seat_count INT)
BEGIN
    UPDATE `Table`
    SET zone_id = p_zone_id, table_label = p_table_label, seat_count = p_seat_count
    WHERE table_id = p_table_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteTable(IN p_table_id INT)
BEGIN
    DELETE FROM `Table`
    WHERE table_id = p_table_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertVisitor(IN p_passport VARCHAR(10), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_bank_card_number VARCHAR(16), IN p_login VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO Visitor (passport, last_name, first_name, middle_name, bank_card_number, login, `password`) VALUES (p_passport, p_last_name, p_first_name, p_middle_name, p_bank_card_number, p_login, p_password);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateVisitor(IN p_passport VARCHAR(10), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_bank_card_number VARCHAR(16), IN p_login VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    UPDATE Visitor
    SET last_name = p_last_name, first_name = p_first_name, middle_name = p_middle_name, bank_card_number = p_bank_card_number, login = p_login, `password` = p_password
    WHERE passport = p_passport;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteVisitor(IN p_passport VARCHAR(10))
BEGIN
    DELETE FROM Visitor
    WHERE passport = p_passport;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertWaiter(IN p_login VARCHAR(50), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO Waiter (login, last_name, first_name, middle_name, `password`) VALUES (p_login, p_last_name, p_first_name, p_middle_name, p_password);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateWaiter(IN p_login VARCHAR(50), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    UPDATE Waiter
    SET last_name = p_last_name, first_name = p_first_name, middle_name = p_middle_name, `password` = p_password
    WHERE login = p_login;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteWaiter(IN p_login VARCHAR(50))
BEGIN
    DELETE FROM Waiter
    WHERE login = p_login;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertCheck(IN p_date_time DATETIME, IN p_payment_type INT, IN p_amount_paid DECIMAL(10,2), IN p_total_amount DECIMAL(10,2), IN p_change DECIMAL(10,2))
BEGIN
    INSERT INTO `Check` (date_time, payment_type, amount_paid, total_amount, `change`) VALUES (p_date_time, p_payment_type, p_amount_paid, p_total_amount, p_change);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateCheck(IN p_check_number INT, IN p_date_time DATETIME, IN p_payment_type INT, IN p_amount_paid DECIMAL(10,2), IN p_total_amount DECIMAL(10,2), IN p_change DECIMAL(10,2))
BEGIN
    UPDATE `Check`
    SET date_time = p_date_time, payment_type = p_payment_type, amount_paid = p_amount_paid, total_amount = p_total_amount, `change` = p_change
    WHERE check_number = p_check_number;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteCheck(IN p_check_number INT)
BEGIN
    DELETE FROM `Check`
    WHERE check_number = p_check_number;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertOrder(IN p_check_number INT, IN p_employee VARCHAR(50), IN p_open_date_time DATETIME, IN p_table INT, IN p_total_cost DECIMAL(10,2), IN p_status INT, IN p_visitor VARCHAR(10))
BEGIN
    INSERT INTO `Order` (check_number, employee, open_date_time, `table`, total_cost, `status`, visitor) VALUES (p_check_number, p_employee, p_open_date_time, p_table, p_total_cost, p_status, p_visitor);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateOrder(IN p_order_number INT, IN p_check_number INT, IN p_employee VARCHAR(50), IN p_open_date_time DATETIME, IN p_table INT, IN p_total_cost DECIMAL(10,2), IN p_status INT, IN p_visitor VARCHAR(10))
BEGIN
    UPDATE `Order`
    SET check_number = p_check_number, employee = p_employee, open_date_time = p_open_date_time, `table` = p_table, total_cost = p_total_cost, `status` = p_status, visitor = p_visitor
    WHERE order_number = p_order_number;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteOrder(IN p_order_number INT)
BEGIN
    DELETE FROM `Order`
    WHERE order_number = p_order_number;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertDishesInOrder(IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT)
BEGIN
    INSERT INTO Dishes_in_Order (menu_item_id, order_number, quantity) VALUES (p_menu_item_id, p_order_number, p_quantity);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateDishesInOrder(IN p_id INT, IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT)
BEGIN
    UPDATE Dishes_in_Order
    SET menu_item_id = p_menu_item_id, order_number = p_order_number, quantity = p_quantity
    WHERE id = p_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteDishesInOrder(IN p_id INT)
BEGIN
    DELETE FROM Dishes_in_Order
    WHERE id = p_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertAdditionalDish(IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT, IN p_guest VARCHAR(15))
BEGIN
    INSERT INTO Additional_Dish (menu_item_id, order_number, quantity, guest) VALUES (p_menu_item_id, p_order_number, p_quantity, p_guest);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateAdditionalDish(IN p_id INT, IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT, IN p_guest VARCHAR(15))
BEGIN
    UPDATE Additional_Dish
    SET menu_item_id = p_menu_item_id, order_number = p_order_number, quantity = p_quantity, guest = p_guest
    WHERE id = p_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteAdditionalDish(IN p_id INT)
BEGIN
    DELETE FROM Additional_Dish
    WHERE id = p_id;
END //

DELIMITER ;


GRANT EXECUTE ON AleynikovAD_db1.* TO 'rl_administrator'@'127.0.0.1';

GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertVisitor TO 'rl_visitor'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateVisitor TO 'rl_visitor'@'127.0.0.1';

GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertOrder TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateOrder TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertDishesInOrder TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateDishesInOrder TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertCheck TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateCheck TO 'rl_waiter'@'127.0.0.1';


