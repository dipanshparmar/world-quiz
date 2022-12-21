import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  // private db instance
  static Database? _db;

  // to open the database
  static Future<Database> _openDatabase() async {
    // generating the database dir
    final String dbPath = await getDatabasesPath();

    // creating the path
    final String path = p.join(dbPath, 'history.db');

    // opening the database
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: ((db, version) {
        // creating the database
        db.execute(
          'CREATE TABLE Quiz (correct_answers TINYINT, total_questions TINYINT, date TINYTEXT, topics TEXT)',
        );
      }),
    );

    // returning the database
    return _db!;
  }

  // method to get all teh records
  static Future<List<Map<String, Object?>>> getAllData() async {
    // getting the db
    final Database db = await _openDatabase();

    // getting the records
    final List<Map<String, Object?>> data =
        await db.query('Quiz'); // limiting the data to 50 results only

    // returning the data
    return data;
  }

  // method to insert the data
  static Future<void> insert(Map<String, Object?> data) async {
    // getting the db
    final Database db = await _openDatabase();

    // inserting the data
    await db.insert('Quiz', data);

    // keeping only the latest 50 records
    // https://stackoverflow.com/a/3667119/11283915
    await db.execute(
      'DELETE FROM Quiz WHERE ROWID IN (SELECT ROWID FROM Quiz ORDER BY ROWID DESC LIMIT -1 OFFSET 50)',
    );
  }
}
