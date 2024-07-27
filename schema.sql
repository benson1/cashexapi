-- Modify User Table
DROP TABLE IF EXISTS User;
CREATE TABLE User (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  phone_number VARCHAR,
  email VARCHAR,
  pref_currency_id INTEGER,
  is_verified_email BIT DEFAULT 0,  -- New field for email verification status
  verification_token VARCHAR,  -- Field to store verification token
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  language VARCHAR NOT NULL DEFAULT 'en', -- New field for language with default value 'en'
  current_longitude DOUBLE, -- New field for current longitude
  current_latitude DOUBLE, -- New field for current latitude
  current_postcode VARCHAR(10), -- New field for current postcode (adjust length as needed)
  current_address VARCHAR -- New field for current address (adjust size as needed)
);

-- Update existing user data to set pref_currency_id to 2 and populate new fields
UPDATE User SET 
  pref_currency_id = 2,
  language = 'en';

-- ---
-- Table 'Exchange'
-- ---
DROP TABLE IF EXISTS Exchange;
CREATE TABLE Exchange (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  longitude DOUBLE,
  lattitude DOUBLE,
  CityId INTEGER,
  ImageURL VARCHAR,
  userId INTEGER,
  doDeliver BIT,
  address1 VARCHAR,
  address2 VARCHAR,
  address3 VARCHAR,
  address4 VARCHAR,
  zipcode VARCHAR
);

-- ---
-- Table 'Offer'
-- ---
DROP TABLE IF EXISTS Offer;
CREATE TABLE Offer (
  id INTEGER PRIMARY KEY AUTOINCREMENT
);

-- ---
-- Table 'ExchangeCurrency'
-- ---
DROP TABLE IF EXISTS ExchangeCurrency;
CREATE TABLE ExchangeCurrency (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  base_rate INTEGER
);

-- ---
-- Table 'Currency'
-- ---
DROP TABLE IF EXISTS Currency;
CREATE TABLE Currency (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR NOT NULL,
  countryId INTEGER NOT NULL
);

-- ---
-- Table 'Country'
-- ---
DROP TABLE IF EXISTS Country;
CREATE TABLE Country (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR NOT NULL
);

-- ---
-- Table 'Rating'
-- ---
DROP TABLE IF EXISTS Rating;
CREATE TABLE Rating (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER,
  rater_userid INTEGER,
  score INTEGER,
  description VARCHAR
);

-- ---
-- Table 'Person'
-- ---
DROP TABLE IF EXISTS Person;
CREATE TABLE Person (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER,
  ImageUrl VARCHAR,
  longitude DOUBLE NOT NULL,
  lattitude INTEGER
);

-- ---
-- Table 'BaseExchangeRate'
-- ---
DROP TABLE IF EXISTS BaseExchangeRate;
CREATE TABLE BaseExchangeRate (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  value DOUBLE NOT NULL,
  name VARCHAR NOT NULL,
  currency1 INTEGER NOT NULL,
  currency2 INTEGER NOT NULL
);

-- ---
-- Table 'ExchangeRate'
-- ---
DROP TABLE IF EXISTS ExchangeRate;
CREATE TABLE ExchangeRate (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  exchangeId INTEGER,
  base_currency_id INTEGER NOT NULL,
  quote_currency_id INTEGER NOT NULL,
  commissionPercentage DECIMAL,
  baseExchangeRateId INTEGER,
  commissionFlat DOUBLE,
  timestamp DATETIME,
  deliveryCommissionPercentage DECIMAL,
  deliveryCommissionFlat DOUBLE
);

-- ---
-- Table 'SnapshotExchangeRate'
-- ---
DROP TABLE IF EXISTS SnapshotExchangeRate;
CREATE TABLE SnapshotExchangeRate (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  exchangeId INTEGER,
  base_currency_id INTEGER NOT NULL,
  quote_currency_id INTEGER NOT NULL,
  commissionPercentage DECIMAL,
  baseExchangeRateId INTEGER,
  commissionFlat DOUBLE,
  timestamp DATETIME,
  deliveryCommissionPercentage DECIMAL,
  deliveryCommissionFlat DOUBLE
);

-- ---
-- Table 'UserTransaction'
-- ---
DROP TABLE IF EXISTS UserTransaction;
CREATE TABLE UserTransaction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sellerUserId INTEGER NOT NULL,
  buyerUserId INTEGER NOT NULL,
  stageId INTEGER NOT NULL,
  markedCompletedUser1 BIT NOT NULL DEFAULT 0,
  markedCompletedUser2 BIT NOT NULL DEFAULT 0,
  SnapshotExchangeRateId INTEGER,
  amountCncy1 DECIMAL,
  amountCncy2 DECIMAL
);

-- ---
-- Table 'StageTransaction'
-- ---
DROP TABLE IF EXISTS StageTransaction;
CREATE TABLE StageTransaction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  StageName VARCHAR,
  StageDescription VARCHAR
);

-- ---
-- Table 'MeetingPoint'
-- ---
DROP TABLE IF EXISTS MeetingPoint;
CREATE TABLE MeetingPoint (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionId INTEGER NOT NULL,
  longitude DOUBLE NOT NULL,
  lattitude DOUBLE NOT NULL,
  address VARCHAR,
  extraDescription VARCHAR,
  agreedTime DATETIME,
  zipcode VARCHAR
);

-- ---
-- Table 'City'
-- ---
DROP TABLE IF EXISTS City;
CREATE TABLE City (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR NOT NULL,
  countryId INTEGER NOT NULL
);

-- Insert sample data (optional)
INSERT INTO User (username, password, phone_number, email, pref_currency_id, language) VALUES 
('John Doe', 'encryptedpassword1', '+447402963264', 'finnbenson99@gmail.com', 2, 'en'),
('Mick Smith', 'encryptedpassword2', '987-654-3210', 'mick@example.com', 2, 'en');

INSERT INTO Country (id, name) VALUES (1, 'Vietnam');
INSERT INTO Country (id, name) VALUES (2, 'USA');
INSERT INTO Country (id, name) VALUES (3, 'Thailand');

INSERT INTO City (id, name, countryId) VALUES (1, 'Da Nang', 3);
INSERT INTO City (id, name, countryId) VALUES (2, 'Chiang Mai', 3);

INSERT INTO Currency (id, name, countryId) VALUES (1, 'vnd', 1);
INSERT INTO Currency (id, name, countryId) VALUES (2, 'usd', 2);
INSERT INTO Currency (id, name, countryId) VALUES (3, 'thb', 3);

INSERT INTO BaseExchangeRate (id, value, name, currency1, currency2) VALUES (1, 0.000039, 'VND to USD', 1, 2);
INSERT INTO BaseExchangeRate (id, value, name, currency1, currency2) VALUES (2, 25440.00, 'USD to VND', 2, 1);
INSERT INTO BaseExchangeRate (id, value, name, currency1, currency2) VALUES (3, 36.36, 'USD to THB', 2, 3);
INSERT INTO BaseExchangeRate (id, value, name, currency1, currency2) VALUES (4, 36.36, 'THB to USD', 3, 2);

INSERT INTO Exchange (id, longitude, lattitude, CityId, ImageURL, userId, doDeliver, address1, address2, address3, address4, zipcode) VALUES 
(1, 108.1888586, 16.0549603, 1, 'https://t4.ftcdn.net/jpg/04/77/58/01/240_F_477580156_wXUaajTfUOLwpWOOP3CuMGimx88DNFIv.jpg', 1, 1, 'Đường Phần Lăng 14', 'Thanh Khê District', 'Đà Nẵng', 'Vietnam', '550000'),
(2, 108.22083, 16.06778, 1, 'https://cash.jp/images/logo.png', 2, 0, '121 Trần Phú', 'Hải Châu', 'Đà Nẵng', 'Vietnam', '550000'),
(3, 98.99308013916016, 18.78816032409668, 2, 'https://example.com/image.jpg', 1, 1, 'Address1', 'Address2', 'Address3', 'Address4', '550000');

INSERT INTO ExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (1, 1, 1, 2, 1.8, 1, 0, CURRENT_TIMESTAMP, 10.2, 0.5);
INSERT INTO ExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (5, 1, 2, 1, 1.8, 1, 0, CURRENT_TIMESTAMP, 10.2, 0.5);
INSERT INTO ExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (2, 2, 1, 2, 3.1, 2, 0, CURRENT_TIMESTAMP, 0, 0.0);
INSERT INTO ExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (6, 2, 2, 1, 3.1, 2, 0, CURRENT_TIMESTAMP, 0, 0.0);
INSERT INTO ExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (3, 3, 2, 3, 2.2, 3, 0, CURRENT_TIMESTAMP, 10.2, 0.5);
INSERT INTO ExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (4, 3, 3, 2, 2.2, 4, 0, CURRENT_TIMESTAMP, 11.2, 0.5);

INSERT INTO Person (id, userId, ImageUrl, longitude, lattitude) VALUES (1, 1, 'https://example.com/image1.jpg', 108.1888586, 16.0549603),
(2, 2, 'https://example.com/image2.jpg', 108.22083, 16.06778);

INSERT INTO SnapshotExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (1, 1, 1, 2, 1.8, 1, 0, CURRENT_TIMESTAMP, 10.2, 0.5);
INSERT INTO SnapshotExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (2, 2, 2, 1, 3.1, 2, 0, CURRENT_TIMESTAMP, 0, 0.0);
INSERT INTO SnapshotExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (3, 3, 2, 3, 2.2, 3, 0, CURRENT_TIMESTAMP, 10.2, 0.5);
INSERT INTO SnapshotExchangeRate (id, exchangeId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp, deliveryCommissionPercentage, deliveryCommissionFlat) VALUES (4, 3, 3, 2, 2.2, 4, 0, CURRENT_TIMESTAMP, 11.2, 0.5);

INSERT INTO UserTransaction (id, sellerUserId, buyerUserId, stageId, markedCompletedUser1, markedCompletedUser2, SnapshotExchangeRateId, amountCncy1, amountCncy2) VALUES (1, 1, 2, 1, 0, 0, 1, 1000000, 40),
(2, 2, 1, 1, 0, 0, 2, 40, 1000000);

INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (1, 'Initiated', 'Transaction initiated by user'),
(2, 'Completed', 'Transaction completed successfully');

INSERT INTO MeetingPoint (id, transactionId, longitude, lattitude, address, extraDescription, agreedTime, zipcode) VALUES (1, 1, 108.1888586, 16.0549603, 'Đường Phần Lăng 14', 'Near the park', '2024-07-20 14:00:00', '550000'),
(2, 2, 108.22083, 16.06778, '121 Trần Phú', 'In front of the coffee shop', '2024-07-21 16:00:00', '550000');

INSERT INTO City (id, name, countryId) VALUES (3, 'Bangkok', 3),
(4, 'New York', 2)
