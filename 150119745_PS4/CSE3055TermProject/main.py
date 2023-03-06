import pyodbc
import sys
from PyQt6 import QtCore, QtGui, QtWidgets
from PyQt6 import uic

# Haydar Taha Tunç 150119745
# Burak Dursun 150119743
# Emir Ege Eren 150119739

sql_connect = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server}; SERVER=localhost; DATABASE=IPEKSUARITMADATABASE; UID=Taha; PWD=Tahatunc2142')
cursor = sql_connect.cursor()


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        uic.loadUi("mainwindow.ui", self)
        self.setWindowIcon(QtGui.QIcon('ipek.png'))

        # Set Installment
        self.combo_Installment = self.findChild(QtWidgets.QComboBox, 'installment')
        self.add_installments()

        # Set Date To UI
        current_date = QtWidgets.QDateEdit()
        current_date.setDate(QtCore.QDate.currentDate())
        self.sale_Date = self.findChild(QtWidgets.QDateEdit, 'saleDate')
        self.sale_Date.setDate(QtCore.QDate.currentDate())

        # All products in database
        self.product_list = []

        # Set Products For Sale
        self.add_product_sale_button = self.findChild(QtWidgets.QPushButton, 'addProductSaleButton')
        # Connecting button with method
        self.add_product_sale_button.clicked.connect(self.add_sale_product_button_clicked)
        self.combo_sale_product = self.findChild(QtWidgets.QComboBox, 'productNamesForSale')
        self.combo_sale_product_count = self.findChild(QtWidgets.QComboBox, 'productCountSale')
        self.add_sale_product_to_combo()

        # All Employee in Database
        self.employee_list = []
        self.employee_combo = self.findChild(QtWidgets.QComboBox, 'saleEmployeeComboBox')
        self.add_employee()

        # Insert Values to Database
        self.sale_customer_push_button = self.findChild(QtWidgets.QPushButton, 'saleCustomerPushButton')
        # Connecting button with method
        self.sale_customer_push_button.clicked.connect(self.insert_value_to_database)

        # Product list for sale
        self.product_for_sale = []
        self.product_for_sale_count = []

        # Set Sale Type Combo Box
        self.add_sale_type_to_combo()

        # Get stock For Product List
        self.stock_product_list = []
        self.get_stock()
        self.get_stock_button = self.findChild(QtWidgets.QPushButton, 'getStockButton')
        self.get_stock_button.clicked.connect(self.get_stock_button_clicked)

        # Update stock
        self.update_stock_button = self.findChild(QtWidgets.QPushButton, 'stockUpdatePushButton')
        self.update_stock_button.clicked.connect(self.update_stock)

    def add_employee(self):
        cursor.execute('SELECT p.FullName FROM EMPLOYEE AS e, PERSON AS p WHERE e.TRIdentifyNo = p.TRIdentifyNo ORDER BY e.EmployeeID ASC')
        results = cursor.fetchall()
        for result in results:
            result = str(result).replace('(', '')
            result = str(result).replace(')', '')
            result = str(result).replace("'", '')
            result = str(result).replace(',', '')
            index = int(len(result) - 1)
            result = result[:index] + result[index + 1:]
            self.employee_list.append(result)
            self.employee_combo.addItem(str(result))

    def add_installments(self):
        i = 1
        while i < 13:
            self.combo_Installment.addItem(str(i))
            i = i + 1

    def add_sale_product_button_clicked(self):
        product_list_label = self.findChild(QtWidgets.QLabel, 'saleProductList')
        product_list_item = self.findChild(QtWidgets.QLabel, 'saleProduct1')
        if len(str(product_list_label.text())) == 0:
            product_list_label.setText('Product List: ')
            product_list_str = self.combo_sale_product.currentText() + ': ' + self.combo_sale_product_count.currentText()
            product_list_item.setText(product_list_str)
        else:
            product_list_str = self.combo_sale_product.currentText() + ': ' + self.combo_sale_product_count.currentText()
            product_list_item.setText(product_list_str)
        self.product_for_sale.append(self.combo_sale_product.currentText())
        self.product_for_sale_count.append(self.combo_sale_product_count.currentText())

    def insert_value_to_database(self):
        # For Person Table
        tr_identify_no = self.findChild(QtWidgets.QLineEdit, 'saleTrIdentifyNo')
        address = self.findChild(QtWidgets.QTextEdit, 'saleCustomerAddress')
        email = self.findChild(QtWidgets.QLineEdit, 'saleCustomerEmail')
        first_name = self.findChild(QtWidgets.QLineEdit, 'saleFirstName')
        last_name = self.findChild(QtWidgets.QLineEdit, 'saleLastName')

        # Insert values to Person Table
        insert_sale_person_str = str("INSERT INTO PERSON(TRIdentifyNo, Address, Email, FirstName, LastName) VALUES( '{}', '{}', '{}', '{}', '{}')".format(tr_identify_no.text(), address.toPlainText(), email.text(), first_name.text(), last_name.text()))
        print(insert_sale_person_str)
        cursor.execute(insert_sale_person_str)

        # For Customer Table
        region = self.findChild(QtWidgets.QSpinBox, 'saleCustomerRegion')
        description = self.findChild(QtWidgets.QTextEdit, 'saleCustomerDescription')
        # Insert values to Customer Table
        insert_sale_customer_str = str("INSERT INTO CUSTOMER(TRIdentifyNo, Region, Description) VALUES ('{}', '{}', '{}')".format(tr_identify_no.text(), region.value(), description.toPlainText()))
        print(insert_sale_customer_str)
        cursor.execute(insert_sale_customer_str)
        sql_connect.commit()

        # Get CustomerId From Database
        customer_id_query = str("SELECT CustomerID FROM CUSTOMER WHERE CUSTOMER.TRIdentifyNo = '{}'".format(tr_identify_no.text()))
        cursor.execute(customer_id_query)
        customer_id_temp = cursor.fetchall()
        customer_id = str()
        for result in customer_id_temp:
            result = str(result).replace('(', '')
            result = str(result).replace(')', '')
            result = str(result).replace(',', '')
            result = str(result).replace(' ', '')
            customer_id = result

        # Insert Phone Number To DataBase
        phone_number = self.findChild(QtWidgets.QLineEdit, 'saleCustomerPhoneNumber')
        phone_number_text = phone_number.text()
        phone_number_text = str(phone_number_text).replace('(', '')
        phone_number_text = str(phone_number_text).replace(')', '')
        phone_number_text = str(phone_number_text).replace(',', '')
        phone_number_text = str(phone_number_text).replace(' ', '')
        insert_phone_number_query = str("INSERT INTO PHONENUMBER(CustomerID, PhoneNumber) VALUES ({}, '{}')".format(customer_id, phone_number_text))
        cursor.execute(insert_phone_number_query)
        sql_connect.commit()

        # Insert query for SALES Table
        sale_price = self.findChild(QtWidgets.QLineEdit, 'saleCustomerPrice')
        number_of_installment = self.combo_Installment.currentText()
        sale_date = self.sale_Date.text()
        sale_description = self.findChild(QtWidgets.QTextEdit, 'SaleDescriptionTextEdit')
        sale_type = self.findChild(QtWidgets.QComboBox, 'saleTypeComboBox')
        sale_customer_id = customer_id
        sale_employee_name = self.employee_combo.currentText()
        sale_employee_id = str()
        count = 1
        for employee in self.employee_list:
            if sale_employee_name == employee:
                sale_employee_id = count
                count = 0
                break
            count = count + 1
        sale_insert_query = str("INSERT INTO SALES(SalePrice, NumberOfInstallment, SaleDate, SaleDescription, SaleType, SaleCustomerID, SaleEmployeeID)VALUES ({}, {}, '{}', '{}', '{}', {}, {})".format(sale_price.text(), number_of_installment, sale_date, sale_description.toPlainText(), sale_type.currentText(), sale_customer_id, sale_employee_id))
        cursor.execute(sale_insert_query)
        sql_connect.commit()

        # Get ContractNumber From Database
        contract_id_query = str("SELECT s.ContractNumber FROM SALES s ORDER BY s.ContractNumber DESC")
        cursor.execute(contract_id_query)
        contract_id_temp = cursor.fetchall()
        contract_id = str()
        for result in contract_id_temp:
            result = str(result).replace('(', '')
            result = str(result).replace(')', '')
            result = str(result).replace(',', '')
            result = str(result).replace(' ', '')
            contract_id = result
            break

        for i in range(len(self.product_for_sale)):
            product_id = self.product_list.index(self.product_for_sale[i]) + 1
            product_count = self.product_for_sale_count[i]
            # Insert Sale Products to database
            sale_product_insert = str("INSERT INTO SALESPRODUCT(SaleContractNumber, ProductID, COUNT) VALUES ({}, {}, {})".format(contract_id, product_id, product_count))
            cursor.execute(sale_product_insert)
            sql_connect.commit()

    def add_sale_type_to_combo(self):
        sale_type = self.findChild(QtWidgets.QComboBox, 'saleTypeComboBox')
        sale_type.addItem(str('Cash'))
        sale_type.addItem(str('Credit Card'))

    def add_sale_product_to_combo(self):
        cursor.execute('SELECT p.ProductName FROM PRODUCTS p')
        results = cursor.fetchall()
        size = len(results)
        for result in results:
            string_result = str(result)
            string_result = str(string_result).replace('(', '')
            string_result = str(string_result).replace(')', '')
            string_result = str(string_result).replace(',', '')
            string_result = str(string_result).replace("'", '')
            index = int(len(string_result) - 1)
            string_result = string_result[:index] + string_result[index + 1:]
            self.combo_sale_product.addItem(str(string_result))
            self.product_list.append(string_result)

        for i in range(len(results)):
            self.combo_sale_product_count.addItem(str(int(i + 1)))

    def get_stock(self):
        stock_product = self.findChild(QtWidgets.QComboBox, 'comboBoxStockProduct')
        cursor.execute('SELECT p.ProductName FROM PRODUCTS p')
        results = cursor.fetchall()
        for result in results:
            string_result = str(result)
            string_result = str(string_result).replace('(', '')
            string_result = str(string_result).replace(')', '')
            string_result = str(string_result).replace(',', '')
            string_result = str(string_result).replace("'", '')
            index = int(len(string_result) - 1)
            string_result = string_result[:index] + string_result[index + 1:]
            stock_product.addItem(str(string_result))
            self.stock_product_list.append(str(string_result))

    def get_stock_button_clicked(self):
        product_name_stock = self.findChild(QtWidgets.QLabel, 'productNameStock')
        combo_box_index = self.findChild(QtWidgets.QComboBox, 'comboBoxStockProduct').currentIndex()
        product_name_stock.setText(self.stock_product_list[combo_box_index])
        cursor.execute("SELECT p.ProductId FROM PRODUCTS p WHERE p.ProductName = '{}'".format(self.stock_product_list[combo_box_index]))
        results = cursor.fetchall()
        product_id = str()
        for result in results:
            string_result = str(result)
            string_result = str(string_result).replace('(', '')
            string_result = str(string_result).replace(')', '')
            string_result = str(string_result).replace(',', '')
            string_result = str(string_result).replace("'", '')
            product_id = string_result
        cursor.execute("SELECT s.StockCount FROM STOCK s WHERE s.StockProductID = '{}'".format(product_id))
        results = cursor.fetchall()
        product_stock = str()
        for result in results:
            string_result = str(result)
            string_result = str(string_result).replace('(', '')
            string_result = str(string_result).replace(')', '')
            string_result = str(string_result).replace(',', '')
            string_result = str(string_result).replace("'", '')
            product_stock = string_result
        stock_name_stock = self.findChild(QtWidgets.QLabel, 'stockNameStock')
        stock_name_stock.setText(product_stock)

    def update_stock(self):
        stock_line = self.findChild(QtWidgets.QLineEdit, 'lineEditStock')
        new_stock = stock_line.text()
        combo_box_index = self.findChild(QtWidgets.QComboBox, 'comboBoxStockProduct').currentIndex()
        cursor.execute("SELECT p.ProductId FROM PRODUCTS p WHERE p.ProductName = '{}'".format(self.stock_product_list[combo_box_index]))
        results = cursor.fetchall()
        product_id = str()
        for result in results:
            string_result = str(result)
            string_result = str(string_result).replace('(', '')
            string_result = str(string_result).replace(')', '')
            string_result = str(string_result).replace(',', '')
            string_result = str(string_result).replace("'", '')
            product_id = string_result
        stock_update_query = str("UPDATE STOCK SET StockCount = {} WHERE StockProductID = {}".format(new_stock, product_id))
        cursor.execute(stock_update_query)
        sql_connect.commit()
        stock_name_stock = self.findChild(QtWidgets.QLabel, 'stockNameStock')
        stock_name_stock.setText(new_stock)

app = QtWidgets.QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()