-- Входные данные, задача 1.
CREATE VIEW v_zone_summary AS
SELECT 
    zt.zone_type AS 'Зона',
    GROUP_CONCAT(
        CONCAT(t.table_label, ' (', t.seat_count, ' места)')
        ORDER BY t.table_label SEPARATOR ', '
    ) AS 'Столы и места',
    CONCAT(CONVERT(COUNT(t.table_id), CHAR), ' стола') AS 'Количество столов',
    CONCAT('Мест: ', CONVERT(SUM(t.seat_count), CHAR)) AS 'Количество мест'
FROM 
    Zone_Type zt
    JOIN `Table` t ON t.zone_id = zt.zone_type_id
GROUP BY 
    zt.zone_type;

SELECT * FROM v_zone_summary;
-- Входные данные, задача 2.
CREATE VIEW v_user_accounts AS
SELECT 
    'Сотрудник' AS 'Роль',
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'ФИО',
    w.login AS 'Логин',
    w.password AS 'Пароль'
FROM 
    Waiter w

UNION ALL

SELECT 
    'Посетитель' AS 'Роль',
    CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'ФИО',
    v.login AS 'Логин',
    v.password AS 'Пароль'
FROM 
    Visitor v;

SELECT * FROM v_user_accounts;
-- Входные данные, задача 3.
CREATE VIEW v_menu_with_orders AS
SELECT 
    CONCAT('«', m.menu_name, '», ', m.weight, ' гр., цена: ', m.price, ' р.') AS 'Блюдо',
    CONCAT('Состав: ', 
           (SELECT GROUP_CONCAT(i.ingredient_name SEPARATOR ', ') 
            FROM Composition c 
            JOIN Ingredient i ON c.ingredient_id = i.ingredient_id 
            WHERE c.menu_id = m.menu_id)
    ) AS 'Описание',
    CONCAT('Заказы: ', 
           (SELECT COUNT(*) 
            FROM Dishes_in_Order dio 
            WHERE dio.menu_item_id = m.menu_id)
    ) AS 'Сколько заказов'
FROM 
    Menu m
ORDER BY 
    (SELECT COUNT(*) FROM Dishes_in_Order WHERE menu_item_id = m.menu_id) DESC;
    
SELECT * FROM v_menu_with_orders;
-- Входные данные, задача 4.
CREATE VIEW v_order_details AS
SELECT 
    CONCAT('№ ЗКЗ-', LPAD(o.order_number, 9, '0'), '-', DATE_FORMAT(o.open_date_time, '%y'), ' - ', 
           v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'Заказ клиентов',
           
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'Официант',
    
    DATE_FORMAT(o.open_date_time, '%d.%m.%Y %H:%i:%s') AS 'Дата и время формирования',
    
    (SELECT GROUP_CONCAT(CONCAT('«', m.menu_name, '»') SEPARATOR '\n')
     FROM Dishes_in_Order dio
     JOIN Menu m ON dio.menu_item_id = m.menu_id
     WHERE dio.order_number = o.order_number) AS 'Перечень в заказе',
     
    CONCAT('Стол: ', t.table_label, ', Общая стоимость: ', o.total_cost, ' р.') AS 'Место и итог',
    
    CASE 
        WHEN c.check_number IS NOT NULL THEN
            CONCAT('Чек: № КЧ-', LPAD(c.check_number, 7, '0'), '/', DATE_FORMAT(c.date_time, '%y'), 
                   ', Дата и время: ', DATE_FORMAT(c.date_time, '%d.%m.%Y %H:%i:%s'),
                   ', Итоговая стоимость: ', c.total_amount, ' р',
                   ', Вид расчёта: ', pt.payment_type,
                   ', Внесено: ', c.amount_paid, ' р',
                   ', Сдача: ', c.change, ' р.')
        ELSE 'Открыт'
    END AS 'Наличие чека'
    
FROM 
    `Order` o
    JOIN Visitor v ON o.visitor = v.passport
    JOIN Waiter w ON o.employee = w.login
    JOIN `Table` t ON o.`table` = t.table_id
    LEFT JOIN `Check` c ON o.check_number = c.check_number
    LEFT JOIN Payment_Type pt ON c.payment_type = pt.payment_id
ORDER BY 
    o.order_number;

SELECT * FROM v_order_details;
-- Входные данные, задача 5.
CREATE VIEW v_supply_details AS
SELECT 
    CONCAT('№ СП-', LPAD(e.estimate_number, 7, '0'), '-', DATE_FORMAT(e.formation_date, '%y')) AS 'Номер поставки',
    CONCAT('Дата формирования: ', DATE_FORMAT(e.formation_date, '%d.%m.%Y')) AS 'Сформирована',
    CONCAT(s.supplier_name, ', ОКПО: ', s.okpo) AS 'Поставщик',
    CONCAT('Ингредиенты: ', 
           GROUP_CONCAT(
               CONCAT(i.ingredient_name, ' ', e.weight, ' кг.') 
               SEPARATOR ', '
           )
    ) AS 'Список к поставке'
FROM 
    Estimate e
    JOIN Supplier s ON e.okpo = s.okpo
    JOIN Ingredient i ON e.ingredient_id = i.ingredient_id
GROUP BY 
    e.estimate_number, e.formation_date, s.supplier_name, s.okpo
ORDER BY 
    e.estimate_number;

SELECT * FROM v_supply_details;
-- Входные данные, задача 6.
CREATE VIEW v_reservation_details AS
SELECT 
    CONCAT('№ ', ro.reservation_id, ', клиент: ', 
           v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'Бронь и клиент',
    
    CONCAT('Дата и время создания: ', DATE_FORMAT(ro.creation_date, '%d.%m.%Y %H:%i:%s'),
           ', планируемая дата посещения: ', DATE_FORMAT(ro.visit_date, '%d.%m.%Y'),
           ', планируемое время посещения: ', TIME_FORMAT(ro.visit_time, '%H:%i')) AS 'Данные о времени',
    
    CONCAT('Номер стола: ',
           (SELECT GROUP_CONCAT(t.table_label SEPARATOR ', ') 
            FROM Reservation_Tables rt 
            JOIN `Table` t ON rt.table_id = t.table_id 
            WHERE rt.reservation_id = ro.reservation_id),
           ', количество гостей: ', ro.guest_count) AS 'Место бронирования',
    
    IF(
        EXISTS (SELECT 1 FROM Reservation_Menu rm WHERE rm.reservation_id = ro.reservation_id),
        (SELECT GROUP_CONCAT(
                    CONCAT('«', m.menu_name, '» Х', rm.quantity, ' – ', TIME_FORMAT(rm.serving_time, '%H:%i'))
                    ORDER BY rm.serving_time SEPARATOR '; ')
         FROM Reservation_Menu rm
         JOIN Menu m ON rm.menu_item_id = m.menu_id
         WHERE rm.reservation_id = ro.reservation_id),
        'Нет блюд в предварительном заказе'
    ) AS 'Заказы к прибытию гостей'

FROM 
    Reservation_Order ro
    JOIN Visitor v ON ro.client_login = v.login

ORDER BY 
    ro.reservation_id ASC;

SELECT * FROM v_reservation_details;