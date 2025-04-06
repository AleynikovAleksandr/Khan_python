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