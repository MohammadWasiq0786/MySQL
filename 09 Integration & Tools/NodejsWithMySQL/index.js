const mysql = require('mysql2');

// Create connection
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'admin123456@', // replace with your MySQL password
  database: 'tra'          // replace with your database name
});

// Connect
connection.connect(err => {
  if (err) {
    console.error('Error connecting:', err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + connection.threadId);
});

// Query example
connection.query('SELECT NOW()', (err, results) => {
  if (err) throw err;
  console.log('Current Time:', results[0]);
});


connection.query('select * from tra.accounts where id = 1',(err,results)=>{
    if(err) throw err;
    console.log('account records from accounts table in tra database' , results)
});

// Close connection
connection.end();
