import 'package:mysql_client/mysql_client.dart';

class MySQLHelper {
  static MySQLConnection? _connection;

  /// Initialize the database connection
  static Future<void> initConnection({required host,required user,required password,required database,}) async {
    _connection = await MySQLConnection.createConnection(
      host: host,
      port: 3306,
      userName: user,
      password: password,
      databaseName: database, // optional
    );

    await _connection!.connect();
  }

  /// Fetch a single product by ID
  static Future<Map<String, dynamic>?> getProductById(String productId, String table) async {
    if (_connection == null) {
      throw Exception("Database connection is not initialized.");
    }

    // Validate the table name to prevent SQL injection
    // final allowedTables = ['products', 'another_table', 'example_table']; // Replace with your valid table names
    // if (!allowedTables.contains(table)) {
    //   throw Exception("Invalid table name provided.");
    // }

    var query = 'SELECT * FROM $table WHERE id = :id';

    var result = await _connection!.execute(
      query,
      {'id': productId},
    );

    if (result.rows.isNotEmpty) {
      return result.rows.first.assoc();
    }

    return null; // Return null if no product is found
  }

  /// Close the database connection
  static Future<void> closeConnection() async {
    await _connection?.close();
    _connection = null;
  }
}
