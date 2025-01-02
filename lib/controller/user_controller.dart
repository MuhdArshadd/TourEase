import 'package:TourEase/dbconnection/dbConnection.dart'; //add the connection to database file
import 'package:postgres/postgres.dart'; // PostgreSQL package for Dart

class UserController {
  final DatabaseService _dbService = DatabaseService(); // Instance of DatabaseService

  // Method to check if the login credentials are valid and return 0 if not exist, 1 if business, and 2 if personal
  Future<int> loginUser(String email, String password) async {
    await _dbService.initializeConnection(); // Ensure connection is initialized
    PostgreSQLConnection connection = await _dbService.getConnection(); // Get an open connection
    try {
      // Query to check if the email and password combination exists in the database
      List<List<dynamic>> results = await connection.query(
        '''
      SELECT user_category FROM tbl_user 
      WHERE email = @email AND password = @password
      ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );

      print('Query executed successfully. Number of records found: ${results.length}'); // Debugging line

      // If the user is found, check the account category and return the corresponding integer value
      if (results.isNotEmpty) {
        var category = results[0][0]; // Get the category (0 for business, 1 for personal)
        if (category == 0) {
          return 1; // 0 is for business
        } else if (category == 1) {
          return 2; // 1 is for personal
        }
      }

      // If no user is found, return 0
      return 0;
    } catch (e) {
      // Handle errors here (e.g., log or throw them for debugging)
      print('Error during login: $e'); // Debugging line
      return 0; // Return 0 in case of an error
    }
  }

  // Method to check and write the register credentials
  Future<bool> registerUser(String firstName, String lastName, String email, String password, int category, String question, String answer) async {
    await _dbService.initializeConnection(); // Ensure connection is initialized
    PostgreSQLConnection connection = await _dbService.getConnection(); // Get an open connection

    try {
      // Query to check if the user data already exists in the database
      List<List<dynamic>> results = await connection.query(
        '''
      SELECT * FROM tbl_user WHERE email = @email
      ''',
        substitutionValues: {
          'email': email,
        },
      );

      print('Query executed successfully. Number of records found: ${results.length}'); // Debugging line

      // If the user is found, return false (indicating the email is already registered)
      if (results.isNotEmpty) {
        return false;
      } else {
        // Query to get the security question ID based on the question text
        List<List<dynamic>> questionResults = await connection.query(
          '''
        SELECT security_id FROM tbl_security WHERE question = @question
        ''',
          substitutionValues: {
            'question': question,
          },
        );

        if (questionResults.isEmpty) {
          print('Security question not found.'); // Debugging line
          return false; // or handle the error as needed
        }

        // Get the security question ID
        int securityQuestionId = questionResults.first[0];

        // Query to insert the new user data into the database and get the user ID
        List<List<dynamic>> userInsertResults = await connection.query(
          '''
        INSERT INTO tbl_user (fname, lname, email, password, user_category) 
        VALUES (@fname, @lname, @email, @password, @user_category)
        RETURNING userid
        ''',
          substitutionValues: {
            'fname': firstName,
            'lname': lastName,
            'email': email,
            'password': password,
            'user_category': category,
          },
        );

        // Get the newly inserted user ID
        int userId = userInsertResults.first[0];

        print('User registered successfully. User ID: $userId'); // Debugging line

        // Insert the security question ID and answer into the tbl_user_security table
        await connection.query(
          '''
        INSERT INTO tbl_user_security (userid, security_id, answer) 
        VALUES (@userid, @security_id, @answer)
        ''',
          substitutionValues: {
            'userid': userId, // Use the newly retrieved user ID
            'security_id': securityQuestionId,
            'answer': answer,
          },
        );

        print('User security details registered successfully'); // Debugging line

        return true;
      }
    } catch (e) {
      // Handle errors here (e.g., log or throw them for debugging)
      print('Error during registration: $e'); // Debugging line
      return false;
    }
  }


}