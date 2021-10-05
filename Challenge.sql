-- Matthew Coates, Student ID 103581210
-- MenuItem(ItemID,Descrtiption,ServesPerUnit,UnitPrice) PRIMARY KEY(ItemId)
-- Organisation(OrgId, OrganisationName) PRIMARY KEY(OrgId)
-- Client(ClientID,Name,Phone,OrgID) PRIMARY KEY(ClientID) FOREIGN KEY(OrgID) REFERENCES Organisation
-- Order(DateTimePlaced,DeliveryAddress,ClientID) COMPOSITE KEY(DateTimePLaced,ClientID) FOREIGN KEY(ClientID) References Client
-- OrderLine(Qty,ItemID,DateTimePlaced,ClientID) COMPOSITE KEY(ItemID,DateTimePlaced,ClientID) FOREIGN KEY(DateTimePlaced,ClientID) REFERENCES Order, FOREIGN KEY(ItemID) REFERENCES MenuItem
-- CREATE DATABASE BUILDCHALLENGE
-- USE BUILDCHALLENGE
DROP TABLE IF EXISTS OrderLine
DROP TABLE IF EXISTS [Order]
DROP TABLE IF EXISTS MenuItem
DROP TABLE IF EXISTS Client
DROP TABLE IF EXISTS Organisation
DROP VIEW IF EXISTS [Query 1]; 

CREATE TABLE Organisation(
    OrgId NVARCHAR(4) PRIMARY KEY,
    OrganisationName  NVARCHAR(200) UNIQUE NOT NULL, 
)

CREATE TABLE Client(
    ClientID INT PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(15) UNIQUE NOT NULL,
    OrgId NVARCHAR(4),
    CONSTRAINT FK_ORGID_ FOREIGN KEY(OrgId) REFERENCES Organisation(OrgId)
)

CREATE TABLE MenuItem(
    ItemID INT PRIMARY KEY,
    [Description] NVARCHAR(100) NOT NULL,
    ServesPerUnit INT NOT NULL CHECK(ServesPerUnit > 0),
    UnitPrice MONEY NOT NULL
)

CREATE TABLE [Order](
    ClientID INT,
    OrderDate DATE,
    DeliveryAddress NVARCHAR(Max),
    CONSTRAINT CK_ORDER_ PRIMARY KEY (ClientID,OrderDate),
    CONSTRAINT FK_ClientId_ FOREIGN KEY(ClientID) REFERENCES Client(ClientID)
)

CREATE TABLE OrderLine(
    ItemID INT,
    ClientID INT,
    OrderDate DATE,
    Qty Int CHECK(Qty >0),
    CONSTRAINT CK_OrderLine_ PRIMARY KEY(ItemId, ClientID,OrderDate),
    CONSTRAINT FK_ItemID_ FOREIGN KEY(ItemID) REFERENCES MenuItem(ItemID),
    CONSTRAINT FK_Order_ FOREIGN KEY (ClientID, OrderDate) REFERENCES [Order](ClientID,OrderDate)
)

insert into Organisation values ('DODG', 'Dod & Gy Widget Importers')
insert into Organisation values ('SWUT', 'Swinburne University of Technology')

insert into Client values (12, 'James Hallinan','(03)5555-1234','SWUT')
insert into Client values (15, 'Any Nguyen','(03)5555-2345','DODG')
insert into Client values (18, 'Karen Mok','(03)5555-3456','SWUT')
insert into Client values (21, 'Tim Baird','(03)5555-4567','DODG')
insert into Client Values (1,'Matthew Coates','(03)5555-1233','SWUT')

insert into MenuItem values (3214, 'Tropical Pizza - Large',2,16)
insert into MenuItem values (3216, 'Tropical Pizza - Small',1,12)
insert into MenuItem values (3218, 'Tropical Pizza - Family',4,23)
insert into MenuItem values (4325, 'Can - Coke Zero',1,2.5)
insert into MenuItem values (4326, 'Can - Lemonade',1,2.5)
insert into MenuItem values (4327, 'Can - Harden Up',1,7.5)

insert into [Order] values (12,'2021-09-20','Room TB225 - SUT - 1 John Street, Hawthorn, 3122')
insert into [Order] values (21,'2021-09-14','Room ATC009 - SUT - 1 John Street, Hawthorn, 3122')
insert into [Order] values (21,'2021-09-27','Room TB225 - SUT - 1 John Street, Hawthorn, 3122')
insert into [Order] values (15,'2021/09/20','The George - 1 John Street, Hawthorn, 3122')
insert into [Order] values (18,'2021-09-30','Room TB225 - SUT - 1 John Street, Hawthorn, 3122')

insert into OrderLine values (3216,12,'2021-09-20',2)
insert into OrderLine values (4326,12,'2021-09-20',1)
insert into OrderLine values (3218,21,'2021-09-14',1)
insert into OrderLine values (3214,21,'2021-09-14',1)
insert into OrderLine values (4325,21,'2021-09-14',4)
insert into OrderLine values (4327,21,'2021-09-14',2)
insert into OrderLine values (3216,21,'2021-09-27',1)
insert into OrderLine values (4327,21,'2021-09-27',1)
insert into OrderLine values (3218,21,'2021-09-27',2)
insert into OrderLine values (3216,15,'2021-09-20',2)
insert into OrderLine values (4326,15,'2021-09-20',1)
insert into OrderLine values (3216,18,'2021-09-30',1)
insert into OrderLine values (4327,18,'2021-09-30',1)

Select* From OrderLine

SELECT Organisation.OrganisationName,Orderline.ClientID,Orderline.OrderDate,[Order].DeliveryAddress,MenuItem.[Description],OrderLine.QTY
FROM (MenuItem INNER JOIN 
(OrderLine INNER JOIN
([Order]INNER JOIN
(Client INNER JOIN Organisation 
ON Client.OrgID = Organisation.OrgID) 
ON [Order].ClientID = Client.ClientID) 
ON Concat(OrderLine.OrderDate, OrderLine.ClientID) = Concat([Order].OrderDate, [Order].ClientID)) 
ON MenuItem.ItemID = OrderLine.ItemId)

Select Organisation.OrgId,MenuItem.[Description], SUM(Orderline.Qty) AS QTY
FROM 
Organisation INNER JOIN 
(Client INNER JOIN 
(Orderline INNER JOIN 
MenuItem ON 
OrderLine.ItemID = MenuItem.ItemID )
on Client.ClientID = OrderLine.ClientID) 
ON Organisation.OrgID = Client.OrgID 
GROUP BY Organisation.orgID,MenuItem.[Description]

Select MenuItem.ItemID, OrderLine.ClientID, OrderLine.OrderDate, OrderLine.Qty
From OrderLine 
INNER JOIN Menuitem 
ON (OrderLine.ItemID = MenuItem.ItemID)
WHERE MenuItem.ItemID = (Select Max(ItemID) From MenuItem)

Go
Create View [Query 1] AS 
SELECT Organisation.OrganisationName,Orderline.ClientID,Orderline.OrderDate,[Order].DeliveryAddress,MenuItem.[Description],OrderLine.QTY
FROM (MenuItem INNER JOIN 
(OrderLine INNER JOIN
([Order]INNER JOIN
(Client INNER JOIN Organisation 
ON Client.OrgID = Organisation.OrgID) 
ON [Order].ClientID = Client.ClientID) 
ON Concat(OrderLine.OrderDate, OrderLine.ClientID) = Concat([Order].OrderDate, [Order].ClientID)) 
ON MenuItem.ItemID = OrderLine.ItemId)

GO

Select * from [Query 1]

Select COUNT(*) from [Query 1]

Select Count(*) From OrderLine
-- total number of rows for both tables match, showing query 1 isn't missing or displaying extra rows

Select Count( DISTINCT ClientID) From [Query 1]

Select Count(ClientID) From Client
--total number of rows for each table match

Select DISTINCT DeliveryAddress From [Query 1]
Select DISTINCT DeliveryAddress From [Order]
--Any table (once filtered for duplicates) will contain the same data between the Database and View
Select OrgID FROM [Query 1]
--does not work as OrgID is NOT part of the query