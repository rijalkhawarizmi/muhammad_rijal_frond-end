import 'package:siscom/core/home/data/model/goods_model.dart';
import 'package:siscom/core/home/data/model/group_goods_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../../core/home/data/model/categories_model.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._init();

  static Database? _database;

  ProductDatabase._init();
  final categoriesTable = 'categories';
  final goodsTable = 'goods';
  final groupgoodsTable = 'groupgoods';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('product.db');

    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final textType = 'TEXT NOT NULL';
    final intType = 'INT NOT NULL';

    await db.execute('''CREATE TABLE  $categoriesTable (
      ${CategoriesField.id} $intType,
      ${CategoriesField.categoryName} $textType
    )''');

    await db.execute('''CREATE TABLE  $groupgoodsTable (
      ${GroupGoodsField.id} $intType,
      ${GroupGoodsField.groupGoodsName} $textType
    )''');

    await db.execute('''CREATE TABLE  $goodsTable (
      ${GoodsField.id} $intType,
      ${GoodsField.goodsName} $textType,
      ${GoodsField.goodsImage} $textType,
      ${GoodsField.stock} $intType,
      ${GoodsField.categoryID} $intType,
      ${GoodsField.goodsGroup} $intType,
      ${GoodsField.price} $intType
    )''');
  }

  Future<List<CategoryModel>> readAllCategories() async {
    final db = await instance.database;

    final categories = await db.transaction((txn) async {
      List<CategoryModel> categoriModel = [
        CategoryModel(id: 1, categoryName: "Motor"),
        CategoryModel(id: 2, categoryName: "Mobil"),
        CategoryModel(id: 3, categoryName: "Handphone"),
        CategoryModel(id: 4, categoryName: "Laptop"),
        CategoryModel(id: 5, categoryName: "Gelang"),
        CategoryModel(id: 6, categoryName: "Jam Tangan"),
      ];
         txn.delete(categoriesTable);
      for (var data in categoriModel) {

        await txn.insert(categoriesTable, data.toJson());
      }
      List<Map<String, dynamic>> data = await txn.query(categoriesTable);
      return data;
    });

    return categories.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel> categoryByID(int id) async {
    final db = await instance.database;

    final maps = await db.query(categoriesTable,
        columns: CategoriesField.values,
        where: '${CategoriesField.id}=?',
        whereArgs: [id]);
    
      return CategoryModel.fromJson(maps.first);

    
  }

  Future<void> update(GoodsModel goodsModel) async {
    final db = await instance.database;
    
    await db.update(goodsTable, goodsModel.toJson(),
        where: '${GoodsField.id}= ?',
        whereArgs: [goodsModel.id]);
  }

  Future<List<GroupGoodsModel>> readAllGroupGoods() async {
    final db = await instance.database;

    final groupGoods = await db.transaction((txn) async {
      List<GroupGoodsModel> groupGoodsModel = [
        GroupGoodsModel(id: 11, groupGoodsName: "Kendaraan"),
        GroupGoodsModel(id: 12, groupGoodsName: "Elektronik"),
        GroupGoodsModel(id: 13, groupGoodsName: "Aksesoris"),
      ];
         txn.delete(groupgoodsTable);
      for (var data in groupGoodsModel) {
        await txn.insert(groupgoodsTable, data.toJson());
      }
      List<Map<String, dynamic>> data = await txn.query(groupgoodsTable);
      return data;
    });

    return groupGoods.map((e) => GroupGoodsModel.fromJson(e)).toList();
  }

  Future<GoodsModel> createGoods(GoodsModel goodsModel) async {
    final db = await instance.database;

    final id = await db.insert(goodsTable, goodsModel.toJson());

    return goodsModel.copy(id: id);
  }

  Future<List<GoodsModel>> readAllGoods() async {
    final db = await instance.database;

    final result = await db.query(goodsTable);
     print(result);
    return result.map((e) => GoodsModel.fromJson(e)).toList();
  }

  Future<List<GoodsModel>> searchGoods(String query) async {
    final db = await instance.database;
    final result = await db.query(
      goodsTable,
      where: 'goods_name LIKE ?',
      whereArgs: ['%$query%'],
    );
   
    return result.map((e) => GoodsModel.fromJson(e)).toList();
  }

  Future<bool> delete({List<int>? ids, int? id}) async {
    final db = await instance.database;

    if (ids != null) {
      await db.delete(goodsTable,
          where: '_id IN (${List.filled(ids.length, '?').join(',')})',
          whereArgs: ids);
    } else {
      db.delete(goodsTable, where: '${GoodsField.id} = ?', whereArgs: [id]);
    }

    return Future.value(true);
  }

}
