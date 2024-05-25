const { connection } = require("../../../config/connection");
const bcrypt = require("bcrypt");

const UserModel = {
  getUserByUsernameAndPassword(username, password, callback) {
    connection.query(
      "SELECT * FROM user WHERE username = ? AND is_delete = 0",
      [username],
      (error, results) => {
        if (error) {
          callback(error, null);
          return;
        }

        if (results.length === 0) {
          // User with the provided username not found
          callback(null, null);
          return;
        }

        const storedPasswordHash = results[0].password;

        // Compare the provided password with the stored password hash using bcrypt
        bcrypt.compare(password, storedPasswordHash, (err, isMatch) => {
          if (err) {
            callback(err, null);
            return;
          }

          if (isMatch) {
            // Passwords match, return the user's data
            callback(null, results);
          } else {
            // Passwords do not match
            callback(null, null);
          }
        });
      }
    );
  },

  saveUserToken(userId, token, callback) {
    connection.query(
      "UPDATE user SET apitoken = ? WHERE userid = ?",
      [token, userId],
      callback
    );
  },

  getAll(callback) {
    connection.query(
      'SELECT * FROM user WHERE is_delete = 0 AND username != "admin"',
      callback
    );
  },

  getUserById(userid, callback) {
    connection.query(
      "SELECT * FROM user WHERE userid = ? AND is_delete = 0",
      [userid],
      callback
    );
  },

  getUserByEmail(email, callback) {
    connection.query(
      "SELECT * FROM user WHERE email = ? AND is_delete = 0",
      [email],
      callback
    );
  },

  getUserByPhonenumber(phonenumber, callback) {
    connection.query(
      "SELECT * FROM user WHERE phonenumber = ? AND is_delete = 0",
      [phonenumber],
      callback
    );
  },

  getUserByUsername(username, callback) {
    connection.query(
      "SELECT * FROM user WHERE username = ? AND is_delete = 0",
      [username],
      callback
    );
  },

  addUser(user, callback) {
    const {
      fullname,
      phonenumber,
      address,
      email,
      gender,
      nic,
      username,
      password,
    } = user;

    const trndate = new Date().toISOString().slice(0, 19).replace("T", " ");
    const defaultvalues = 0;
    const updateEmpty = "";

    // Hash the password before inserting it into the database
    bcrypt.hash(password, 10, (err, hash) => {
      // 10 is the number of bcrypt salt rounds
      if (err) {
        console.error("Error hashing password:", err);
        return callback(err, null);
      }

      const query =
        "INSERT INTO user (fullname, phonenumber, address, email, gender , nic , username, password, trndate, is_delete) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?)";
      const values = [
        fullname,
        phonenumber,
        address,
        email,
        gender,
        nic,
        username,
        hash,
        trndate,
        defaultvalues,
      ];

      connection.query(query, values, (error, results) => {
        if (error) {
          console.error("Error executing query:", error);
          return callback(error, null);
        }

        const userId = results.insertId;
        callback(null, userId);
      });
    });
  },

  meUpdateUser(user, userid, callback) {
    const { fullname, phonenumber, address, gender, nic } = user;
    const query =
      "UPDATE user SET fullname = ?, phonenumber = ?, address = ?, gender = ?, nic = ? WHERE userid = ?";
    const values = [fullname, phonenumber, address, gender, nic, userid];
    connection.query(query, values, callback);
  },

  updateUserPassword(userid, newPassword, callback) {
    bcrypt.hash(newPassword, 10, (err, hash) => {
      // 10 is the number of bcrypt salt rounds
      if (err) {
        callback(err, null);
        return;
      }
      const query = "UPDATE user SET password = ? WHERE userid = ?";
      const values = [hash, userid];

      connection.query(query, values, callback);
    });
  },

  updatePasswordByEmail(email, newPassword, callback) {
    // Hash the new password before updating it
    bcrypt.hash(newPassword, 10, (err, hash) => {
      // 10 is the number of bcrypt salt rounds
      if (err) {
        callback(err, null);
        return;
      }

      const query = "UPDATE user SET password = ? WHERE email = ?";
      const values = [hash, email]; // Use the hashed password

      connection.query(query, values, (error, results) => {
        if (error) {
          callback(error, null);
          return;
        }

        callback(null, results.affectedRows);
      });
    });
  },

  changeEmail(userid, newEmail, callback) {
    const query = "UPDATE user SET email = ? WHERE userid = ?";
    const values = [newEmail, userid];

    connection.query(query, values, callback);
  },

  changeUsername(userid, username, callback) {
    const query = "UPDATE user SET username = ? WHERE userid = ?";
    const values = [username, userid];

    connection.query(query, values, callback);
  },

  userById(userid) {
    return new Promise((resolve, reject) => {
      connection.query(
        "SELECT * FROM user WHERE userid = ?",
        [userid],
        (error, results) => {
          if (error) {
            reject(error);
          } else {
            resolve(results);
          }
        }
      );
    });
  },

  userByEmail(email) {
    return new Promise((resolve, reject) => {
      connection.query(
        "SELECT * FROM user WHERE email = ?",
        [email],
        (error, results) => {
          if (error) {
            reject(error);
          } else {
            resolve(results);
          }
        }
      );
    });
  },
};

module.exports = UserModel;
