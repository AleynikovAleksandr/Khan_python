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
    login VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL
);

CREATE TABLE Waiter (
    login VARCHAR(50) PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL,
    `password` VARCHAR(255) NOT NULL
);

CREATE TABLE Reservation_Statuses (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_status VARCHAR(50) NOT NULL
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

CREATE TABLE Reservation_Order (
    reservation_id VARCHAR(50) PRIMARY KEY, 
    client_login VARCHAR(50) NOT NULL, 
    creation_date DATETIME NOT NULL, 
    visit_date DATE NOT NULL, 
    visit_time TIME NOT NULL, 
    guest_count INT NOT NULL, 
    status_id INT NOT NULL, 
    FOREIGN KEY (client_login) REFERENCES Visitor(login) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Reservation_Statuses(status_id) ON DELETE CASCADE ON UPDATE CASCADE
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

CREATE TABLE Reservation_Tables (
    reservation_id VARCHAR(50) NOT NULL, 
    table_id INT NOT NULL, 
    PRIMARY KEY (reservation_id, table_id), 
    FOREIGN KEY (reservation_id) REFERENCES Reservation_Order(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (table_id) REFERENCES `Table`(table_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reservation_Menu (
    reservation_menu_id INT PRIMARY KEY AUTO_INCREMENT, 
    reservation_id VARCHAR(50) NOT NULL, 
    menu_item_id INT NOT NULL, 
    serving_time TIME NOT NULL, 
    quantity INT NOT NULL, 
    FOREIGN KEY (reservation_id) REFERENCES Reservation_Order(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES Menu(menu_id) ON DELETE CASCADE ON UPDATE CASCADE
);

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

INSERT INTO Zone_Type (zone_type) VALUES ('Общая зона'), ('Детская зона'), ('Частная зона');

INSERT INTO Waiter (login, last_name, first_name, middle_name, `password`) VALUES
('of_SemenovKN', 'Семёнов', 'Кирилл', 'Николаевич', 'Pa$$w0rd'),
('of_AndreevAA', 'Андреев', 'Андрей', 'Андреевич', 'Pa$$w0rd'),
('of_DmitrievOI', 'Дмитриев', 'Олег', 'Иванович', 'Pa$$w0rd');


INSERT INTO Visitor (passport, last_name, first_name, middle_name, bank_card_number, login, `password`) VALUES
('4510665764', 'Иванов', 'Иван', 'Иванович', '4825773177881752', 'IvanovII', 'Pa$$w0rd'),
('4678239712', 'Петров', 'Алексей', 'Алексеевич', '565211479921', 'PetrovAA', 'Pa$$w0rd'),
('4515009426', 'Павлов', 'Евгений', 'Геннадьевич', '313477425677', 'PavlovEG', 'Pa$$w0rd');

INSERT INTO Reservation_Statuses (reservation_status) VALUES 
('Активна'), 
('Отменена'), 
('Завершена'); 

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

INSERT INTO Reservation_Order (reservation_id, client_login, creation_date, visit_date, visit_time, guest_count, status_id)
VALUES
    ('БР/24/0000000001', 'IvanovII', '2024-01-01 16:01:10', '2024-02-02', '12:00:00', 2, 1), 
    ('БР/24/0000000002', 'PetrovAA', '2024-01-20 09:50:21', '2024-02-19', '16:30:00', 8, 1), 
    ('БР/24/0000000003', 'IvanovII', '2024-01-20 17:09:25', '2024-02-10', '12:45:00', 1, 1), 
    ('БР/24/0000000004', 'PetrovAA', '2024-02-02 18:00:35', '2024-02-06', '17:20:00', 2, 1), 
    ('БР/24/0000000005', 'PetrovAA', '2024-02-10 15:43:59', '2024-02-11', '13:00:00', 4, 1); 

INSERT INTO `Table` (zone_id, table_label, seat_count) VALUES
(1, 'ОБ1', 4), (1, 'ОБ2', 4), (1, 'ОБ3', 2), (1, 'ОБ4', 2),
(2, 'Д1', 5), (2, 'Д2', 5), (2, 'Д3', 5),
(3, 'Ч1', 4), (3, 'Ч2', 2);

INSERT INTO `Order` (order_number, check_number, employee, open_date_time, `table`, total_cost, `status`, visitor) VALUES
(1, 1, 'of_SemenovKN', '2023-09-01 14:00:24', 3, 2890, 2, '4510665764'),
(2, 2, 'of_DmitrievOI', '2023-09-01 16:17:37', 1, 1070, 1, '4515009426'),
(3, 3, 'of_AndreevAA', '2023-09-03 12:10:41', 8, 4570, 2, '4678239712');

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

INSERT INTO Reservation_Tables (reservation_id, table_id) VALUES
('БР/24/0000000001', 9), 
('БР/24/0000000002', 1), 
('БР/24/0000000002', 2), 
('БР/24/0000000003', 3), 
('БР/24/0000000004', 4), 
('БР/24/0000000005', 8); 

INSERT INTO Reservation_Menu (reservation_id, menu_item_id, quantity, serving_time) VALUES
('БР/24/0000000001', 1, 4, '12:00:00'), 
('БР/24/0000000001', 4, 2, '13:00:00'), 
('БР/24/0000000002', 5, 3, '16:30:00'), 
('БР/24/0000000002', 6, 5, '17:00:00'), 
('БР/24/0000000003', 6, 1, '12:45:00'), 
('БР/24/0000000003', 3, 2, '12:45:00'), 
('БР/24/0000000004', 2, 2, '17:40:00'), 
('БР/24/0000000005', 1, 2, '13:00:00'), 
('БР/24/0000000005', 4, 2, '14:00:00'); 

SELECT * FROM Zone_Type;
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
SELECT * FROM `Check`;
SELECT * FROM `Table`;
SELECT * FROM `Order`;
SELECT * FROM Dishes_in_Order;
SELECT * FROM Additional_Dish;
SELECT * FROM Reservation_Statuses;
SELECT * FROM Reservation_Order;
SELECT * FROM Reservation_Tables;
SELECT * FROM Reservation_Menu;

    select 
    t.table_name as "Название таблиц",
    group_concat(r.routine_name) as "Список процедур",
    t.table_rows as "Кол-во записей в таблицах"
from 
    information_schema.tables t
    left join information_schema.routines r
        on t.table_name = substring(r.routine_name, 7, length(t.table_name))
        and r.routine_type = 'PROCEDURE'
        and r.routine_schema = 'AleynikovAD_db1'
where 
    t.table_schema = 'AleynikovAD_db1'
group by 
    t.table_name, t.table_rows

union all

select 
    'Количество процедур', 
    count(r.routine_name),
    (select 
        sum(t.table_rows) 
    from information_schema.tables t
    where 
        t.table_schema = 'AleynikovAD_db1')
from information_schema.routines r
where
    r.routine_type = 'PROCEDURE' 
    and r.routine_name not in ('structure_create','structure_re_create') 
    and r.routine_schema = 'AleynikovAD_db1';
    
DROP PROCEDURE IF EXISTS Check_Existing_Table;

DELIMITER $$

CREATE PROCEDURE Check_Existing_Table (
    IN p_table_label VARCHAR(50)  
)
BEGIN
    DECLARE v_table_exists INT;  

    SELECT COUNT(*) INTO v_table_exists 
    FROM `Table` 
    WHERE table_label = p_table_label;

    IF v_table_exists > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Указанный стол уже есть в таблице!';
    END IF;
END $$

DELIMITER ;

CALL Check_Existing_Table('ОБ1');

DROP PROCEDURE IF EXISTS InsertReservation_Order;
DELIMITER $$

CREATE PROCEDURE InsertReservation_Order (
    IN p_client_login VARCHAR(50),
    IN p_creation_date DATETIME,
    IN p_visit_date DATE,
    IN p_visit_time TIME,
    IN p_guest_count INT,
    IN p_status_id INT
)
BEGIN
    DECLARE year_part CHAR(2);
    DECLARE sequence_part CHAR(10);
    DECLARE max_sequence INT;
    DECLARE new_reservation_id VARCHAR(50);

    -- Извлечение последних двух цифр года
    SET year_part = DATE_FORMAT(p_creation_date, '%y');

    -- Получение текущего максимального значения последовательности для данного года
    SELECT IFNULL(MAX(CAST(SUBSTRING_INDEX(reservation_id, '/', -1) AS UNSIGNED)), 0) + 1 INTO max_sequence
    FROM Reservation_Order
    WHERE SUBSTRING_INDEX(reservation_id, '/', 2) = CONCAT('БР/', year_part);

    -- Формирование части последовательности с ведущими нулями
    SET sequence_part = LPAD(max_sequence, 10, '0');

    -- Формирование полного ID бронирования
    SET new_reservation_id = CONCAT('БР/', year_part, '/', sequence_part);

    -- Вставка новой записи в таблицу Reservation_Order
    INSERT INTO Reservation_Order (reservation_id, client_login, creation_date, visit_date, visit_time, guest_count, status_id)
    VALUES (new_reservation_id, p_client_login, p_creation_date, p_visit_date, p_visit_time, p_guest_count, p_status_id);
END $$

DELIMITER ;

CALL InsertReservation_Order('IvanovII', '2024-03-01 10:10:10', '2024-03-02', '11:11:00', 1, 1);
    
DROP PROCEDURE IF EXISTS DeleteIngredient;

DELIMITER //

CREATE PROCEDURE DeleteIngredient(IN ingredientID INT)
BEGIN
DECLARE ingredientCount INT DEFAULT 0;
	-- Проверяем, существует ли ингредиент
	SELECT COUNT(*) INTO ingredientCount FROM Ingredient WHERE ingredient_id = ingredientID;
	IF ingredientCount = 0 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Такого ингредиента не существует.';
END IF;
	-- Проверяем, используется ли ингредиент в блюдах
	SELECT COUNT(*) INTO ingredientCount
	FROM Composition
	WHERE ingredient_id = ingredientID;
	IF ingredientCount > 0 THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Выбранный ингредиент невозможно удалить, так как он используется в одном или нескольких блюдах.';
ELSE
	-- Если не связан, удаляем
	DELETE FROM Ingredient WHERE ingredient_id = ingredientID;
	SELECT CONCAT('Ингредиент с ID ', ingredientID, ' успешно удален.') AS Message;
	END IF;
END //

DELIMITER ;


CALL DeleteIngredient(1);

DROP PROCEDURE IF EXISTS Check_Existing_Ingredient;

DELIMITER $$

CREATE PROCEDURE Check_Existing_Ingredient (
    IN p_menu_name VARCHAR(100), 
    IN p_ingredient_name VARCHAR(100)
)
BEGIN
    DECLARE v_menu_id INT;
    DECLARE v_ingredient_id INT;
    DECLARE p_Exist_Combination SMALLINT;

    -- Проверка существования блюда и получение его ID
    SELECT menu_id INTO v_menu_id FROM Menu WHERE menu_name = p_menu_name;
    IF v_menu_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Указанное блюдо не существует!';
    END IF;

    -- Проверка существования ингредиента и получение его ID
    SELECT ingredient_id INTO v_ingredient_id FROM Ingredient WHERE ingredient_name = p_ingredient_name;
    IF v_ingredient_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Указанный ингредиент не существует!';
    END IF;

    -- Проверка существования комбинации
    SELECT COUNT(*) INTO p_Exist_Combination 
    FROM Composition 
    WHERE menu_id = v_menu_id AND ingredient_id = v_ingredient_id;

    -- Обработка результата
    IF p_Exist_Combination > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Указанный ингредиент уже есть у указанного блюда!';
    ELSE
        SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Ингредиент отсутствует в блюде';
    END IF;
END $$

DELIMITER ;
CALL Check_Existing_Ingredient('Мясная тарелка', 'Куриные крылья');


DROP PROCEDURE IF EXISTS Recalculate_Order_Total;

DELIMITER $$

CREATE PROCEDURE Recalculate_Order_Total (
    IN p_order_number INT,          
    IN p_menu_item_id INT,          
    IN p_quantity INT               
)
BEGIN
    DECLARE v_menu_price DECIMAL(10,2);  
    DECLARE v_total_cost DECIMAL(10,2);  
    DECLARE v_order_exists INT;          
    DECLARE v_menu_exists INT;           

    -- Проверка существования заказа
    SELECT COUNT(*) INTO v_order_exists 
    FROM `Order` 
    WHERE order_number = p_order_number;

    IF v_order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Указанный заказ не существует!';
    END IF;

    -- Проверка существования блюда
    SELECT COUNT(*) INTO v_menu_exists 
    FROM Menu 
    WHERE menu_id = p_menu_item_id;

    IF v_menu_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Указанное блюдо не существует!';
    END IF;

    -- Получение цены блюда
    SELECT price INTO v_menu_price 
    FROM Menu 
    WHERE menu_id = p_menu_item_id;

    -- Добавление новой позиции в заказ
    INSERT INTO Dishes_in_Order (menu_item_id, order_number, quantity)
    VALUES (p_menu_item_id, p_order_number, p_quantity);

    -- Пересчет общей стоимости заказа
    SELECT SUM(m.price * dio.quantity) INTO v_total_cost
    FROM Dishes_in_Order dio
    JOIN Menu m ON dio.menu_item_id = m.menu_id
    WHERE dio.order_number = p_order_number;

    -- Обновление общей стоимости заказа
    UPDATE `Order`
    SET total_cost = v_total_cost
    WHERE order_number = p_order_number;

    -- Возврат новой общей стоимости
    SELECT v_total_cost AS 'Новая общая стоимость заказа';
END $$

DELIMITER ;

CALL Recalculate_Order_Total(1, 5, 1);  


SELECT 
    o.order_number AS "Номер заказа",
    o.open_date_time AS "Дата создания заказа",
    t.table_label AS "Номер стола",
    CONCAT(w.last_name, ' ', w.first_name, ' ', COALESCE(w.middle_name, '')) AS "ФИО сотрудника"
FROM 
    `Order` o
    INNER JOIN `Table` t ON o.`table` = t.table_id
    INNER JOIN Waiter w ON o.employee = w.login
WHERE 
    w.login = 'of_SemenovKN';
    
    
    SELECT 
    o.order_number AS 'Номер заказа',
    m.menu_name AS 'Название блюда',
    dio.quantity AS 'Количество'
FROM 
    Dishes_in_Order dio
    JOIN `Order` o ON dio.order_number = o.order_number
    JOIN Menu m ON dio.menu_item_id = m.menu_id
WHERE 
    dio.quantity < 3
ORDER BY 
    o.order_number, m.menu_name;
    
    
    SELECT 
    CONCAT(last_name, ' ', first_name, ' ', IFNULL(middle_name, '')) AS 'ФИО клиента',
    login AS 'Логин',
    password AS 'Пароль'
FROM 
    Visitor
WHERE 
    passport LIKE '45%';
    
    SELECT 
    m.menu_name AS 'Название блюда',
    m.price AS 'Цена',
    GROUP_CONCAT(DISTINCT i2.ingredient_name SEPARATOR ', ') AS 'Ингредиенты'
FROM 
    Menu m
    JOIN Composition c ON m.menu_id = c.menu_id
    JOIN Ingredient i ON c.ingredient_id = i.ingredient_id
    JOIN Composition c2 ON m.menu_id = c2.menu_id
    JOIN Ingredient i2 ON c2.ingredient_id = i2.ingredient_id
WHERE 
    i.ingredient_name IN ('Лук', 'Перец', 'Морковь')
GROUP BY 
    m.menu_id, m.menu_name, m.price
HAVING 
    SUM(i.ingredient_name = 'Лук') > 0
    AND SUM(i.ingredient_name = 'Перец') > 0
    AND SUM(i.ingredient_name = 'Морковь') > 0;
    
    SELECT 
    menu_name AS 'Название блюда',
    weight AS 'Вес (гр)',
    price AS 'Цена (руб)'
FROM 
    Menu
WHERE 
    weight BETWEEN 100 AND 500
ORDER BY 
    weight;
    
   SELECT 
    o.order_number AS 'Номер заказа',
    CONCAT(w.last_name, ' ', w.first_name, ' ', COALESCE(w.middle_name, '')) AS 'ФИО сотрудника',
    m.menu_name AS 'Название блюда',
    dio.quantity AS 'Количество'
FROM 
    `Order` o
    JOIN `Check` ch ON o.check_number = ch.check_number
    JOIN Waiter w ON o.employee = w.login
    JOIN Dishes_in_Order dio ON o.order_number = dio.order_number
    JOIN Menu m ON dio.menu_item_id = m.menu_id
WHERE 
    ch.change != 0
    AND dio.quantity > 1
    AND o.employee = 'of_SemenovKN'
ORDER BY 
    o.order_number; 
    
 SELECT 
    m.menu_name AS 'Название блюда',
    GROUP_CONCAT(i.ingredient_name SEPARATOR ', ') AS 'Ингредиенты',
    m.weight AS 'Вес (гр)',
    m.price AS 'Цена (руб)'
FROM 
    Menu m
    JOIN Composition c ON m.menu_id = c.menu_id
    JOIN Ingredient i ON c.ingredient_id = i.ingredient_id
WHERE 
    m.menu_id NOT IN (
        SELECT c2.menu_id
        FROM Composition c2
        JOIN Ingredient i2 ON c2.ingredient_id = i2.ingredient_id
        WHERE i2.ingredient_name = 'Морковь'
    )
GROUP BY 
    m.menu_id, m.menu_name, m.weight, m.price;   
    
    SELECT 
    e.estimate_number AS 'Номер сметы',
    s.supplier_name AS 'Поставщик',
    i.ingredient_name AS 'Ингредиент',
    e.weight AS 'Вес (кг)'
FROM 
    Estimate e
    JOIN Supplier s ON e.okpo = s.okpo
    JOIN Ingredient i ON e.ingredient_id = i.ingredient_id
WHERE 
    e.weight >= 50
ORDER BY 
    e.estimate_number, i.ingredient_name;
    
    SELECT 
    CONCAT(last_name, ' ', first_name, ' ', IFNULL(middle_name, '')) AS 'ФИО клиента',
    bank_card_number AS 'Номер банковской карты'
FROM 
    Visitor
WHERE 
    bank_card_number NOT LIKE '%77%';
    
    
    SELECT 
    o.order_number AS 'Номер заказа',
    CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'ФИО клиента',
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'ФИО сотрудника',
    t.table_label AS 'Номер стола'
FROM 
    `Order` o
    JOIN Visitor v ON o.visitor = v.passport
    JOIN Waiter w ON o.employee = w.login
    JOIN `Table` t ON o.`table` = t.table_id
WHERE 
    t.table_label NOT IN ('ОБ3', 'ОБ4', 'ОБ5', 'Ч1')
ORDER BY 
    o.order_number;
   
   SELECT 
    ro.reservation_id AS 'Номер бронирования',
    CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'ФИО клиента',
    ro.visit_date AS 'Дата посещения',
    ro.guest_count AS 'Количество гостей'
FROM 
    Reservation_Order ro
    JOIN Visitor v ON ro.client_login = v.login
WHERE 
    NOT (ro.guest_count BETWEEN 2 AND 5)
ORDER BY 
    ro.visit_date, ro.reservation_id;
    
SELECT 
    m.menu_name AS 'Название блюда',
    GROUP_CONCAT(i.ingredient_name SEPARATOR ', ') AS 'Ингредиенты',
    m.weight AS 'Вес (гр)',
    CASE 
        WHEN m.weight BETWEEN 0 AND 250 THEN 'Лёгкое блюдо'
        WHEN m.weight BETWEEN 251 AND 750 THEN 'Средней тяжести'
        WHEN m.weight > 750 THEN 'Тяжёлое'
    END AS 'Категория веса'
FROM 
    Menu m
    JOIN Composition c ON m.menu_id = c.menu_id
    JOIN Ingredient i ON c.ingredient_id = i.ingredient_id
GROUP BY 
    m.menu_id, m.menu_name, m.weight
ORDER BY 
    m.weight;