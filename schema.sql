-- schema.sql

-- ---
-- Table 'User'
-- ---
DROP TABLE IF EXISTS User;
CREATE TABLE User (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username VARCHAR NOT NULL
);

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
  userId INTEGER,
  base_currency_id INTEGER NOT NULL,
  quote_currency_id INTEGER NOT NULL,
  commissionPercentage DECIMAL,
  baseExchangeRateId INTEGER,
  commissionFlat DOUBLE,
  timestamp DATETIME
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
  markedCompletedUser2 BIT NOT NULL DEFAULT 0
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
INSERT INTO User (username) VALUES ('John Doe');
INSERT INTO User (username) VALUES ('Mick Smith');

INSERT INTO Country (id, name) VALUES (1, 'Vietnam');
INSERT INTO Country (id, name) VALUES (2, 'USA');

INSERT INTO City (id, name, countryId) VALUES (1, 'Da Nang', 1);

INSERT INTO Currency (id, name, countryId) VALUES (1, 'vnd', 1);
INSERT INTO Currency (id, name, countryId) VALUES (2, 'usd', 2);

INSERT INTO BaseExchangeRate (id, value, name, currency1, currency2) VALUES (1, 0.000039, 'VND to USD', 1, 2);
INSERT INTO BaseExchangeRate (id, value, name, currency1, currency2) VALUES (2, 25440.00, 'USD to VND', 2, 1);

INSERT INTO ExchangeRate (id, userId, base_currency_id, quote_currency_id, commissionPercentage, baseExchangeRateId, commissionFlat, timestamp) VALUES (1, 1, 1, 2, 5.1, 1, 0, CURRENT_TIMESTAMP);

INSERT INTO Exchange (id, longitude, lattitude, CityId, ImageURL, userId, doDeliver, address1, address2, address3, address4, zipcode) VALUES (1, 108.1888586, 16.0549603, 1, 'https://cash.jp/images/logo.png', 1, 1, 'Đường Phần Lăng 14', 'Thanh Khê District', 'Đà Nẵng', 'Vietnam', '550000');

INSERT INTO Person (id, userId, ImageUrl, longitude, lattitude) VALUES (1, 2, 'https://www.pngitem.com/pimgs/m/87-879214_people-clipart-rich-man-the-broke-monopoly-man.png', 108.222060, 16.050850);

INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (1, 'Preconceived', 'the trade action is not yet initiated or proposed by either party');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (2, 'Proposed by buyer', 'the buyer has made a proposal to the seller');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (3, 'Proposed by seller', 'the seller has made a counter proposal to the buyer');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (4, 'Initiated', 'Agreed by both parties to fulfill transaction requirements');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (5, 'Processing', 'The transaction has been agreed by both parties, but is taking considerable time to complete');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (6, 'Seller Waiting', 'the seller is currently waiting for the other to arrive at the destination');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (7, 'Buyer Waiting', 'the buyer is currently waiting for the other to arrive at the destination');
INSERT INTO StageTransaction (id, StageName, StageDescription) VALUES (8, 'Completed', 'The transaction has been completed');

INSERT INTO UserTransaction (id, sellerUserId, buyerUserId, stageId, markedCompletedUser1, markedCompletedUser2) VALUES (1, 1, 2, 4, 0, 0);

INSERT INTO MeetingPoint (id, transactionId, longitude, lattitude, address, extraDescription, agreedTime, zipcode) VALUES (1, 1, 108.202040, 16.047079, '478 Điện Biên Phủ, Thanh Khê Đông, Thanh Khê, Đà Nẵng', 'KFC', '2024-06-29 01:00:00', '550000');

INSERT INTO Rating (id, userId, rater_userid, score, description) VALUES (1, 2, 1, 100, 'fantastic, quick, charming, friendly');
