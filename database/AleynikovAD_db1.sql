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


INSERT INTO Zone_Type (zone_type) VALUES ('Общая зона'), ('Детская зона'), ('Частная зона');

INSERT INTO `Table` (zone_id, table_label, seat_count) VALUES
(1, 'ОБ1', 4), (1, 'ОБ2', 4), (1, 'ОБ3', 2), (1, 'ОБ4', 2),
(2, 'Д1', 5), (2, 'Д2', 5), (2, 'Д3', 5),
(3, 'Ч1', 4), (3, 'Ч2', 2);

INSERT INTO Waiter (login, last_name, first_name, middle_name, `password`) VALUES
('of_SemenovKN', 'Семёнов', 'Кирилл', 'Николаевич', 'Pa$$w0rd'),
('of_AndreevAA', 'Андреев', 'Андрей', 'Андреевич', 'Pa$$w0rd'),
('of_DmitrievOI', 'Дмитриев', 'Олег', 'Иванович', 'Pa$$w0rd');

INSERT INTO Visitor (passport, last_name, first_name, middle_name, bank_card_number, login, `password`) VALUES
('45 10 665764', 'Иванов', 'Иван', 'Иванович', '4825 7731 7788 1752', 'IvanovII', 'Pa$$w0rd'),
('46 78 239712', 'Петров', 'Алексей', 'Алексеевич', '5652 1147 9921', 'PetrovAA', 'Pa$$w0rd'),
('45 15 009426', 'Павлов', 'Евгений', 'Геннадьевич', '3134 7742 5677', 'PavlovEG', 'Pa$$w0rd');

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

INSERT INTO `Order` (order_number, check_number, employee, open_date_time, `table`, total_cost, `status`, visitor) VALUES
(1, 1, 'of_SemenovKN', '2023-09-01 14:00:24', 3, 2890, 2, '45 10 665764'),
(2, 2, 'of_DmitrievOI', '2023-09-01 16:17:37', 1, 1070, 1, '45 15 009426'),
(3, 3, 'of_AndreevAA', '2023-09-03 12:10:41', 7, 4570, 2, '45 10 665764'),
(4, 4, 'of_SemenovKN', '2023-09-04 16:35:01', 2, 2250, 2, '45 10 665764');

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
(2, 4, 3);

INSERT INTO Additional_Dish (menu_item_id, order_number, quantity, guest) VALUES
(1, 1, 2, '1234567890'),
(2, 1, 1, '1234567890'),
(6, 1, 2, '1234567890'),
(1, 3, 1, '0987654321'),
(4, 3, 1, '1122334455');

INSERT INTO `Check` (check_number, date_time, payment_type, amount_paid, total_amount, `change`) VALUES
(1, '2023-09-01 18:56:54', 1, 3500, 3468, 32),
(2, '2023-09-03 15:21:47', 2, 5484, 5484, 0),
(3, '2023-09-04 20:02:52', 1, 3000, 2700, 300);