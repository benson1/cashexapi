require('dotenv').config();
const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const app = express();
const port = process.env.PORT || 3000;

// Path to the SQLite database file
const dbPath = path.resolve('/usr/src/app/data/database.sqlite');

// Initialize SQLite database
const db = new sqlite3.Database(dbPath);

// Read and execute the SQL schema file
const schemaPath = path.resolve('/usr/src/app/schema.sql');
const schema = fs.readFileSync(schemaPath, 'utf-8');

db.serialize(() => {
  db.exec(schema, (err) => {
    if (err) {
      console.error('Error executing SQL schema:', err.message);
    } else {
      console.log('Database initialized successfully');
    }
  });
});

// Define a route
app.get('/', (req, res) => {
  db.all('SELECT * FROM User', [], (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.json(rows);
  });
});

// Define /exchanges route
app.get('/exchanges', (req, res) => {
  const query = `
    SELECT 
      Exchange.*,
      City.name AS cityName,
      User.username AS userName,
      (
        SELECT json_group_array(json_object(
          'id', ExchangeRate.id,
          'userId', ExchangeRate.userId,
          'base_currency_id', ExchangeRate.base_currency_id,
          'base_currency_name', baseCurrency.name,
          'quote_currency_id', ExchangeRate.quote_currency_id,
          'quote_currency_name', quoteCurrency.name,
          'commissionPercentage', ExchangeRate.commissionPercentage,
          'baseExchangeRateId', ExchangeRate.baseExchangeRateId,
          'commissionFlat', ExchangeRate.commissionFlat,
          'timestamp', ExchangeRate.timestamp,
          'baseRateValue', printf("%.5f", BaseExchangeRate.value),
          'baseRateName', BaseExchangeRate.name
        ))
        FROM ExchangeRate
        JOIN BaseExchangeRate ON ExchangeRate.baseExchangeRateId = BaseExchangeRate.id
        JOIN Currency baseCurrency ON ExchangeRate.base_currency_id = baseCurrency.id
        JOIN Currency quoteCurrency ON ExchangeRate.quote_currency_id = quoteCurrency.id
        WHERE ExchangeRate.userId = Exchange.userId
      ) AS exchangeRates
    FROM 
      Exchange
    JOIN 
      City ON Exchange.CityId = City.id
    JOIN 
      User ON Exchange.userId = User.id
  `;

  db.all(query, [], (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    // Parse the JSON strings to remove backslashes
    rows.forEach(row => {
      row.exchangeRates = JSON.parse(row.exchangeRates);
    });
    res.json(rows);
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// Close the database connection when the app terminates
process.on('SIGINT', () => {
  db.close(() => {
    console.log('Database connection closed');
    process.exit(0);
  });
});
