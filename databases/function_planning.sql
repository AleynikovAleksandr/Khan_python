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