CREATE VIEW vw_CustomerList
AS
    SELECT c.CustomerID, p.FullName, pn.PhoneNumber, p.Address
    FROM Customer c, PERSON P, PHONENUMBER pn
    WHERE c.TRIdentifyNo = p.TRIdentifyNo AND c.CustomerID = pn.CustomerID

--SELECT * FROM vw_CustomerList