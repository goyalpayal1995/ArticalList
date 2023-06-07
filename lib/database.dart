import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/article.dart';

class DatabaseHelper {
  static const String DB_NAME = 'articles.db';
  static const String TABLE_NAME = 'articles';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_TITLE = 'title';
  static const String COLUMN_ABSTRACT = 'abstract';

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, DB_NAME);
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_NAME (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_TITLE TEXT,
        $COLUMN_ABSTRACT TEXT
      )
    ''');
  }

  static Future<List<Article>> getArticles() async {
    final db = await _openDatabase();
    final articles = await db.query(TABLE_NAME);
    return articles.map((item) => Article.fromJson(item)).toList();
  }

  static Future<void> insertArticle(Article article) async {
    final db = await _openDatabase();
    await db.insert(TABLE_NAME, article.toJson());
  }

  static Future<void> clearArticles() async {
    final db = await _openDatabase();
    await db.delete(TABLE_NAME);
  }
}
