
DELIMITER //

CREATE PROCEDURE InsertZone_Type(IN p_zone_type VARCHAR(50))
BEGIN
    INSERT INTO Zone_Type (zone_type) VALUES (p_zone_type);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateZone_Type(IN p_zone_type_id INT, IN p_zone_type VARCHAR(50))
BEGIN
    UPDATE Zone_Type
    SET zone_type = p_zone_type
    WHERE zone_type_id = p_zone_type_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteZone_Type(IN p_zone_type_id INT)
BEGIN
    DELETE FROM Zone_Type
    WHERE zone_type_id = p_zone_type_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertMenu(IN p_menu_name VARCHAR(100), IN p_weight DECIMAL(10,2), IN p_price DECIMAL(10,2))
BEGIN
    INSERT INTO Menu (menu_name, weight, price) VALUES (p_menu_name, p_weight, p_price);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateMenu(IN p_menu_id INT, IN p_menu_name VARCHAR(100), IN p_weight DECIMAL(10,2), IN p_price DECIMAL(10,2))
BEGIN
    UPDATE Menu
    SET menu_name = p_menu_name, weight = p_weight, price = p_price
    WHERE menu_id = p_menu_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteMenu(IN p_menu_id INT)
BEGIN
    DELETE FROM Menu
    WHERE menu_id = p_menu_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertIngredient(IN p_ingredient_name VARCHAR(100))
BEGIN
    INSERT INTO Ingredient (ingredient_name) VALUES (p_ingredient_name);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateIngredient(IN p_ingredient_id INT, IN p_ingredient_name VARCHAR(100))
BEGIN
    UPDATE Ingredient
    SET ingredient_name = p_ingredient_name
    WHERE ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteIngredient(IN p_ingredient_id INT)
BEGIN
    DELETE FROM Ingredient
    WHERE ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertSupplier(IN p_okpo VARCHAR(10), IN p_supplier_name VARCHAR(100), IN p_city VARCHAR(50), IN p_street VARCHAR(50), IN p_building VARCHAR(50))
BEGIN
    INSERT INTO Supplier (okpo, supplier_name, city, street, building) VALUES (p_okpo, p_supplier_name, p_city, p_street, p_building);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateSupplier(IN p_okpo VARCHAR(10), IN p_supplier_name VARCHAR(100), IN p_city VARCHAR(50), IN p_street VARCHAR(50), IN p_building VARCHAR(50))
BEGIN
    UPDATE Supplier
    SET supplier_name = p_supplier_name, city = p_city, street = p_street, building = p_building
    WHERE okpo = p_okpo;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteSupplier(IN p_okpo VARCHAR(10))
BEGIN
    DELETE FROM Supplier
    WHERE okpo = p_okpo;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertStatuses(IN p_status VARCHAR(50))
BEGIN
    INSERT INTO Statuses (`status`) VALUES (p_status);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateStatuses(IN p_status_id INT, IN p_status VARCHAR(50))
BEGIN
    UPDATE Statuses
    SET `status` = p_status
    WHERE status_id = p_status_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteStatuses(IN p_status_id INT)
BEGIN
    DELETE FROM Statuses
    WHERE status_id = p_status_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertPayment_Type(IN p_payment_type VARCHAR(50))
BEGIN
    INSERT INTO Payment_Type (payment_type) VALUES (p_payment_type);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdatePayment_Type(IN p_payment_id INT, IN p_payment_type VARCHAR(50))
BEGIN
    UPDATE Payment_Type
    SET payment_type = p_payment_type
    WHERE payment_id = p_payment_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeletePayment_Type(IN p_payment_id INT)
BEGIN
    DELETE FROM Payment_Type
    WHERE payment_id = p_payment_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertGuest(IN p_phone_number VARCHAR(15), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50))
BEGIN
    INSERT INTO Guest (phone_number, last_name, first_name, middle_name) VALUES (p_phone_number, p_last_name, p_first_name, p_middle_name);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateGuest(IN p_phone_number VARCHAR(15), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50))
BEGIN
    UPDATE Guest
    SET last_name = p_last_name, first_name = p_first_name, middle_name = p_middle_name
    WHERE phone_number = p_phone_number;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteGuest(IN p_phone_number VARCHAR(15))
BEGIN
    DELETE FROM Guest
    WHERE phone_number = p_phone_number;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertComposition(IN p_ingredient_id INT, IN p_menu_id INT)
BEGIN
    INSERT INTO Composition (ingredient_id, menu_id) VALUES (p_ingredient_id, p_menu_id);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateComposition(IN p_ingredient_id INT, IN p_menu_id INT, IN p_new_ingredient_id INT, IN p_new_menu_id INT)
BEGIN
    UPDATE Composition
    SET ingredient_id = p_new_ingredient_id, menu_id = p_new_menu_id
    WHERE ingredient_id = p_ingredient_id AND menu_id = p_menu_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteComposition(IN p_ingredient_id INT, IN p_menu_id INT)
BEGIN
    DELETE FROM Composition
    WHERE ingredient_id = p_ingredient_id AND menu_id = p_menu_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertEstimate(IN p_estimate_number INT, IN p_ingredient_id INT, IN p_weight DECIMAL(12,3), IN p_okpo CHAR(10), IN p_formation_date DATE)
BEGIN
    INSERT INTO Estimate (estimate_number, ingredient_id, weight, okpo, formation_date) VALUES (p_estimate_number, p_ingredient_id, p_weight, p_okpo, p_formation_date);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateEstimate(IN p_estimate_number INT, IN p_ingredient_id INT, IN p_weight DECIMAL(12,3), IN p_okpo CHAR(10), IN p_formation_date DATE)
BEGIN
    UPDATE Estimate
    SET weight = p_weight, okpo = p_okpo, formation_date = p_formation_date
    WHERE estimate_number = p_estimate_number AND ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteEstimate(IN p_estimate_number INT, IN p_ingredient_id INT)
BEGIN
    DELETE FROM Estimate
    WHERE estimate_number = p_estimate_number AND ingredient_id = p_ingredient_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertTable(IN p_zone_id INT, IN p_table_label VARCHAR(50), IN p_seat_count INT)
BEGIN
    INSERT INTO `Table` (zone_id, table_label, seat_count) VALUES (p_zone_id, p_table_label, p_seat_count);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateTable(IN p_table_id INT, IN p_zone_id INT, IN p_table_label VARCHAR(50), IN p_seat_count INT)
BEGIN
    UPDATE `Table`
    SET zone_id = p_zone_id, table_label = p_table_label, seat_count = p_seat_count
    WHERE table_id = p_table_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteTable(IN p_table_id INT)
BEGIN
    DELETE FROM `Table`
    WHERE table_id = p_table_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertVisitor(IN p_passport VARCHAR(10), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_bank_card_number VARCHAR(16), IN p_login VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO Visitor (passport, last_name, first_name, middle_name, bank_card_number, login, `password`) VALUES (p_passport, p_last_name, p_first_name, p_middle_name, p_bank_card_number, p_login, p_password);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateVisitor(IN p_passport VARCHAR(10), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_bank_card_number VARCHAR(16), IN p_login VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    UPDATE Visitor
    SET last_name = p_last_name, first_name = p_first_name, middle_name = p_middle_name, bank_card_number = p_bank_card_number, login = p_login, `password` = p_password
    WHERE passport = p_passport;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteVisitor(IN p_passport VARCHAR(10))
BEGIN
    DELETE FROM Visitor
    WHERE passport = p_passport;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertWaiter(IN p_login VARCHAR(50), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO Waiter (login, last_name, first_name, middle_name, `password`) VALUES (p_login, p_last_name, p_first_name, p_middle_name, p_password);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateWaiter(IN p_login VARCHAR(50), IN p_last_name VARCHAR(50), IN p_first_name VARCHAR(50), IN p_middle_name VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    UPDATE Waiter
    SET last_name = p_last_name, first_name = p_first_name, middle_name = p_middle_name, `password` = p_password
    WHERE login = p_login;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteWaiter(IN p_login VARCHAR(50))
BEGIN
    DELETE FROM Waiter
    WHERE login = p_login;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertCheck(IN p_date_time DATETIME, IN p_payment_type INT, IN p_amount_paid DECIMAL(10,2), IN p_total_amount DECIMAL(10,2), IN p_change DECIMAL(10,2))
BEGIN
    INSERT INTO `Check` (date_time, payment_type, amount_paid, total_amount, `change`) VALUES (p_date_time, p_payment_type, p_amount_paid, p_total_amount, p_change);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateCheck(IN p_check_number INT, IN p_date_time DATETIME, IN p_payment_type INT, IN p_amount_paid DECIMAL(10,2), IN p_total_amount DECIMAL(10,2), IN p_change DECIMAL(10,2))
BEGIN
    UPDATE `Check`
    SET date_time = p_date_time, payment_type = p_payment_type, amount_paid = p_amount_paid, total_amount = p_total_amount, `change` = p_change
    WHERE check_number = p_check_number;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteCheck(IN p_check_number INT)
BEGIN
    DELETE FROM `Check`
    WHERE check_number = p_check_number;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertOrder(IN p_check_number INT, IN p_employee VARCHAR(50), IN p_open_date_time DATETIME, IN p_table INT, IN p_total_cost DECIMAL(10,2), IN p_status INT, IN p_visitor VARCHAR(10))
BEGIN
    INSERT INTO `Order` (check_number, employee, open_date_time, `table`, total_cost, `status`, visitor) VALUES (p_check_number, p_employee, p_open_date_time, p_table, p_total_cost, p_status, p_visitor);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateOrder(IN p_order_number INT, IN p_check_number INT, IN p_employee VARCHAR(50), IN p_open_date_time DATETIME, IN p_table INT, IN p_total_cost DECIMAL(10,2), IN p_status INT, IN p_visitor VARCHAR(10))
BEGIN
    UPDATE `Order`
    SET check_number = p_check_number, employee = p_employee, open_date_time = p_open_date_time, `table` = p_table, total_cost = p_total_cost, `status` = p_status, visitor = p_visitor
    WHERE order_number = p_order_number;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteOrder(IN p_order_number INT)
BEGIN
    DELETE FROM `Order`
    WHERE order_number = p_order_number;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertDishes_in_Order(IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT)
BEGIN
    INSERT INTO Dishes_in_Order (menu_item_id, order_number, quantity) VALUES (p_menu_item_id, p_order_number, p_quantity);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateDishes_in_Order(IN p_id INT, IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT)
BEGIN
    UPDATE Dishes_in_Order
    SET menu_item_id = p_menu_item_id, order_number = p_order_number, quantity = p_quantity
    WHERE id = p_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteDishes_in_Order(IN p_id INT)
BEGIN
    DELETE FROM Dishes_in_Order
    WHERE id = p_id;
END //

DELIMITER ;

-- Insert
DELIMITER //

CREATE PROCEDURE InsertAdditional_Dish(IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT, IN p_guest VARCHAR(15))
BEGIN
    INSERT INTO Additional_Dish (menu_item_id, order_number, quantity, guest) VALUES (p_menu_item_id, p_order_number, p_quantity, p_guest);
END //

DELIMITER ;

-- Update
DELIMITER //

CREATE PROCEDURE UpdateAdditional_Dish(IN p_id INT, IN p_menu_item_id INT, IN p_order_number INT, IN p_quantity INT, IN p_guest VARCHAR(15))
BEGIN
    UPDATE Additional_Dish
    SET menu_item_id = p_menu_item_id, order_number = p_order_number, quantity = p_quantity, guest = p_guest
    WHERE id = p_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE PROCEDURE DeleteAdditional_Dish(IN p_id INT)
BEGIN
    DELETE FROM Additional_Dish
    WHERE id = p_id;
END //

DELIMITER ;


-- Процедуры для таблицы Reservation_Statuses
DELIMITER //

CREATE PROCEDURE InsertReservation_Statuses(
    IN p_reservation_status VARCHAR(50)
)
BEGIN
    INSERT INTO Reservation_Statuses (reservation_status)
    VALUES (p_reservation_status);
END //

CREATE PROCEDURE UpdateReservation_Statuses(
    IN p_status_id INT,
    IN p_reservation_status VARCHAR(50)
)
BEGIN
    UPDATE Reservation_Statuses
    SET reservation_status = p_reservation_status
    WHERE status_id = p_status_id;
END //

CREATE PROCEDURE DeleteReservation_Statuses(
    IN p_status_id INT
)
BEGIN
    DELETE FROM Reservation_Statuses
    WHERE status_id = p_status_id;
END //

DELIMITER ;

-- Процедуры для таблицы Reservation_Order
DELIMITER //

CREATE PROCEDURE InsertReservation_Order(
    IN p_reservation_id VARCHAR(50),
    IN p_client_login VARCHAR(50),
    IN p_creation_date DATETIME,
    IN p_visit_date DATE,
    IN p_visit_time TIME,
    IN p_guest_count INT,
    IN p_status_id INT
)
BEGIN
    INSERT INTO Reservation (reservation_id, client_login, creation_date, visit_date, visit_time, guest_count, status_id)
    VALUES (p_reservation_id, p_client_login, p_creation_date, p_visit_date, p_visit_time, p_guest_count, p_status_id);
END //

CREATE PROCEDURE UpdateReservation_Order(
    IN p_reservation_id VARCHAR(50),
    IN p_client_login VARCHAR(50),
    IN p_creation_date DATETIME,
    IN p_visit_date DATE,
    IN p_visit_time TIME,
    IN p_guest_count INT,
    IN p_status_id INT
)
BEGIN
    UPDATE Reservation
    SET client_login = p_client_login,
        creation_date = p_creation_date,
        visit_date = p_visit_date,
        visit_time = p_visit_time,
        guest_count = p_guest_count,
        status_id = p_status_id
    WHERE reservation_id = p_reservation_id;
END //

CREATE PROCEDURE DeleteReservation_Order(
    IN p_reservation_id VARCHAR(50)
)
BEGIN
    DELETE FROM Reservation
    WHERE reservation_id = p_reservation_id;
END //

DELIMITER ;

-- Процедуры для таблицы Reservation_Tables
DELIMITER //

CREATE PROCEDURE InsertReservation_Tables(
    IN p_reservation_id VARCHAR(50),
    IN p_table_id INT
)
BEGIN
    INSERT INTO Reservation_Tables (reservation_id, table_id)
    VALUES (p_reservation_id, p_table_id);
END //

CREATE PROCEDURE UpdateReservation_Tables(
    IN p_reservation_id VARCHAR(50),
    IN p_table_id INT,
    IN p_new_table_id INT
)
BEGIN
    UPDATE Reservation_Tables
    SET table_id = p_new_table_id
    WHERE reservation_id = p_reservation_id AND table_id = p_table_id;
END //

CREATE PROCEDURE DeleteReservation_Tables(
    IN p_reservation_id VARCHAR(50),
    IN p_table_id INT
)
BEGIN
    DELETE FROM Reservation_Tables
    WHERE reservation_id = p_reservation_id AND table_id = p_table_id;
END //

DELIMITER ;

-- Процедуры для таблицы Reservation_Menu
DELIMITER //

CREATE PROCEDURE InsertReservation_Menu(
    IN p_reservation_id VARCHAR(50),
    IN p_menu_item_id INT,
    IN p_serving_time TIME,
    IN p_quantity INT
)
BEGIN
    INSERT INTO Reservation_Menu (reservation_id, menu_item_id, serving_time, quantity)
    VALUES (p_reservation_id, p_menu_item_id, p_serving_time, p_quantity);
END //

CREATE PROCEDURE UpdateReservation_Menu(
    IN p_reservation_menu_id INT,
    IN p_reservation_id VARCHAR(50),
    IN p_menu_item_id INT,
    IN p_serving_time TIME,
    IN p_quantity INT
)
BEGIN
    UPDATE Reservation_Menu
    SET reservation_id = p_reservation_id,
        menu_item_id = p_menu_item_id,
        serving_time = p_serving_time,
        quantity = p_quantity
    WHERE reservation_menu_id = p_reservation_menu_id;
END //

CREATE PROCEDURE DeleteReservation_Menu(
    IN p_reservation_menu_id INT
)
BEGIN
    DELETE FROM Reservation_Menu
    WHERE reservation_menu_id = p_reservation_menu_id;
END //

DELIMITER ;