import sys
import os
from PyQt5 import QtCore
from decimal import Decimal
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QGridLayout, QPushButton, QLineEdit

class Calculator(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Calculator')
        self.setLayout(QVBoxLayout())
        self.current_value = ''
        self.last_operator = None
        self.second_operand = None
        self.last_pressed = None

        self.input_field = QLineEdit()
        self.input_field.setReadOnly(True)
        self.input_field.setAlignment(QtCore.Qt.AlignRight)
        self.input_field.setText('0')
        self.layout().addWidget(self.input_field)

        buttons = [
            ['C', '+/-', '%', '÷'],
            ['7', '8', '9', '×'],
            ['4', '5', '6', '−'],
            ['1', '2', '3', '+'],
            ['0', '00', '.', '=']
        ]
        grid_layout = QGridLayout()
        for row, button_row in enumerate(buttons):
            for col, button_label in enumerate(button_row):
                button = QPushButton(button_label)
                button.clicked.connect(self.button_clicked)
                if button_label in ['0', '00']:
                    button.setObjectName("calculatorButton")
                elif button_label in ['÷', '×', '−', '+', '+/-', '=', '%', 'C']:
                    button.setObjectName("mathButton")
                else:
                    button.setObjectName("calculatorButton")
                grid_layout.addWidget(button, row, col)
        self.layout().addLayout(grid_layout)

        self.setStyleSheet('''
            QPushButton#calculatorButton {
                background-color: #333333;
                color: white;
                font-size: 16px;
                padding: 8px;
                min-width: 40px;
                min-height: 40px;
                border-radius: 20px;
            }
            QPushButton#mathButton {
                background-color: #FFA500;
                color: white;
                font-size: 16px;
                padding: 8px;
                min-width: 40px;
                min-height: 40px;
                border-radius: 20px;
            }
            QWidget {
                background-color: #000000;
            }
            QLineEdit {
                background-color: #000000;
                color: white;
                font-size: 18px;
                padding: 8px;
                border-radius: 5px;
                margin-top: 10px;
                margin-bottom: 10px;
            }
            QPushButton#calculatorButton:hover, QPushButton#mathButton:hover {
                background-color: #777777;
            }
            QPushButton#calculatorButton:pressed, QPushButton#mathButton:pressed {
                background-color: #555555;
            }
        ''')

    def save_history(self, expression, result):
        dir_path = os.path.dirname(os.path.abspath(__file__))
        file_path = os.path.join(dir_path, "history.txt")
        with open(file_path, 'a', encoding='utf-8') as f:
            f.write(f"{expression}={result}\n")

    def symbdup(self, text):
        if text in ['+', '-', '*', '/']:
            if len(self.current_value) > 0 and self.current_value[-1] in ['+', '-', '*', '/']:
                self.current_value = self.current_value[:-1] + text
            else:
                self.current_value += text
        else:
            self.current_value += text
        self.input_field.setText(self.current_value)

    def button_clicked(self):
        button = self.sender()
        text = button.text()

        if text == '=':
            try:
                if self.last_pressed == '=' and self.last_operator and self.second_operand is not None:
                    expression = f"{self.current_value}{self.last_operator}{self.second_operand}"
                else:
                    expression = self.current_value
                    for op in ['+', '-', '*', '/']:
                        if op in expression:
                            parts = expression.rsplit(op, 1)
                            if len(parts) == 2 and parts[1].strip():
                                self.last_operator = op
                                self.second_operand = parts[1].strip()
                                break
                result = eval(expression)
                result = round(result, 6)
                result = "{:.13g}".format(Decimal(str(result)))
                self.input_field.setText(result)
                self.current_value = str(result)
                self.last_pressed = '='
                self.save_history(expression, result)
            except Exception:
                self.input_field.setText('Error')
                self.current_value = ''
                self.last_operator = None
                self.second_operand = None
                self.last_pressed = None

        elif text == 'C':
            self.input_field.clear()
            self.current_value = ''
            self.input_field.setText('0')
            self.last_pressed = None
            self.last_operator = None
            self.second_operand = None

        elif text in ['+', '-', '*', '/']:
            if self.last_pressed == '=':
                self.last_operator = None
                self.second_operand = None
            self.symbdup(text)
            self.last_pressed = text

        elif text == '÷':
            if self.last_pressed == '=':
                self.last_operator = None
                self.second_operand = None
            self.symbdup('/')
            self.last_pressed = '/'

        elif text == '−':
            if self.last_pressed == '=':
                self.last_operator = None
                self.second_operand = None
            self.symbdup('-')
            self.last_pressed = '-'

        elif text == '×':
            if self.last_pressed == '=':
                self.last_operator = None
                self.second_operand = None
            self.symbdup('*')
            self.last_pressed = '*'

        elif text == '+/-':
            if self.current_value:
                if self.current_value.startswith('-'):
                    self.current_value = self.current_value[1:]
                else:
                    self.current_value = '-' + self.current_value
                self.input_field.setText(self.current_value)

        elif text == '%':
            self.symbdup('/100')

        else:
            if self.last_pressed == '=':
                self.current_value = ''
                self.last_operator = None
                self.second_operand = None

            if self.current_value == '0' and text not in ['.', '00']:
                self.current_value = text
            else:
                self.current_value += text
            self.input_field.setText(self.current_value)
            self.last_pressed = text

if __name__ == '__main__':
    app = QApplication(sys.argv)
    calculator = Calculator()
    calculator.show()
    sys.exit(app.exec_())
