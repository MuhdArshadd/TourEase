import 'package:postgres/postgres.dart';

class DatabaseService {
  late PostgreSQLConnection connection;

  // Constructor to initialize the connection
  Future<void> initializeConnection() async {
    connection = PostgreSQLConnection(
      'Database', // host
      5432, // port
      'db_name', // database name
      username: 'db_username', // username
      password: 'db_password', // password
      useSSL: true, // SSL required for Azure PostgreSQL
    );

    // Open the connection
    await connection.open();
  }

  // Get connection method
  Future<PostgreSQLConnection> getConnection() async {
    // Ensure the connection is established
    if (connection.isClosed) {
      await initializeConnection(); // Reinitialize if closed
    }
    return connection;
  }

  // Close the connection
  Future<void> closeConnection() async {
    if (!connection.isClosed) {
      await connection.close();
    }
  }
}

const mapAPIkey = "your_map_api_key";
const openAPIkey = 'your_api_key';
const username = 'db_username';
const password='db_password';
