-- Создание таблицы для статусов бронирования
CREATE TABLE Reservation_Statuses (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_status VARCHAR(50) NOT NULL,
);

-- Добавление статусов бронирования
INSERT INTO Reservation_Statuses (reservation_status) VALUES 
('Активна'), 
('Отменена'), 
('Завершена'); 

-- Создание таблицы для бронирований
CREATE TABLE Reservation (
    reservation_id VARCHAR(15) PRIMARY KEY, -- Уникальный идентификатор бронирования
    client VARCHAR(10) NOT NULL, -- Клиент (ссылка на таблицу Visitor)
    creation_datetime DATETIME NOT NULL, -- Дата и время создания брони
    planned_visit_date DATE NOT NULL, -- Планируемая дата посещения
    planned_visit_time TIME NOT NULL, -- Планируемое время посещения
    guest_count INT NOT NULL, -- Количество гостей
    status_id INT NOT NULL , -- Статус бронирования (по умолчанию "Активна")
    FOREIGN KEY (client) REFERENCES Visitor(login) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Reservation_Statuses(status_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Создание таблицы для связи бронирования и столов
CREATE TABLE Reservation_Tables (
    reservation_id VARCHAR(15) NOT NULL, -- Ссылка на бронирование
    table_id INT NOT NULL, -- Ссылка на стол
    PRIMARY KEY (reservation_id, table_id), -- Составной первичный ключ
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (table_id) REFERENCES `Table`(table_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Создание таблицы для блюд в бронировании
CREATE TABLE Reservation_Dishes (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Уникальный идентификатор записи
    reservation_id VARCHAR(15) NOT NULL, -- Ссылка на бронирование
    menu_item_id INT NOT NULL, -- Ссылка на блюдо из меню
    quantity INT NOT NULL, -- Количество блюд
    serving_time TIME NOT NULL, -- Время подачи блюда
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES Menu(menu_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Вставка данных о бронированиях
INSERT INTO Reservation (reservation_id, client, creation_datetime, planned_visit_date, planned_visit_time, guest_count, status_id)
VALUES
    ('БР/24/0000000001', 'IvanovII', '2024-01-01 16:01:10', '2024-02-02', '12:00:00', 2, 1), 
    ('БР/24/0000000002', 'PetrovAA', '2024-01-20 09:50:21', '2024-02-19', '16:30:00', 8, 1), 
    ('БР/24/0000000003', 'IvanovII', '2024-01-20 17:09:25', '2024-02-10', '12:45:00', 1, 1), 
    ('БР/24/0000000004', 'PetrovAA', '2024-02-02 18:00:35', '2024-02-06', '17:20:00', 2, 1), 
    ('БР/24/0000000005', 'PetrovAA', '2024-02-10 15:43:59', '2024-02-11', '13:00:00', 4, 1); 

-- Вставка данных о столах для бронирования
INSERT INTO Reservation_Tables (reservation_id, table_id)
VALUES
    ('БР/24/0000000001', 9), 
    ('БР/24/0000000002', 1), 
    ('БР/24/0000000002', 2), 
    ('БР/24/0000000003', 3), 
    ('БР/24/0000000004', 4), 
    ('БР/24/0000000005', 8); 


-- Вставка данных о блюдах в бронировании
INSERT INTO Reservation_Dishes (reservation_id, menu_item_id, quantity, serving_time)
VALUES
    -- Бронирование 1: БР/24/0000000001
    ('БР/24/0000000001', 1, 4, '12:00:00'), -- Филе порося
    ('БР/24/0000000001', 4, 2, '13:00:00'), -- Мясная тарелка

    -- Бронирование 2: БР/24/0000000002 (придуманные блюда)
    ('БР/24/0000000002', 5, 3, '16:30:00'), -- Как бы здоровое питание
    ('БР/24/0000000002', 6, 5, '17:00:00'), -- Картофель по-своему

    -- Бронирование 3: БР/24/0000000003
    ('БР/24/0000000003', 6, 1, '12:45:00'), -- Картофель по-своему
    ('БР/24/0000000003', 3, 2, '12:45:00'), -- Гарнир овощной

    -- Бронирование 4: БР/24/0000000004
    ('БР/24/0000000004', 2, 2, '17:40:00'), -- Суп мечты

    -- Бронирование 5: БР/24/0000000005 (придуманные блюда)
    ('БР/24/0000000005', 1, 2, '13:00:00'), -- Филе порося
    ('БР/24/0000000005', 4, 2, '14:00:00'); -- Мясная тарелка