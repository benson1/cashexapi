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
-- Table 'ExchangeRate'
-- ---
DROP TABLE IF EXISTS ExchangeRate;
CREATE TABLE ExchangeRate (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER,
  base_currency_id INTEGER NOT NULL,
  quote_currency_id INTEGER NOT NULL,
  commissionPercentage DECIMAL,
  exchangeRate DOUBLE,
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
  agreedTime DATETIME
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
