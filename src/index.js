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
