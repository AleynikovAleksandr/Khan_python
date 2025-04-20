CREATE TABLE Order_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY, 
    order_number INT NOT NULL,             
    employee VARCHAR(100),                 
    visitor VARCHAR(100),                  
    dish_name VARCHAR(100),                
    quantity INT,                          
    total_cost DECIMAL(10,2),              
    log_date_time DATETIME                 
);

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
        order_number, employee, visitor, dish_name, quantity, total_cost, log_date_time
    )
    VALUES (
        NEW.order_number, @full_name_employee, @full_name_visitor, @dish_name, NEW.quantity, @total_cost, NOW()
    );
END$$

DELIMITER ;

SELECT * FROM Order_Log;
SELECT * FROM  `Order`;

INSERT INTO `Check` (check_number, date_time, payment_type, amount_paid, total_amount, `change`)
VALUES (100, '2025-04-18 14:30:00', 1, 3500, 3500, 0);

INSERT INTO `Order` (order_number, check_number, employee, open_date_time, `table`, total_cost, `status`, visitor)
VALUES (100, 100, 'of_AndreevAA', '2025-04-18 14:35:00', 3, 3500, 1, '4678239712');

INSERT INTO Dishes_in_Order (menu_item_id, order_number, quantity) VALUES 
(4, 100, 2);