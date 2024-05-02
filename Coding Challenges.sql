create database  CarRentalSystem

--creating tables
CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    [year] INT,
    dailyRate DECIMAL(10, 2),
    [status] VARCHAR(20),
    passengerCapacity INT,
    engineCapacity INT
);

CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(20)
);
CREATE TABLE Lease (
    leaseID INT PRIMARY KEY,
    vehicleID INT,
    customerID INT,
    startDate DATE,
    endDate DATE,
    leaseType VARCHAR(20),
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY,
    leaseID INT,
    paymentDate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
);
--Altering the table since i forgot to add earlier
ALTER TABLE Vehicle
ADD CONSTRAINT CHK_Status CHECK (status IN ('available', 'notAvailable'));
-- Alter the foreign key constraint between Customer and Lease tables
ALTER TABLE Lease
ADD CONSTRAINT FK_Lease_Customer FOREIGN KEY (customerID)
REFERENCES Customer(customerID)
ON DELETE CASCADE;
-- Alter the foreign key constraint between Lease and Payment tables
ALTER TABLE Payment
ADD CONSTRAINT FK_Payment_Lease FOREIGN KEY (leaseID)
REFERENCES Lease(leaseID)
ON DELETE CASCADE;


--Inserting values

INSERT INTO Vehicle (vehicleID, make, model, [year], dailyRate, [status], passengerCapacity, engineCapacity)
VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 'notAvailable', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 'available', 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 'notAvailable', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 'available', 4, 2500);


INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber)
VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');


INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType)
VALUES
(1, 1, 1, '2024-01-01', '2024-01-05', 'Daily'),
(2, 2, 2, '2024-02-15', '2024-02-28', 'Monthly'),
(3, 3, 3, '2024-03-10', '2024-03-15', 'Daily'),
(4, 4, 4, '2024-04-20', '2024-04-30', 'Monthly'),
(5, 5, 5, '2024-05-05', '2024-05-10', 'Daily'),
(6, 4, 3, '2024-06-15', '2024-06-30', 'Monthly'),
(7, 7, 7, '2024-07-01', '2024-07-10', 'Daily'),
(8, 8, 8, '2024-08-12', '2024-08-15', 'Monthly'),
(9, 3, 3, '2024-09-07', '2024-09-10', 'Daily'),
(10, 10, 10, '2024-10-10', '2024-10-31', 'Monthly');


INSERT INTO Payment (paymentID, leaseID, paymentDate, amount)
VALUES
(4, 4, '2024-04-25', 900.00),
(5, 5, '2024-05-07', 60.00),
(6, 6, '2024-06-18', 1200.00),
(7, 7, '2024-07-03', 40.00),
(8, 8, '2024-08-14', 1100.00),
(9, 9, '2024-09-09', 80.00),
(10, 10, '2024-10-25', 1500.00)


--1. Update the daily rate for a Mercedes car to 68
UPDATE Vehicle
SET dailyRate = 68
WHERE make = 'Mercedes';
--checking if the values are updated.
select * from Vehicle

--2. Delete a specific customer and all associated leases and payments
DELETE FROM Customer
WHERE customerID = 10;

--checking if the value is deleted.
select * from Payment;
select *from Customer;
select * from Lease;

--3.Rename the "paymentDate" column in the Payment table to "transactionDate"

EXEC sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN'
--4.. Find a specific customer by email.
select c.firstName ,c.lastName from Customer c
where email = 'laura@example.com'
--5. Get active leases for a specific customer.
select * from Lease
where customerID = 3
and endDate>='2023-01-01'
--6. Find all payments made by a customer with a specific phone number.
SELECT p.* 
FROM Payment p
JOIN Lease l ON p.leaseID = l.leaseID
JOIN Customer c ON l.customerID = c.customerID
WHERE c.phoneNumber = '555-789-1234';
--7. Calculate the average daily rate of all available cars
select avg(dailyRate) AS avgDailyRate
from Vehicle
where status='available'
--8. Find the car with the highest daily rate.
select model ,make from Vehicle
where dailyRate=(
select max(dailyRate) from Vehicle)
--9. Retrieve all cars leased by a specific customer.
select v.* from Vehicle v
join Lease l on l.vehicleID = v.vehicleID
where l.customerID = 1
--10. Find the details of the most recent lease.
SELECT TOP 1 *
FROM Lease
ORDER BY startDate DESC;
--11. List all payments made in the year 2023.
select *
from Payment
where YEAR(paymentDate) = 2024;
--12. Retrieve customers who have not made any payments.
select c.*
from Customer c
LEFT JOIN Lease l on c.customerID = l.customerID
Where l.customerID IS NULL;
--13. Retrieve Car Details and Their Total Payments.
select v.* , ISNULL(sum(p.amount),0)as totalPayments from Vehicle v
left join lease l on v.vehicleID = l.vehicleID
left join payment p on l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model, v.Year, v.dailyRate, V.status, v.passengerCapacity, v.engineCapacity;
--14. Calculate Total Payments for Each Customer.
select C.customerID, C.firstName, C.lastName,  COALESCE(SUM(P.amount),0) AS totalPayments
from Customer C
left join Lease L ON C.customerID = L.customerID
left join Payment P ON L.leaseID = P.leaseID
group by C.customerID, C.firstName, C.lastName;

--15. List Car Details for Each Lease.
select l.* , v.* from Lease l
inner join Vehicle v on l.vehicleID = v.vehicleID
--16. Retrieve Details of Active Leases with Customer and Car Information.
select L.*, C.firstName, C.lastName, V.make, V.model, V.year
from Lease L
join Customer C ON L.customerID = C.customerID
join Vehicle V ON L.vehicleID = V.vehicleID
where L.endDate > GETDATE();

--17. Find the Customer Who Has Spent the Most on Leases.
select top 1 c.customerID ,c.firstName , c.lastName , c.email , sum(p.Amount) as totalAMTspent from Customer c
join Lease l on c.customerID = l.customerID
join Payment p on l.leaseID = p.leaseID
group by c.customerID ,c.firstName , c.lastName , c.email
order by totalAMTspent DESC
--18. List All Cars with Their Current Lease Information.

WITH CurrentLease AS (
    SELECT vehicleID, MAX(startDate) AS maxStartDate
    FROM Lease
    GROUP BY vehicleID
)
SELECT V.*, L.*
FROM Vehicle V
LEFT JOIN Lease L ON V.vehicleID = L.vehicleID
INNER JOIN CurrentLease CL ON L.vehicleID = CL.vehicleID AND L.startDate = CL.maxStartDate;