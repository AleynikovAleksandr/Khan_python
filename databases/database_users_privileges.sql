CREATE USER rl_administrator@'127.0.0.1' IDENTIFIED BY 'Pa$$w0rd';
CREATE USER rl_visitor@'127.0.0.1' IDENTIFIED BY 'Pa$$w0rd';
CREATE USER rl_waiter@'127.0.0.1' IDENTIFIED BY 'Pa$$w0rd';

GRANT ALL PRIVILEGES ON AleynikovAD_db1.* TO 'rl_administrator'@'127.0.0.1';

GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Visitor TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Menu TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Zone_Type TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.`Table` TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Statuses TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Payment_Type TO 'rl_visitor'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Ingredient TO 'rl_visitor'@'127.0.0.1';

GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.`Order` TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Dishes_in_Order TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.`Check` TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Menu TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.`Table` TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Reservation_Menu TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Reservation_Order TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT ON AleynikovAD_db1.Reservation_Statuses TO 'rl_waiter'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE ON AleynikovAD_db1.Reservation_Tables TO 'rl_waiter'@'127.0.0.1';

GRANT EXECUTE ON AleynikovAD_db1.* TO 'rl_administrator'@'127.0.0.1';

GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertVisitor TO 'rl_visitor'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateVisitor TO 'rl_visitor'@'127.0.0.1';

GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertOrder TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateOrder TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertDishes_in_Order TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateDishes_in_Order TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertCheck TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateCheck TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertReservation_Order TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateReservation_Order TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.InsertReservation_Tables TO 'rl_waiter'@'127.0.0.1';
GRANT EXECUTE ON PROCEDURE AleynikovAD_db1.UpdateReservation_Tables TO 'rl_waiter'@'127.0.0.1';