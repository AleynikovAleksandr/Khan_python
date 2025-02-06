while True:  
    counter = 1  
    while counter <= 10:
        try:
            print(f"Текущая итерация: {counter}")
            
            response = input("Продолжить выполнение? (да/нет): ").strip().lower().replace(" ", "")
            
            if response.startswith("н"):  
                print("Выполнение программы завершено.")
                raise SystemExit  
            
            elif response.startswith("д"):  
                print("Продолжаем выполнение.")
                counter += 1 
            
            else:
                print("Некорректный ввод. Пожалуйста, введите 'да' или 'нет'.")  
        
        except KeyboardInterrupt:  
            print("\nПрограмма была прервана пользователем.")
            raise SystemExit 
        except Exception as e:  
            print(f"Произошла непредвиденная ошибка: {e}")
            raise SystemExit  

    if counter > 10:
        print("Программа выполнила все 10 итераций.")
        raise SystemExit 