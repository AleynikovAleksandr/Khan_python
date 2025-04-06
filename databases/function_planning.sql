-- Задание 1: Вывод информации о блюдах (название, цена, вес, кол-во ингредиентов)
SELECT 
    m.menu_name AS 'Название блюда',
    CONCAT(m.price, ' руб.') AS 'Цена',
    CONCAT(m.weight, ' гр.') AS 'Вес',
    (SELECT COUNT(*) FROM Composition WHERE menu_id = m.menu_id) AS 'Количество ингредиентов'
FROM 
    Menu m
WHERE 
    m.menu_id = 1;

-- Задание 2: Вывод ФИО клиентов и средней стоимости заказов
SELECT 
    CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'Клиент',
    ROUND(AVG(o.total_cost), 2) AS 'Средний чек (руб)',
    COUNT(o.order_number) AS 'Количество заказов'
FROM 
    `Order` o
    JOIN Visitor v ON o.visitor = v.passport
GROUP BY 
    v.passport, v.last_name, v.first_name, v.middle_name
ORDER BY 
    AVG(o.total_cost) DESC;

-- Задание 3: Функция для вывода ФИО сотрудников, клиентов и номеров заказов 
SELECT 
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'ФИО сотрудника',
    CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'ФИО клиента',
    o.order_number AS 'Номер заказа'
FROM 
    `Order` o
    JOIN Waiter w ON o.employee = w.login
    JOIN Visitor v ON o.visitor = v.passport
ORDER BY 
    o.order_number;
-- Задание 4: Функция для вывода информации о блюдах с количеством символов
SELECT 
    m.menu_name AS 'Название блюда',
    CONCAT(m.weight, ' гр.') AS 'Вес',
    CONCAT(m.price, ' руб.') AS 'Цена',
    CHAR_LENGTH(m.menu_name) AS 'Количество символов в названии'
FROM 
    Menu m
WHERE 
    m.menu_id = 6;
-- Задание 5:
SELECT 
    UPPER(menu_name) AS 'Название блюда (верхний регистр)'
FROM 
    Menu
WHERE 
    menu_id = 1;
    
-- Задание 6: Функция для вывода всех бронирований с датами 
SELECT 
    ro.reservation_id AS 'Номер бронирования',
    DATE_FORMAT(ro.visit_date, '%Y') AS 'Год',
    DATE_FORMAT(ro.visit_date, '%m') AS 'Месяц',
    DATE_FORMAT(ro.visit_date, '%d') AS 'День'
FROM 
    Reservation_Order ro
WHERE 
    ro.reservation_id = 'БР/24/0000000005';

-- Задание 7: функция, которая выводит информацию о бронировании с расчетом даты отмены 
SELECT 
    ro.reservation_id AS 'Номер бронирования',
    ro.visit_date AS 'Дата посещения',
    DATE_ADD(ro.visit_date, INTERVAL 21 DAY) AS 'Дата отмены брони',
    DATEDIFF(DATE_ADD(ro.visit_date, INTERVAL 21 DAY), ro.visit_date) AS 'Дней до отмены'
FROM 
    Reservation_Order ro
WHERE 
    ro.reservation_id = 'БР/24/0000000001';

-- Задание 8: Функция для вывода самого дорогого блюда
SELECT 
    menu_name AS 'Самое дорогое блюдо',
    price AS 'Цена (руб)',
    weight AS 'Вес (гр)'
FROM 
    Menu
ORDER BY 
    price DESC
LIMIT 1;

-- Задание 9: Функция для вывода информации о заказе с нумерованным списком блюд
SELECT 
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'ФИО сотрудника',
    o.order_number AS 'Номер заказа',
    ROW_NUMBER() OVER (PARTITION BY o.order_number ORDER BY m.menu_name) AS '№',
    m.menu_name AS 'Название блюда'
FROM 
    `Order` o
    JOIN Waiter w ON o.employee = w.login
    JOIN Dishes_in_Order dio ON o.order_number = dio.order_number
    JOIN Menu m ON dio.menu_item_id = m.menu_id
WHERE 
    o.order_number = 1  
ORDER BY 
    o.order_number,
    ROW_NUMBER() OVER (PARTITION BY o.order_number ORDER BY m.menu_name);

-- Задание 10: Три наименее заказываемых блюда (по общему количеству порций)
SELECT 
    m.menu_name AS `Блюдо`,
    SUM(dio.quantity) AS `Количество заказов`
FROM Menu m
JOIN Dishes_in_Order dio ON m.menu_id = dio.menu_item_id
GROUP BY m.menu_id
ORDER BY `Количество заказов` DESC
LIMIT 3;

-- Задание 11: ФИО сотрудников и суммы стоимости их заказов
SELECT 
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'ФИО сотрудника',
    SUM(o.total_cost) AS 'Сумма стоимости заказов'
FROM 
    Waiter w
    JOIN `Order` o ON w.login = o.employee
GROUP BY 
    w.login, w.last_name, w.first_name, w.middle_name
ORDER BY 
    SUM(o.total_cost) DESC;
    
-- Задание 12: вывода блюд с учетом НДС  
SELECT 
    menu_name AS 'Название блюда',
    price AS 'Базовая стоимость',
    ROUND(price * 1.2, 2) AS 'Стоимость с НДС (20%)'
FROM 
    Menu
ORDER BY 
    menu_name;
    
-- Задание 13: вывода заказов с позициями блюд
SELECT 
    o.order_number AS 'Номер заказа',
    DATE_FORMAT(o.open_date_time, '%d.%m.%Y %H:%i') AS 'Дата создания заказа',
    GROUP_CONCAT(
        CONCAT(m.menu_name, ' (', dio.quantity, ' шт.)') 
        SEPARATOR ', '
    ) AS 'Позиции в заказе',
    COUNT(dio.id) AS 'Количество позиций'
FROM 
    `Order` o
    JOIN Dishes_in_Order dio ON o.order_number = dio.order_number
    JOIN Menu m ON dio.menu_item_id = m.menu_id
GROUP BY 
    o.order_number, o.open_date_time
ORDER BY 
    o.order_number;

-- Задание 14: для вывода номеров кассовых чеков без префикса "КЧ-" и нулей
SELECT 
    REPLACE(REPLACE(check_number, 'КЧ-', ''), '0', '') AS 'Номер чека без префикса и нулей'
FROM 
    `Check`;
    
-- Задание 15: вывода блюд с ингредиентами в нижнем регистре
SELECT 
    m.menu_name AS 'Название блюда',
    GROUP_CONCAT(LOWER(i.ingredient_name) SEPARATOR ', ') AS 'Ингредиенты (в нижнем регистре)'
FROM 
    Menu m
    JOIN Composition c ON m.menu_id = c.menu_id
    JOIN Ingredient i ON c.ingredient_id = i.ingredient_id
GROUP BY 
    m.menu_id, m.menu_name
ORDER BY 
    m.menu_name;
    
-- Задание 16: вывода номера заказа с разбивкой даты на компоненты
SELECT 
    order_number AS 'Номер заказа',
    DAY(open_date_time) AS 'День',
    MONTH(open_date_time) AS 'Месяц',
    HOUR(open_date_time) AS 'Час'
FROM 
    `Order`
ORDER BY 
    order_number;
  
-- Задание 17:  позиции в заказе и  разницу в минутах
SELECT 
    o.order_number AS 'Номер заказа',
    m.menu_name AS 'Позиция в заказе',
    TIMESTAMPDIFF(MINUTE, o.open_date_time, ch.date_time) AS 'Время приготовления (минуты)'
FROM 
    `Order` o
    JOIN `Check` ch ON o.check_number = ch.check_number
    JOIN Dishes_in_Order dio ON o.order_number = dio.order_number
    JOIN Menu m ON dio.menu_item_id = m.menu_id
ORDER BY 
    o.order_number, m.menu_name;
    
-- Задание 18: вывода самого дешёвого заказа  
SELECT 
    o.order_number AS 'Номер заказа',
    CONCAT(v.last_name, ' ', v.first_name, ' ', IFNULL(v.middle_name, '')) AS 'ФИО клиента',
    o.total_cost AS 'Сумма заказа'
FROM 
    `Order` o
    JOIN Visitor v ON o.visitor = v.passport
ORDER BY 
    o.total_cost ASC
LIMIT 1;

-- Задание 19: уникальные названия ингредиентов. 
SELECT DISTINCT ingredient_name FROM Ingredient;

-- Задание 20: расчета заработка сотрудников с учетом комиссий и налогов
SELECT 
    CONCAT(w.last_name, ' ', w.first_name, ' ', IFNULL(w.middle_name, '')) AS 'ФИО сотрудника',
    COUNT(o.order_number) AS 'Количество заказов',
    SUM(o.total_cost) AS 'Общая сумма заказов',
    ROUND(SUM(o.total_cost) * 0.15, 2) AS '15% от суммы заказов',
    ROUND(SUM(o.total_cost) * 0.15 * 0.87, 2) AS 'На руки (после НДФЛ 13%)'
FROM 
    Waiter w
    LEFT JOIN `Order` o ON w.login = o.employee
GROUP BY 
    w.login, w.last_name, w.first_name, w.middle_name
ORDER BY 
    COUNT(o.order_number) DESC;

