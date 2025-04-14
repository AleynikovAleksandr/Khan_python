DELIMITER //

CREATE FUNCTION AuthenticateUser(
    p_login VARCHAR(50),
    p_password VARCHAR(255))
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_result VARCHAR(100);
    DECLARE v_full_name VARCHAR(100);
    
    -- Проверка сотрудников
    SELECT CONCAT(last_name, ' ', first_name, ' ', IFNULL(middle_name, '')) 
    INTO v_full_name
    FROM Waiter
    WHERE login = p_login AND password = p_password;
    
    IF v_full_name IS NOT NULL THEN
        SET v_result = CONCAT(v_full_name, ', Официант');
        RETURN v_result;
    END IF;
    
    -- Проверка посетителей
    SELECT CONCAT(last_name, ' ', LEFT(first_name, 1), '. ', LEFT(IFNULL(middle_name, ''), 1), '.')
    INTO v_full_name
    FROM Visitor
    WHERE login = p_login AND password = p_password;
    
    IF v_full_name IS NOT NULL THEN
        SET v_result = CONCAT(v_full_name, ', Посетитель');
        RETURN v_result;
    END IF;
    
    -- Если пользователь не найден
    RETURN 'Неверный логин или пароль';
END //

DELIMITER ;

SELECT AuthenticateUser('of_SemenovKN', 'Pa$$w0rd') AS 'Результат';
SELECT AuthenticateUser('User1', 'Password') AS 'Результат';


DELIMITER //

CREATE FUNCTION GetDishInfo(p_dish_name VARCHAR(100)) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_result TEXT;
    DECLARE v_weight DECIMAL(10,2);
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_ingredients TEXT;
    
    -- Получаем данные о блюде
    SELECT 
        m.weight,
        m.price,
        (SELECT GROUP_CONCAT(i.ingredient_name SEPARATOR ', ') 
         FROM Composition c 
         JOIN Ingredient i ON c.ingredient_id = i.ingredient_id 
         WHERE c.menu_id = m.menu_id)
    INTO 
        v_weight, v_price, v_ingredients
    FROM 
        Menu m
    WHERE 
        m.menu_name = p_dish_name;
    
    -- Формируем результат
    IF v_weight IS NOT NULL THEN
        SET v_result = CONCAT(
            v_weight, ' гр., цена: ', v_price, ' р., ',
            'Состав: ', v_ingredients
        );
    ELSE
        SET v_result = 'Неверное название';
    END IF;
    
    RETURN v_result;
END //

DELIMITER ;

SELECT GetDishInfo('Филе порося') AS 'Результат';
SELECT GetDishInfo('Куриная нарезка') AS 'Результат';

DELIMITER //

CREATE PROCEDURE GetReservationDetails(IN p_reservation_id VARCHAR(50))
BEGIN
    DECLARE v_client VARCHAR(100);
    DECLARE v_visit_datetime VARCHAR(50);
    DECLARE v_tables VARCHAR(100);
    DECLARE v_guests INT;
    DECLARE v_dishes TEXT;
    
    -- Получаем данные о клиенте, дате и столе
    SELECT 
        CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')),
        CONCAT(DATE_FORMAT(ro.visit_date, '%d.%m.%Y'), ' ', TIME_FORMAT(ro.visit_time, '%H:%i')),
        (SELECT GROUP_CONCAT(t.table_label SEPARATOR ', ') 
         FROM Reservation_Tables rt 
         JOIN `Table` t ON rt.table_id = t.table_id 
         WHERE rt.reservation_id = ro.reservation_id),
        ro.guest_count
    INTO 
        v_client, v_visit_datetime, v_tables, v_guests
    FROM 
        Reservation_Order ro
        LEFT JOIN Visitor v ON ro.client_login = v.login
    WHERE 
        ro.reservation_id = p_reservation_id;
    
    -- Получаем список блюд
    SELECT GROUP_CONCAT(
        CONCAT('«', m.menu_name, '» Х', rm.quantity, ' – ', TIME_FORMAT(rm.serving_time, '%H:%i')) 
        SEPARATOR '; '
    ) INTO v_dishes
    FROM Reservation_Menu rm
    JOIN Menu m ON rm.menu_item_id = m.menu_id
    WHERE rm.reservation_id = p_reservation_id;
    
    -- Формируем итоговый результат
    SELECT 
        IFNULL(v_client, 'Нет данных') AS 'Клиент',
        IFNULL(v_visit_datetime, 'Нет данных') AS 'Дата и время посещения',
        IFNULL(v_tables, 'Нет данных') AS 'Стол',
        IFNULL(v_guests, 'Нет данных') AS 'Количество гостей',
        IFNULL(v_dishes, 'Без заказа') AS 'Что подать';
END //

DELIMITER ;


CALL GetReservationDetails('БР/24/0000000001');