-- Задание 1: Вывод информации о блюдах (название, цена, вес, кол-во ингредиентов)
DROP FUNCTION IF EXISTS GetDishInfo;

DELIMITER $$

CREATE FUNCTION GetDishInfo(p_menu_id INT) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    
    SELECT CONCAT(
        'Название: ', m.menu_name, 
        ' | Цена: ', m.price, ' руб.', 
        ' | Вес: ', m.weight, ' гр.', 
        ' | Ингредиентов: ', 
        (SELECT COUNT(*) FROM Composition WHERE menu_id = p_menu_id)
    ) INTO result
    FROM Menu m
    WHERE m.menu_id = p_menu_id;
    
    RETURN IFNULL(result, 'Блюдо не найдено');
END $$

DELIMITER ;

SELECT GetDishInfo(1) AS 'Информация о блюде';

-- Задание 2: Вывод ФИО клиентов и средней стоимости заказов
DELIMITER //

CREATE FUNCTION GetClientOrderAverages() 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    
    -- Используем подзапрос для корректной обработки GROUP_CONCAT с агрегатными функциями
    SELECT GROUP_CONCAT(
        CONCAT(client_info, ' | Средний чек: ', avg_cost, ' руб.')
        SEPARATOR '\n'
    ) INTO result
    FROM (
        SELECT 
            CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS client_info,
            ROUND(AVG(o.total_cost), 2) AS avg_cost
        FROM 
            `Order` o
        JOIN 
            Visitor v ON o.visitor = v.passport
        GROUP BY 
            v.passport
    ) AS client_stats;
    
    RETURN IFNULL(result, 'Нет данных о клиентах');
END //

DELIMITER ;

-- Вызов функции
SELECT GetClientOrderAverages() AS 'Средние чеки клиентов';

-- Задание 3: Функция для вывода ФИО сотрудников, клиентов и номеров заказов 

DELIMITER //

CREATE FUNCTION GetOrderDetails() 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    
    SELECT 
        GROUP_CONCAT(
            CONCAT(
                'Сотрудник: ', 
                (SELECT CONCAT(last_name, ' ', first_name, ' ', IFNULL(middle_name, '')) 
                 FROM Waiter WHERE login = o.employee),
                ' | Клиент: ',
                (SELECT CONCAT(last_name, ' ', first_name, ' ', IFNULL(middle_name, '')) 
                 FROM Visitor WHERE passport = o.visitor),
                ' | Заказ №', o.order_number
            )
            SEPARATOR '\n'
        ) INTO result
    FROM 
        `Order` o;
    
    RETURN IFNULL(result, 'Нет данных о заказах');
END //

DELIMITER ;

-- Вызов функции
SELECT GetOrderDetails() AS 'Детали заказов';

-- Задание 4: Функция для вывода информации о блюдах с количеством символов
DELIMITER //

CREATE FUNCTION GetDishInfoById(p_menu_id INT) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE dish_name VARCHAR(100);
    DECLARE dish_weight DECIMAL(10,2);
    DECLARE dish_price DECIMAL(10,2);
    DECLARE char_count INT;
    
    -- Получаем данные о блюде
    SELECT 
        menu_name, 
        weight, 
        price,
        CHAR_LENGTH(menu_name)
    INTO 
        dish_name, dish_weight, dish_price, char_count
    FROM 
        Menu
    WHERE 
        menu_id = p_menu_id;
    
    -- Формируем результат
    IF dish_name IS NOT NULL THEN
        SET result = CONCAT(
            'Название: ', dish_name, '\n',
            'Вес: ', dish_weight, ' гр.\n',
            'Цена: ', dish_price, ' руб.\n',
            'Символов в названии: ', char_count
        );
    ELSE
        SET result = 'Блюдо с указанным ID не найдено';
    END IF;
    
    RETURN result;
END //

DELIMITER ;

SELECT GetDishInfoById(6) AS 'Информация о блюде';

-- Задание 5:
DROP FUNCTION IF EXISTS GetDishNamesUpperCase;
DELIMITER //

CREATE FUNCTION GetDishNamesUpperCase(p_menu_id INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result VARCHAR(100) DEFAULT '';
    
    -- Получаем название блюда в верхнем регистре
    SELECT 
        UPPER(menu_name)
    INTO 
        result
    FROM 
        Menu
    WHERE 
        menu_id = p_menu_id;
    
    RETURN IFNULL(result, 'Блюдо не найдено');
END //

DELIMITER ;

SELECT GetDishNamesUpperCase(1) AS 'Название блюда';

-- Задание 6: Функция для вывода всех бронирований с датами 
DROP FUNCTION IF EXISTS GetReservationDetails;
DELIMITER //

CREATE FUNCTION GetReservationDetails(p_reservation_id VARCHAR(50)) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE res_date DATE;
    
    -- Получаем дату бронирования
    SELECT 
        visit_date
    INTO 
        res_date
    FROM 
        Reservation_Order
    WHERE 
        reservation_id = p_reservation_id;
    
    -- Формируем результат для одной записи
    IF res_date IS NOT NULL THEN
        SET result = CONCAT(
            'Бронирование: ', p_reservation_id, 
            ' | Дата: ', DATE_FORMAT(res_date, 'Год:%Y Месяц:%m День:%d')
        );
    ELSE
        SET result = CONCAT('Бронирование ', p_reservation_id, ' не найдено');
    END IF;
    
    RETURN result;
END //

DELIMITER ;

SELECT GetReservationDetails('БР/24/0000000005') AS 'Детали бронирования';

-- Задание 7: функция, которая выводит информацию о бронировании с расчетом даты отмены 

DELIMITER //

CREATE FUNCTION GetReservationWithCancelDate(p_reservation_id VARCHAR(50)) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE visit_dt DATE;
    DECLARE cancel_dt DATE;
    
    -- Получаем дату посещения
    SELECT visit_date
    INTO visit_dt
    FROM Reservation_Order
    WHERE reservation_id = p_reservation_id;
    
    -- Формируем результат
    IF visit_dt IS NOT NULL THEN
        -- Рассчитываем дату отмены (дата посещения + 21 день)
        SET cancel_dt = DATE_ADD(visit_dt, INTERVAL 21 DAY);
        
        SET result = CONCAT(
            'Номер бронирования: ', p_reservation_id, '\n',
            'Планируемая дата посещения: ', DATE_FORMAT(visit_dt, '%Y-%m-%d'), '\n',
            'Дата отмены брони (+21 день): ', DATE_FORMAT(cancel_dt, '%Y-%m-%d')
        );
    ELSE
        SET result = CONCAT('Бронирование ', p_reservation_id, ' не найдено');
    END IF;
    
    RETURN result;
END //

DELIMITER ;

SELECT GetReservationWithCancelDate('БР/24/0000000001') AS 'Информация о бронировании';

-- Задание 8: Функция для вывода самого дорогого блюда

DELIMITER //

CREATE FUNCTION GetMostExpensiveDish() 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE dish_name VARCHAR(100);
    DECLARE dish_price DECIMAL(10,2);
    
    -- Получаем самое дорогое блюдо
    SELECT 
        menu_name, 
        price
    INTO 
        dish_name, dish_price
    FROM 
        Menu
    ORDER BY 
        price DESC
    LIMIT 1;
    
    -- Формируем результат
    IF dish_name IS NOT NULL THEN
        SET result = CONCAT(
            'Самое дорогое блюдо: "', dish_name, '"\n',
            'Цена: ', dish_price, ' руб.'
        );
    ELSE
        SET result = 'Нет данных о блюдах';
    END IF;
    
    RETURN result;
END //

DELIMITER ;

SELECT GetMostExpensiveDish() AS 'Премиальное блюдо';

-- Задание 9: Функция для вывода информации о заказе с нумерованным списком блюд
DROP FUNCTION IF EXISTS GetOrderDetails;

DELIMITER //

CREATE FUNCTION GetOrderDetails(p_order_number INT) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE waiter_name VARCHAR(150);
    DECLARE dish_list TEXT DEFAULT '';
    DECLARE num INT DEFAULT 0;
    
    -- Получаем ФИО сотрудника
    SELECT CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, ''))
    INTO waiter_name
    FROM `Order` o
    JOIN Waiter w ON o.employee = w.login
    WHERE o.order_number = p_order_number;
    
    -- Если заказ не найден
    IF waiter_name IS NULL THEN
        RETURN CONCAT('Заказ №', p_order_number, ' не найден');
    END IF;
    
    -- Формируем нумерованный список блюд
    SELECT GROUP_CONCAT(
        CONCAT(@num := @num + 1, '. ', menu_name) SEPARATOR '\n'
    ) INTO dish_list
    FROM (
        SELECT m.menu_name
        FROM Dishes_in_Order dio
        JOIN Menu m ON dio.menu_item_id = m.menu_id
        WHERE dio.order_number = p_order_number
        ORDER BY m.menu_name
    ) AS ordered_dishes, (SELECT @num := 0) AS init;
    
    -- Формируем итоговый результат
    SET result = CONCAT(
        'Сотрудник: ', waiter_name, '\n',
        'Номер заказа: ', p_order_number, '\n',
        'Состав заказа:\n', IFNULL(dish_list, 'Нет блюд в заказе')
    );
    
    RETURN result;
END //

DELIMITER ;

SELECT GetOrderDetails(1) AS 'Детали заказа';