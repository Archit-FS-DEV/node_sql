const mysql = require('mysql2');
const { faker } = require('@faker-js/faker');

// Set up MySQL connection
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'your_password',
  database: 'dataase name'
});

// Function to establish a connection
function connectDB() {
  return new Promise((resolve, reject) => {
    connection.connect(err => {
      if (err) {
        reject('Error connecting to the database: ' + err.stack);
      } else {
        resolve('Connected to the database');
      }
    });
  });
}

// Function for bulk inserting fake data
async function insertFakeData() {
  try {
    const data = [];
    for (let i = 0; i < 400; i++) {
      data.push([
        faker.internet.email(),
        faker.date.past()
      ]);
    }
    
    const query = 'INSERT INTO node (email, created_At) VALUES ?';
    const [results] = await connection.promise().query(query, [data]);
    console.log(`${results.affectedRows} rows inserted`);
  } catch (err) {
    console.error('Error inserting data:', err);
  }
}

// Function to select the most recent record
async function selectMostRecent() {
  try {
    const query = 'SELECT email FROM node ORDER BY created_At DESC LIMIT 1';
    const [rows] = await connection.promise().query(query);
    console.log('Most recent email:', rows[0]?.email || 'No data found');
  } catch (err) {
    console.error('Error fetching the most recent record:', err);
  }
}

// Function to insert a single record
async function insertSingleRecord() {
  try {
    const person = { 
      email: faker.internet.email(), 
      created_At: faker.date.past() 
    };
    const query = 'INSERT INTO node SET ?';
    const [results] = await connection.promise().query(query, person);
    console.log(`Inserted single record with ID: ${results.insertId}`);
  } catch (err) {
    console.error('Error inserting single record:', err);
  }
}

// Main function to execute the different operations
async function main() {
  try {
    // Establish connection
    await connectDB();
    console.log('Connected to the database');

    // Perform the operations
    await insertFakeData();      // Insert multiple rows
    await selectMostRecent();    // Fetch the most recent email
    await insertSingleRecord();  // Insert a single record

  } catch (err) {
    console.error('Error in main process:', err);
  } finally {
    // Close the connection when done
    connection.end();
    console.log('Connection closed');
  }
}

// Run the main function
main();
