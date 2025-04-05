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
    
    SELECT DISTINCT
m.menu_name AS 'Название блюда',
m.price AS 'Цена',
(
SELECT GROUP_CONCAT(i.ingredient_name SEPARATOR ', ')
FROM Composition c
JOIN Ingredient i ON c.ingredient_id = i.ingredient_id
WHERE c.menu_id = m.menu_id
) AS 'Все ингредиенты'
FROM
Menu m
JOIN Composition c ON m.menu_id = c.menu_id
JOIN Ingredient i ON c.ingredient_id = i.ingredient_id
WHERE
i.ingredient_name IN ('Лук', 'Перец', 'Морковь')
ORDER BY
m.menu_name;
    
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
    GROUP_CONCAT(DISTINCT i.ingredient_name SEPARATOR ', ') AS 'Ингредиенты',
    m.weight AS 'Вес (гр)',
    m.price AS 'Цена (руб)'
FROM 
    Menu m
    JOIN Composition c ON m.menu_id = c.menu_id
    JOIN Ingredient i ON c.ingredient_id = i.ingredient_id

WHERE 

    NOT EXISTS (
        SELECT 1
        FROM Composition c2
        JOIN Ingredient i2 ON c2.ingredient_id = i2.ingredient_id
        WHERE c2.menu_id = m.menu_id
        AND i2.ingredient_name = 'Морковь'
    )

GROUP BY 
    m.menu_id, m.menu_name, m.weight, m.price
ORDER BY 
    m.menu_name;
    
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