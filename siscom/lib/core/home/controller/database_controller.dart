import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:siscom/common/util/product_database.dart';
import 'package:siscom/core/home/data/model/categories_model.dart';
import 'package:siscom/core/home/data/model/group_goods_model.dart';

import '../data/model/goods_model.dart';

class DatabaseController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    goodsLists();

    fetchListCategories();

    groupGoodsLists();
  }

  List<GoodsModel> goodsList = [];
  List<GroupGoodsModel> groupGoodsList = [];
  List<CategoryModel> categoriesList = [];
  List<int> collectGoodsID = [];
  GoodsModel? categoryID;
  String? image;
  bool isChechked = false;
  bool isShowCheckBox = false;
  bool isSelectAll = false;
  CategoryModel? selectedCategory;
  GroupGoodsModel? selectedGroupGoodsModel;
  CategoryModel? categoryName;

  void showCheckBox() {
    update();
    isShowCheckBox = !isShowCheckBox;
    isSelectAll = false;
  }

  Future<void> goodsListsSearch(String goodsName) async {
    goodsList = await ProductDatabase.instance.searchGoods(goodsName);
    update();
  }

  Future<void> goodsLists() async {
    goodsList = await ProductDatabase.instance.readAllGoods();
    update();
  }

  Future<void> groupGoodsLists() async {
    groupGoodsList = await ProductDatabase.instance.readAllGroupGoods();
    update();
  }

  Future<void> createGoods(GoodsModel goodsModel) async {
    update();
    await ProductDatabase.instance.createGoods(goodsModel);
  }

  Future<void> fetchListCategories() async {
    update();
    categoriesList = await ProductDatabase.instance.readAllCategories(); 
    
  }

  Future<void> updateGoods(GoodsModel goodsModel) async {
    update();
    await ProductDatabase.instance.update(goodsModel);
  }

  Future<bool> deleteAllGoods() async {
    update();
    return await ProductDatabase.instance.delete(ids: collectGoodsID);
  }

  Future<bool> deleteByID(int id) async {
    update();
    return await ProductDatabase.instance.delete(id: id);
  }

  void selectGoodsbyID(bool value) {
    isChechked = value;
    update();
  }

  void checkedAllGoods(List<GoodsModel> listID) {
    update();
    listID.forEach((goods) {
      collectGoodsID.add(goods.id!);
      goods.isChechked = true;
      isSelectAll = true;
    });
  }

  void checkedAllGoodsCancel(List<GoodsModel> listID) {
    update();
    collectGoodsID.clear();
    listID.forEach((goods) {
      goods.isChechked = false;
      isSelectAll = false;
    });
  }

  void chooseDropdownCategory(CategoryModel categoryModel) {
    selectedCategory = categoryModel;
    update();
  }

  void chooseDropdownGroupGoods(GroupGoodsModel groupGoodsModel) {
    selectedGroupGoodsModel = groupGoodsModel;
    update();
  }

  void pickImage(String pathImage) {
    print(pathImage);
    image = pathImage;
    update();
  }
}
