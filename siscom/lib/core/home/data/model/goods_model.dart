
class GoodsField {
  static final List<String> values = [id, goodsName];
  static const String id = '_id';
  static const String goodsName = 'goods_name';
  static const String goodsImage = 'goods_image';
  static const String categoryID = 'category_id';
  static const String stock = 'stock';
  static const String goodsGroup = 'goods_group';
  static const String price = 'price';
}

class GoodsModel {
  int? id;
  String? goodsName;
  String? goodsImage;
  int? stock;
  int? categoryID;
  String? goodsGroup;
  int? price;
  bool isChechked=false;

  GoodsModel(
      {this.id,
      this.goodsName,
      this.goodsImage,
      this.stock,
      this.categoryID,
      this.goodsGroup,
      this.price});

  GoodsModel copy(
          {int? id,
          String? goodsName,
          String? goodsImage,
          int? stock,
          int? categoryID,
          String? goodsGroup,
          int? price}) =>
      GoodsModel(
        id: id ?? this.id,
        goodsName: goodsName ?? this.goodsName,
        goodsImage: goodsImage ?? this.goodsImage,
        stock: stock ?? this.stock,
        categoryID: categoryID ?? this.categoryID,
        goodsGroup: goodsGroup ?? this.goodsGroup,
        price: price ?? this.price,
      );

  static GoodsModel fromJson(Map<String, Object?> json) => GoodsModel(
        id: json[GoodsField.id] as int,
        goodsName: json[GoodsField.goodsName] as String,
        goodsImage: json[GoodsField.goodsImage] as String,
        stock: json[GoodsField.stock] as int,
        categoryID: json[GoodsField.categoryID] as int,
        goodsGroup: json[GoodsField.goodsGroup] as String,
        price: json[GoodsField.price] as int,
      );
  Map<String, Object?> toJson() =>
      {GoodsField.id: id, 
      GoodsField.goodsName: goodsName,
      GoodsField.goodsImage: goodsImage,
      GoodsField.stock: stock,
      GoodsField.categoryID: categoryID,
      GoodsField.goodsGroup: goodsGroup,
      GoodsField.price: price
      };
}
