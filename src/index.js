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

// Define the /users route
app.get('/users', (req, res) => {
  const { userid } = req.query;

  let query = 'SELECT * FROM User';
  const params = [];

  if (userid) {
    query += ' WHERE id = ?';
    params.push(userid);
  }

  db.all(query, params, (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.json(rows);
  });
});

// Define the /exchanges route
app.get('/exchanges', (req, res) => {
  const query = `
    SELECT 
      e.id,
      e.longitude,
      e.lattitude,
      e.CityId,
      e.ImageURL,
      e.userId,
      e.doDeliver,
      e.address1,
      e.address2,
      e.address3,
      e.address4,
      e.zipcode,
      c.name as cityName,
      u.username as userName,
      (
        SELECT json_group_array(json_object(
          'id', er.id,
          'userId', er.userId,
          'base_currency_id', er.base_currency_id,
          'base_currency_name', bc.name,
          'quote_currency_id', er.quote_currency_id,
          'quote_currency_name', qc.name,
          'commissionPercentage', er.commissionPercentage,
          'deliveryCommissionPercentage', er.deliveryCommissionPercentage,
          'deliveryCommissionFlat', er.deliveryCommissionFlat,
          'baseExchangeRateId', er.baseExchangeRateId,
          'commissionFlat', er.commissionFlat,
          'timestamp', er.timestamp,
          'baseRateValue', br.value,
          'baseRateName', br.name
        ))
        FROM ExchangeRate er
        JOIN BaseExchangeRate br ON er.baseExchangeRateId = br.id
        JOIN Currency bc ON er.base_currency_id = bc.id
        JOIN Currency qc ON er.quote_currency_id = qc.id
        WHERE er.userId = e.userId
      ) as exchangeRates
    FROM Exchange e
    JOIN City c ON e.CityId = c.id
    JOIN User u ON e.userId = u.id
  `;

  db.all(query, [], (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }

    // Parse the JSON string in exchangeRates to avoid double encoding
    const formattedRows = rows.map(row => {
      return {
        ...row,
        exchangeRates: JSON.parse(row.exchangeRates)
      };
    });

    res.setHeader('Content-Type', 'application/json');
    res.send(JSON.stringify(formattedRows, null, 2));
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
