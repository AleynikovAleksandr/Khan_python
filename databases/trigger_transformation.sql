CREATE TABLE Order_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY, 
    order_number INT NOT NULL,             
    employee VARCHAR(100),                 
    visitor VARCHAR(100),                  
    dish_name VARCHAR(100),                
    quantity INT,                          
    total_cost DECIMAL(10,2),              
    log_date_time DATETIME,
    action_type VARCHAR(50)                
);

-- 1 trigger to add order
DROP TRIGGER IF EXISTS trg_after_dish_insert;
DELIMITER $$

CREATE TRIGGER trg_after_dish_insert
AFTER INSERT ON Dishes_in_Order
FOR EACH ROW
BEGIN
    -- Получаем данные заказа и сотрудника
    SELECT 
        o.total_cost,
        CONCAT(w.last_name, ' ', w.first_name, ' ', COALESCE(w.middle_name, '')),
        CONCAT(v.last_name, ' ', v.first_name, ' ', COALESCE(v.middle_name, ''))
    INTO 
        @total_cost,
        @full_name_employee,
        @full_name_visitor
    FROM `Order` o
    JOIN Waiter w ON o.employee = w.login
    JOIN Visitor v ON o.visitor = v.passport
    WHERE o.order_number = NEW.order_number;

    -- Получаем название блюда
    SELECT menu_name INTO @dish_name
    FROM Menu
    WHERE menu_id = NEW.menu_item_id;

    -- Вставляем запись в лог
    INSERT INTO Order_Log (
        order_number, employee, visitor, dish_name, quantity, total_cost, log_date_time, action_type
    )
    VALUES (
        NEW.order_number, @full_name_employee, @full_name_visitor, @dish_name, NEW.quantity, @total_cost, NOW(), 'запись добавлена'
    );
END$$

DELIMITER ;
-- 2 trigger for order editing
DROP TRIGGER IF EXISTS trg_after_dish_update;
DELIMITER $$

CREATE TRIGGER trg_after_dish_update
AFTER UPDATE ON Dishes_in_Order
FOR EACH ROW
BEGIN
    DECLARE full_name_employee VARCHAR(100);
    DECLARE full_name_visitor VARCHAR(100);
    DECLARE new_dish_name VARCHAR(100);
    DECLARE total_cost DECIMAL(10,2);

    -- Получаем данные заказа, официанта и клиента
    SELECT 
        CONCAT(w.last_name, ' ', w.first_name, ' ', COALESCE(w.middle_name, '')),
        CONCAT(v.last_name, ' ', v.first_name, ' ', COALESCE(v.middle_name, ''))
    INTO 
        full_name_employee,
        full_name_visitor
    FROM `Order` o
    JOIN Waiter w ON o.employee = w.login
    JOIN Visitor v ON o.visitor = v.passport
    WHERE o.order_number = NEW.order_number;

    -- Название нового блюда
    SELECT menu_name INTO new_dish_name
    FROM Menu WHERE menu_id = NEW.menu_item_id;

    -- Перерасчёт общей стоимости заказа
    SELECT SUM(d.quantity * m.price)
    INTO total_cost
    FROM Dishes_in_Order d
    JOIN Menu m ON d.menu_item_id = m.menu_id
    WHERE d.order_number = NEW.order_number;

    -- Обновляем стоимость заказа
    UPDATE `Order`
    SET total_cost = total_cost
    WHERE order_number = NEW.order_number;

    -- Логируем обновление
    IF (OLD.menu_item_id <> NEW.menu_item_id OR OLD.quantity <> NEW.quantity) THEN
        INSERT INTO Order_Log (
            order_number, employee, visitor, dish_name, quantity, total_cost, log_date_time, action_type
        )
        VALUES (
            NEW.order_number,
            full_name_employee,
            full_name_visitor,
            new_dish_name,
            NEW.quantity,
            total_cost,
            NOW(),
            'запись обновлена'
        );
    END IF;
END$$

DELIMITER ;


SELECT * FROM Order_Log;
SELECT * FROM  `Order`;

INSERT INTO `Check` (check_number, date_time, payment_type, amount_paid, total_amount, `change`)
VALUES (116, '2025-04-18 14:30:00', 1, 3500, 3500, 0);

INSERT INTO `Order` (order_number, check_number, employee, open_date_time, `table`, total_cost, `status`, visitor)
VALUES (116, 116, 'of_AndreevAA', '2025-04-18 14:35:00', 3, 3500, 1, '4678239712');

INSERT INTO Dishes_in_Order (menu_item_id, order_number, quantity) VALUES 
(4, 116, 2);


SET SQL_SAFE_UPDATES = 0;

UPDATE Dishes_in_Order
SET menu_item_id = 2, quantity = 20
WHERE order_number = 112 ;

SET SQL_SAFE_UPDATES = 1;


