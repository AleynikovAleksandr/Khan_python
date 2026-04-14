from db_client import ClickHouseClient

class Analytics:

    def __init__(self):
        self.db = ClickHouseClient()
        self.db.set_database()

    def fill_summary(self):
        self.db.command("""
        INSERT INTO Sales_Summary
        SELECT
            t.TheDate,
            p.ProductName,
            c.CompanyName,
            e.EmployeeName,
            s.ShipperName,
            f.LineItemQuantity,
            f.LineItemTotal
        FROM Sales_Fact f
        LEFT JOIN Product_Dim p ON f.ProductKey = p.ProductKey
        LEFT JOIN Customer_Dim c ON f.CustomerKey = c.CustomerKey
        LEFT JOIN Employee_Dim e ON f.EmployeeKey = e.EmployeeKey
        LEFT JOIN Shipper_Dim s ON f.ShipperKey = s.ShipperKey
        LEFT JOIN Time_Dim t ON f.TimeKey = t.TimeKey
        """)

        print("Сводная таблица заполнена")

    def show_summary(self):
        result = self.db.query("SELECT * FROM Sales_Summary")

        print("\nСводная таблица:")
        print("=" * 50)
        print(" | ".join(result.column_names))

        for row in result.result_rows:
            print(" | ".join(map(str, row)))

    def console_output(self):
        tables = [
            'Product_Dim', 'Employee_Dim', 'Customer_Dim',
            'Shipper_Dim', 'Time_Dim', 'Sales_Fact'
        ]

        print("\n" + "=" * 50)
        print("СОДЕРЖИМОЕ ТАБЛИЦ:")
        print("=" * 50)

        for table in tables:
            result = self.db.query(f"SELECT * FROM {table} LIMIT 5")

            print(f"\nТаблица: {table}")
            print("-" * len(table))
            print(" | ".join(result.column_names))
            print("-" * 30)

            for row in result.result_rows:
                print(" | ".join(map(str, row)))