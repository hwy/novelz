import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "book.db";
  static final _databaseVersion = 4;


  //bookshell
  static final table = 'bookshell';

  static final columnId = 'id';
  static final columnName = 'bookname';
  static final columnLink = 'booklink';
  static final columnPhoto = 'bookphoto';
  static final columnReadchapter = 'bookreadchapter';
  static final columnReadchapterpage = 'bookreadchaptepage';
  static final columnUpdate = 'bookupdate';
  static final columnScrollposition = 'booScrollposition';
  static final columnReaddate = 'bookReaddate';


  //bookchapter
  static final tablechapter = 'bookchapter';

  static final columnBookId = 'id';
  static final columnBookChapterId = 'bookchapterid';
  static final columnBookChapterTitle = 'bookchaptertitle';
  static final columnBookChapterLink = 'bookchapterlink';
  static final columnChapterContent = 'bookchaptercontent';
  static final columnChapterLoad = 'bookchapterload';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("""
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnLink TEXT NOT NULL,
            $columnPhoto TEXT NOT NULL,
            $columnReadchapter INTEGER DEFAULT 0,
            $columnReadchapterpage INTEGER DEFAULT 0,
            $columnUpdate TEXT NOT NULL,
            $columnReaddate DATETIME NOT NULL,
            $columnScrollposition DOUBLE DEFAULT 0            
          );
          """);


    await db.execute("""
            CREATE TABLE $tablechapter (
            $columnBookChapterId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnBookId INTEGER NOT NULL,
            $columnBookChapterTitle TEXT NOT NULL,
            $columnBookChapterLink TEXT NOT NULL,
            $columnChapterContent TEXT DEFAULT 0,
            $columnChapterLoad INTEGER DEFAULT 0
          );
         """);
  }


  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertbook(Map<String, dynamic>  datadetail ) async {
    Database db = await instance.database;
    print(datadetail['bookname']+DateTime.now().toString());
    return await db.insert(table, {'bookname': datadetail['bookname'], 'booklink': datadetail['bookurl'],'bookphoto':datadetail['base64Image'],'bookupdate':datadetail['booklastupdatetitle'],'bookReaddate':DateTime.now().toString()});

  }





  Future<int> updateBookReadChapterPage(int bookId,int chapterId, int page, double scrollPosition) async {
    Database db = await instance.database;
    print('bookid '+bookId.toString()+'chapterid : '+chapterId.toString()+'page :'+page.toString());
    return await db.update(table,{'bookreadchapter': chapterId,'bookreadchaptepage': page,'booScrollposition':scrollPosition, 'bookReaddate':DateTime.now().toString()}, where: '$columnId = ?', whereArgs: [bookId]);
  }






  Future<bool> insertchapter(int bookdbid,List bookchaptertitle,List bookchapterlink) async {
    Database db = await instance.database;


    print("insertchapterinsertchapterinsertchapterinsertchapterinsertchapter"+bookchaptertitle.length.toString());

/*
  int  charterFirstId=  await  db.insert(tablechapter, {'id': bookdbid, 'bookchaptertitle': bookchaptertitle[0],'bookchapterlink':bookchapterlink[0]});

print(charterFirstId.toString()+'charterFirstIdcharterFirstIdcharterFirstId');

    await db.update(table, {'bookreadchapter': charterFirstId},  where: '$columnId = ?', whereArgs: [bookdbid]);
*/

    Batch batch = db.batch();

    for (int i = 0; i < bookchaptertitle.length; ++i) {
      batch.insert(tablechapter, {'id': bookdbid, 'bookchaptertitle': bookchaptertitle[i], 'bookchapterlink':bookchapterlink[i]});
      // print( await batch.commit());
    };
    print( await batch.commit());

    print("done");
    return true;
  }




  Future <List<Map<String, dynamic>>> chapterPrevNextId(int bookchapterId,int bookId) async {
    Database db = await instance.database;

    // return await db.rawQuery("SELECT A.bookchapterid ,  C.bookchapterid AS PrevName ,  A.bookchapterid AS CurName ,  B.bookchapterid AS NxtName FROM bookchapter AS A LEFT JOIN bookchapter AS B ON A.bookchapterid = B.bookchapterid - 1 LEFT JOIN bookchapter AS C ON A.bookchapterid = C.bookchapterid + 1 WHERE A.bookchapterid = $bookchapterId");
    return await db.rawQuery("SELECT A.bookchapterid ,  C.bookchapterid AS PrevName ,  A.bookchapterid AS CurName ,  B.bookchapterid AS NxtName FROM bookchapter AS A LEFT JOIN bookchapter AS B ON A.bookchapterid = B.bookchapterid - 1 LEFT JOIN bookchapter AS C ON A.bookchapterid = C.bookchapterid + 1 WHERE A.bookchapterid = $bookchapterId and A.id= $bookId");

  }





/*
  Future <List<Map<String, dynamic>>> queryChapterFirstId(BookId) async {
    //引用資料庫
    Database db = await instance.database;


  //  List<Map<String, Object>> chaterFristId=  await db.query(tablechapter);

    return await db.query(tablechapter,columns: ['bookchaptertitle','bookchapterid'], where: "$columnBookId = $BookId");

    return await db.query(tablechapter,  where: '$columnBookId = ?', whereArgs: [BookId], orderBy: "bookchapterid ASC",  limit: 1);

  }
*/





  Future<int> updatechapterContent(int bookchapterId,String bookchapterContent) async {
    Database db = await instance.database;

    //  print( await db.insert(tablechapter, {'bookchaptercontent': bookchapterContent, 'bookchaptertitle': bookchaptertitle[i],'bookchapterlink':bookchapterlink[i]}));

    return await db.update(tablechapter, {'bookchaptercontent': bookchapterContent},  where: '$columnBookChapterId = ?', whereArgs: [bookchapterId]);

    // return true;
  }


  Future <List<Map<String, dynamic>>> queryBookId(String booklink) async {
    Database db = await instance.database;
    //return await db.query(table, where: "$columnLink = $booklink");


    return await db.query(table, where: '$columnLink = ?', whereArgs: [booklink]);

    // return Sqflite.firstIntValue(await db.rawQuery('SELECT id FROM $table WHERE booklink=?', [booklink]));

  }




  Future <List<Map<String, dynamic>>> queryAllBook() async {
    //引用資料庫
    Database db = await instance.database;

    // 查詢狗狗資料庫語法
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: "bookReaddate DESC");


    return maps;
//將 List<Map<String, dynamic> 轉換成 List<Dog> 資料類型
    /*  return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });*/
  }






  Future <List<Map<String, dynamic>>> queryBookDetail(bookId) async {
    //引用資料庫
    Database db = await instance.database;
    print("DB CONNECTION IS: $db");

    return await db.query(table, where: "$columnId = $bookId");


  }





  Future <List<Map<String, dynamic>>> queryAllChapter(int bookId) async {
    //引用資料庫
    Database db = await instance.database;
    print("DB CONNECTION IS: $db");

    // 查詢狗狗資料庫語法
    return await db.query(tablechapter, where: "$columnBookId = $bookId");
//print(await db.query(tablechapter, where: "$columnBookId = $bookId").toString());


  }




  Future <List<Map<String, dynamic>>> queryChapterContent(chapterId) async {
    //引用資料庫
    Database db = await instance.database;

    // 查詢狗狗資料庫語法
    //  final List<Map<String, dynamic>> maps = await db.query(tablechapter);
    return await db.query(tablechapter , where: "$columnBookChapterId = $chapterId");


  }





/*
  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name%'");
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }



  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(List car) async {
    Database db = await instance.database;
    int id = car.toMap()['id'];
    return await db.update(table, car.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }*/
}
