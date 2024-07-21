const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');
require('dotenv').config();

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

// Middleware for parsing JSON bodies
app.use(express.json());

// Create a Nodemailer transporter using Ethereal Email SMTP
const transporter = nodemailer.createTransport({
  host: 'smtp.ethereal.email',
  port: 587,
  auth: {
    user: 'thad92@ethereal.email', // Your Ethereal Email username
    pass: 'cDg5WGcA3MckuxGaxH'    // Your Ethereal Email password
  }
});

// Function to send verification email
function sendVerificationEmail(email, token) {
  const verificationLink = `http://localhost:3000/verify?token=${token}`;

  const mailOptions = {
    from: 'thad92@ethereal.email', // Sender address
    to: email,
    subject: 'Verify Your Email Address',
    html: `<p>Click <a href="${verificationLink}">here</a> to verify your email address.</p>`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log('Error sending email:', error);
    } else {
      console.log('Email sent:', info.response);
      console.log('View the message at:', nodemailer.getTestMessageUrl(info));
    }
  });
}

// Define the /register route for user registration
app.post('/register', async (req, res) => {
  const { username, password, email, phoneNumber } = req.body;

  try {
    // Generate a verification token
    const verificationToken = Math.random().toString(36).substring(7);

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert user details into the database
    db.run(
      'INSERT INTO User (username, password, email, phone_number, verification_token) VALUES (?, ?, ?, ?, ?)',
      [username, hashedPassword, email, phoneNumber, verificationToken],
      function (err) {
        if (err) {
          res.status(500).send(err.message);
          return;
        }

        // Send verification email
        sendVerificationEmail(email, verificationToken);

        // Return the newly created user ID
        res.json({ id: this.lastID });
      }
    );
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Define the /verify route for verifying email
app.get('/verify', (req, res) => {
  const { token } = req.query;

  // Update user record in database to mark email as verified
  db.run(
    'UPDATE User SET is_verified_email = 1 WHERE verification_token = ?',
    [token],
    function (err) {
      if (err) {
        res.status(500).send(err.message);
        return;
      }

      res.send('Email verified successfully');
    }
  );
});

// Define the /check-verification route to check if a user has verified their email
app.get('/check-verification', (req, res) => {
  const { userId } = req.query;

  db.get(
    'SELECT is_verified_email FROM User WHERE id = ?',
    [userId],
    (err, row) => {
      if (err) {
        res.status(500).send(err.message);
        return;
      }

      if (!row) {
        res.status(404).send('User not found');
        return;
      }

      res.json({ isVerified: row.is_verified_email === 1 });
    }
  );
});

// Define the login endpoint
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  db.get('SELECT * FROM User WHERE username = ?', [username], async (err, user) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }

    if (!user) {
      res.status(404).send('User not found');
      return;
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      res.status(401).send('Incorrect password');
      return;
    }

    if (!user.is_verified_email) {
      res.status(403).send('Email not verified');
      return;
    }

    res.send('Login successful');
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
