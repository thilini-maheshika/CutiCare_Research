const mysql = require('mysql2');
const config = require('./config');

const connection = mysql.createConnection(config.connection);

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the database!');
});

module.exports = {
    connection,
    config
};