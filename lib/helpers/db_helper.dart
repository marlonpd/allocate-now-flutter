import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

const budgets = 'budgets';
const budgetItems = 'budgetItems';
const settings = 'settings';

class DBHelper {
  static final initialScript = [
    '''
    CREATE TABLE $budgets(id TEXT PRIMARY KEY, name TEXT, amount REAL, createdAt DATETIME)
    ''',
    '''
    CREATE TABLE $budgetItems(id TEXT PRIMARY KEY, budgetId TEXT, name TEXT, entryType TEXT, unitCount REAL, amount REAL, totalAmount REAL, isPaid INTEGER  default 0, dueDate INTEGER default NULL)
   '''
  ];

  static final migrations = [
    '''
    '''

    // '''
    // drop table $budgetItems;
    // ''',
  ];

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'allocatenow.db'),
        onCreate: (db, version) async {
      // db.execute(
      //     'CREATE TABLE $budgets(id TEXT PRIMARY KEY, name TEXT, amount REAL, createdAt DATETIME)');

      // db.execute('CREATE TABLE $settings(name TEXT, value TEXT default NULL)');

      // return db.execute(
      //     'CREATE TABLE $budgetItems(id TEXT PRIMARY KEY, budgetId TEXT, name TEXT, entryType TEXT, unitCount REAL, amount REAL, totalAmount REAL, isPaid INTEGER  default 0, dueDate INTEGER default NULL)');

      print('Init database');
      Batch batch = db.batch();

      // drop first

      batch.execute("DROP TABLE IF EXISTS $budgets;");
      batch.execute("DROP TABLE IF EXISTS $settings;");
      batch.execute("DROP TABLE IF EXISTS $budgetItems;");

      print('Deleting database');
      // then create again
      batch.execute(
          'CREATE TABLE $budgets(id TEXT PRIMARY KEY, name TEXT, amount REAL, createdAt DATETIME)');
      batch.execute(
          'CREATE TABLE $settings(name TEXT, value TEXT default NULL)');
      batch.execute(
          'CREATE TABLE $budgetItems(id TEXT PRIMARY KEY, budgetId TEXT, name TEXT, entryType TEXT, unitCount REAL, amount REAL, totalAmount REAL, isPaid INTEGER  default 0, dueDate INTEGER default NULL)');
      await batch.commit();

      return;
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      // db.execute(
      //     'CREATE TABLE $budgets(id TEXT PRIMARY KEY, name TEXT, amount REAL, createdAt DATETIME)');

      // db.execute('CREATE TABLE $settings(name TEXT, value TEXT default NULL)');

      // return db.execute(
      //     'CREATE TABLE $budgetItems(id TEXT PRIMARY KEY, budgetId TEXT, name TEXT, entryType TEXT, unitCount REAL, amount REAL, totalAmount REAL, isPaid INTEGER  default 0, dueDate INTEGER default NULL)');

      print('Init database');
      Batch batch = db.batch();

      // drop first

      batch.execute("DROP TABLE IF EXISTS $budgets;");
      batch.execute("DROP TABLE IF EXISTS $settings;");
      batch.execute("DROP TABLE IF EXISTS $budgetItems;");

      print('Deleting database');
      // then create again
      batch.execute(
          'CREATE TABLE $budgets(id TEXT PRIMARY KEY, name TEXT, amount REAL, createdAt DATETIME)');
      batch.execute(
          'CREATE TABLE $settings(name TEXT, value TEXT default NULL)');
      batch.execute(
          'CREATE TABLE $budgetItems(id TEXT PRIMARY KEY, budgetId TEXT, name TEXT, entryType TEXT, unitCount REAL, amount REAL, totalAmount REAL, isPaid INTEGER  default 0, dueDate INTEGER default NULL)');

      //List<dynamic> result = await batch.commit();
    }, version: 6);
  }

  // static Future<Database> database() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   return sql.openDatabase(path.join(dbPath, 'allocatenow.db'),
  //       onCreate: (db, version) {
  //     db.execute(
  //         'CREATE TABLE $budgets(id TEXT PRIMARY KEY, name TEXT, amount REAL, createdAt DATETIME)');

  //     db.execute('CREATE TABLE $settings(name TEXT, value TEXT default NULL)');

  //     return db.execute(
  //         'CREATE TABLE $budgetItems(id TEXT PRIMARY KEY, budgetId TEXT, name TEXT, entryType TEXT, unitCount REAL, amount REAL, totalAmount REAL, isPaid INTEGER  default 0, dueDate INTEGER default NULL)');
  //   }, version: 3);
  // }

  // static Future<Database> database() async {
  //   final config = MigrationConfig(
  //       initializationScript: initialScript, migrationScripts: migrations);
  //   final databasesPath = await sql.getDatabasesPath();
  //   final dbPath = path.join(databasesPath, 'allocatenow.db');

  //   return await openDatabaseWithMigration(dbPath, config);
  // }

  //
  // Budget
  //

  static Future<void> initializeSeting() async {
    var initSettings = {'currency': '\$'};
    await insert(settings, initSettings);
  }

  static Future<List<Map<String, dynamic>>> getSettings() async {
    final db = await DBHelper.database();
    return db.query(settings);
  }

  static Future<String> dbInit() async {
    await DBHelper.database();
    return 'Database Loaded';
  }

  static Future<List<Map<String, dynamic>>> getBudgetWithItems() async {
    final db = await DBHelper.database();
    return db.rawQuery(
        'SELECT * FROM budgets b inner join budgetItems bi on b.id = bi.budgetId');
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    print('inserting...');
    print(data);
    try {
      final db = await DBHelper.database();
      await db.insert(table, data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateBudget(String budgetId, String name) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE $budgets SET name = ? WHERE id = ?', [name, budgetId]);
  }

  static Future<void> deleteBudget(String budgetId) async {
    final db = await DBHelper.database();
    db.rawQuery('DELETE FROM $budgets WHERE id=?', [budgetId]);
  }

  static Future<void> deleteBudgetItem(String budgetItemId) async {
    final db = await DBHelper.database();
    db.rawQuery('DELETE FROM budgetItems WHERE id=?', [budgetItemId]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getBudgetById(
      String budgetId) async {
    final db = await DBHelper.database();
    return db.rawQuery('SELECT * FROM budgets WHERE id=?', [budgetId]);
  }

  //
  // BudgetItem
  //

  static Future<void> deleteBudgetItemsByBudgetId(String budgetId) async {
    final db = await DBHelper.database();
    db.rawQuery('DELETE FROM budgetItems WHERE budgetId=?', [budgetId]);
  }

  static Future<void> toggleSetPaidBudgetItem(
      String budgetItemId, isPaid) async {
    final db = await DBHelper.database();
    db.rawUpdate(
        'UPDATE budgetItems SET isPaid = ? WHERE id=?', [isPaid, budgetItemId]);
  }

  static Future<void> setDueDate(String budgetItemId, int dueDate) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE budgetItems SET dueDate = ? WHERE id=?',
        [dueDate, budgetItemId]);
  }

  static Future<List<Map<String, dynamic>>> getBudgetItemsByBudgetId(
      String budgetId) async {
    final db = await DBHelper.database();
    return db
        .rawQuery('SELECT * FROM budgetItems WHERE budgetId=?', [budgetId]);
  }

  static Future<void> updateBudgetItem(String budgetId, String name,
      double unitCount, double amount, double totalAmount) async {
    final db = await DBHelper.database();
    db.rawUpdate(
        'UPDATE $budgetItems SET name = ?, unitCount = ?, amount = ?, totalAmount = ? WHERE id = ?',
        [name, unitCount, amount, totalAmount, budgetId]);
  }

  //
  //Setting
  //
  static Future<void> updateSettings(String name, String value) async {
    try {
      final db = await DBHelper.database();
      final setting = await db.rawUpdate(
          'UPDATE $settings SET value = ? WHERE name=?', [value, name]);

      print('updating');
      print(setting);
      if (setting == 0) {
        final ins = await db.insert(settings, {'name': name, 'value': value},
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
        print('inserting');
        print(ins);
      }
    } catch (e) {
      print(e);
    }
  }
}
