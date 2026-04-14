from db_client import ClickHouseClient
from datetime import date

def insert_data():
    db = ClickHouseClient()
    db.set_database()

    db.insert("Product_Dim", [
        (1, 101, 'Смартфон X', 'ТехноПром', 'Электроника', 50000.0),
        (2, 102, 'Ноутбук Pro', 'АйТи Системы', 'Компьютеры', 120000.0)
    ], ['ProductKey','ProductID','ProductName','SupplierName','CategoyName','ListUnitPrice'])

    db.insert("Employee_Dim", [
        (1, 501, 'Иван Иванов', date(2022,5,15)),
        (2, 502, 'Анна Смирнова', date(2023,1,10))
    ], ['EmployeeKey','EmployeeID','EmployeeName','HireDate'])

    db.insert("Customer_Dim", [
        (1,'CUST001','ООО Вектор','Директор','ул. Ленина 1','Москва','МСК','101000','Россия','+7495','нет'),
        (2,'CUST002','ИП Петров','Менеджер','пр. Мира 10','Казань','РТ','420000','Россия','+7843','нет')
    ])

    db.insert("Shipper_Dim", [
        (1,1,'Быстрая Почта'),
        (2,2,'Грузовоз')
    ], ['ShipperKey','ShipperID','ShipperName'])

    db.insert("Time_Dim", [
        (20240326, date(2024,3,26),2,3,2024,1,86,0,0,202403,13),
        (20240327, date(2024,3,27),3,3,2024,1,87,0,0,202403,13)
    ])

    db.insert("Sales_Fact", [
        (20240326,1,1,1,1,date(2024,3,30),500.5,50500.5,1,0.0),
        (20240327,2,2,2,2,date(2024,4,5),1200.0,121200.0,1,5.0)
    ])

    print("Данные загружены")