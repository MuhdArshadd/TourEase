import 'package:TourEase/dbconnection/dbConnection.dart'; //add the connection to database file
import 'package:postgres/postgres.dart'; // PostgreSQL package for Dart

class SecurityController {
  final DatabaseService _dbService = DatabaseService(); // Instance of DatabaseService

  Future<List<Map<String, dynamic>>> fetchSecurityQuestions() async {
    await _dbService.initializeConnection();
    PostgreSQLConnection connection = await _dbService.getConnection();

    //fetch 2 random questions
    try {
      List<List<dynamic>> results = await connection.query(
          '''
          SELECT security_id, question 
          FROM tbl_security
          ORDER BY RANDOM() 
          LIMIT 2
          '''
      );

      // Convert results to a list of maps
      return results.map((row) {
        return {
          'id': row[0],         // Assuming first column is 'id'
          'question': row[1],    // Assuming second column is 'question'
        };
      }).toList();
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }

}