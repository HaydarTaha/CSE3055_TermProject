CREATE VIEW vw_SortedServices AS
SELECT s.ServiceDate, p1.FullName AS CustomerName, p.FullName AS EmployeeName, s.Type, s.ServiceFee
FROM Service s
INNER JOIN Customer c ON c.CustomerID = s.ServiceCustomerID
INNER JOIN Employee e ON e.EmployeeID = s.ServiceEmployeeID
INNER JOIN Person p ON p.TRIdentifyNo = e.TRIdentifyNo
INNER JOIN PERSON p1 ON p1.TRIdentifyNo = c.TRIdentifyNo

--SELECT * FROM vw_SortedServices ORDER BY ServiceDate, CustomerName, EmployeeName, Type, ServiceFee