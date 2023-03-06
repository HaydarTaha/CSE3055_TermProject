--CREATE DATABASE IPEKSUARITMADATABASE

USE IPEKSUARITMADATABASE

CREATE TABLE PERSON(
    TRIdentifyNo VARCHAR(11) NOT NULL UNIQUE,
    Address NVARCHAR(100) NOT NULL,
    Email NVARCHAR(50) UNIQUE,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    FullName AS CONCAT(FirstName, ' ', LastName) PERSISTED
    PRIMARY KEY(TRIdentifyNo)
)
GO

CREATE TABLE PHONENUMBER(
    CustomerID INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY(CustomerID, PhoneNumber),
    UNIQUE(PhoneNumber)
)
GO

CREATE TABLE CUSTOMER(
    CustomerID INT NOT NULL IDENTITY(1,1) UNIQUE,
    TRIdentifyNo VARCHAR(11) NOT NULL UNIQUE,
    Region INT NOT NULL,
    Description NVARCHAR(50),
    PRIMARY KEY(CustomerID, TRIdentifyNo)
)
GO

CREATE TABLE EMPLOYEE(
    EmployeeID INT NOT NULL IDENTITY(1,1) UNIQUE,
    TRIdentifyNo VARCHAR(11) NOT NULL UNIQUE,
    Authority NVARCHAR(59) NOT NULL,
    SystemNumber NVARCHAR(15),
    IBAN VARCHAR(26) UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY(EmployeeID, TRIdentifyNo),
)
GO

CREATE TABLE SALES(
    SalePrice SMALLMONEY NOT NULL,
    NumberOfInstallment INT DEFAULT 1 CHECK(NumberOfInstallment >= 1),
    SaleDate SMALLDATETIME NOT NULL,
    ContractNumber INT NOT NULL IDENTITY(1, 1) UNIQUE,
    SaleDescription NVARCHAR(50),
    SaleType NVARCHAR(20) NOT NULL,
    SaleCustomerID INT NOT NULL,
    SaleEmployeeID INT NOT NULL,
    PRIMARY KEY(ContractNumber, SaleCustomerID, SaleEmployeeID)
)
GO

CREATE TABLE PRODUCTS(
    ProductID INT NOT NULL IDENTITY(1,1) UNIQUE,
    ProductName NVARCHAR(70) NOT NULL,
    ProductType NVARCHAR(75) NOT NULL,
    ProductPrice SMALLMONEY NOT NULL,
    WarrantyPeriod INT NOT NULL,
    DeviceProperties NVARCHAR(75),
    ProductSourceFirmID INT NOT NULL,
    PRIMARY KEY(ProductID)
)

CREATE TABLE STOCK(
    StockID INT NOT NULL IDENTITY(1,1) UNIQUE,
    StockCount INT NOT NULL,
    StockProductID INT NOT NULL,
    PRIMARY KEY(StockID, StockProductID)
)
GO

CREATE TABLE SALESPRODUCT(
    SaleContractNumber INT NOT NULL,
    ProductID INT NOT NULL,
    COUNT INT DEFAULT 1,
    PRIMARY KEY(SaleContractNumber, ProductID)
)
GO

CREATE TABLE SOURCEFIRM(
    FirmID INT NOT NULL IDENTITY(1,1) UNIQUE,
    FirmName NVARCHAR(50) NOT NULL,
    PRIMARY KEY(FirmID)
)
GO

CREATE TABLE LICENSE(
    LicenseID INT NOT NULL IDENTITY(1, 1) UNIQUE,
    LicenseDateOfValidity SMALLDATETIME NOT NULL,
    LicenseProductID INT NOT NULL UNIQUE,
    PRIMARY KEY(LicenseID, LicenseProductID)
)
GO

CREATE TABLE SERVICE(
    ServiceID INT NOT NULL IDENTITY(1,1) UNIQUE,
    ServiceDate SMALLDATETIME NOT NULL,
    Type INT NOT NULL,
    ServiceFee SMALLMONEY NOT NULL,
    NumberOfInstallment INT DEFAULT 1 CHECK(NumberOfInstallment >= 1),
    ServiceCustomerID INT NOT NULL,
    ServiceEmployeeID INT NOT NULL,
    PRIMARY KEY(ServiceID, ServiceCustomerID, ServiceEmployeeID)
)
GO

CREATE TABLE SERVICEPRODUCT(
    ServiceID INT NOT NULL,
    ProductID INT NOT NULL,
    COUNT INT DEFAULT 1,
    PRIMARY KEY(ServiceID, ProductID)
)
GO

CREATE TABLE SERVICEREQUEST(
    ServiceRequestID INT NOT NULL IDENTITY(1,1) UNIQUE,
    RequestDate SMALLDATETIME NOT NULL,
    Description INT,
    ServiceRequestCustomerID INT NOT NULL,
    PRIMARY KEY(ServiceRequestID, ServiceRequestCustomerID)
)
GO

CREATE TABLE SERVICEINSTALLMENT(
    InstallmentID INT NOT NULL IDENTITY(1,1) UNIQUE,
    InstallmentNumber INT NOT NULL,
    InstallmentExpiryDate SMALLDATETIME NOT NULL,
    InstallmentPrice SMALLMONEY NOT NULL,
    TotalInstallment INT NOT NULL CHECK(TotalInstallment >= 1),
    PaymentType NVARCHAR(20),
    Description NVARCHAR(70),
    PaymentDate SMALLDATETIME DEFAULT NULL,
    InstallmentServiceID INT NOT NULL,
    InstallmentCustomerID INT NOT NULL,
    PRIMARY KEY(InstallmentID, InstallmentServiceID, InstallmentCustomerID)
)
GO

CREATE TABLE SALESINSTALLMENT(
    InstallmentID INT NOT NULL IDENTITY(1,1) UNIQUE,
    InstallmentNumber INT NOT NULL,
    InstallmentExpiryDate SMALLDATETIME NOT NULL,
    InstallmentPrice SMALLMONEY NOT NULL,
    TotalInstallment INT NOT NULL CHECK(TotalInstallment >= 1),
    PaymentType NVARCHAR(20),
    Description NVARCHAR(70),
    PaymentDate SMALLDATETIME DEFAULT NULL,
    InstallmentContractNumber INT NOT NULL,
    InstallmentCustomerID INT NOT NULL,
    PRIMARY KEY(InstallmentID, InstallmentContractNumber, InstallmentCustomerID)
)
GO

CREATE TABLE LOGTABLE(
    LogID INT NOT NULL IDENTITY(1,1) UNIQUE,
    LogType VARCHAR(1) NOT NULL,
    LogDate SMALLDATETIME NOT NULL,
    LogDescription NVARCHAR(20) NOT NULL,
    PRIMARY KEY(LogID)
)