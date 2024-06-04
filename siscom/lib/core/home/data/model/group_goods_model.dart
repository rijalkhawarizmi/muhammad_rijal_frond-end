class GroupGoodsField {
  static final List<String> values = [id, groupGoodsName];
  static const String id = '_id';
  static const String groupGoodsName = 'group_goods_name';
}

class GroupGoodsModel {
  int? id;
  String? groupGoodsName;

  GroupGoodsModel({this.id, this.groupGoodsName});

  GroupGoodsModel copy({int? id, String? groupGoodsName}) => GroupGoodsModel(
      id: id ?? this.id, groupGoodsName: groupGoodsName ?? this.groupGoodsName);

  static GroupGoodsModel fromJson(Map<String, Object?> json) => GroupGoodsModel(
        id: json[GroupGoodsField.id] as int,
        groupGoodsName: json[GroupGoodsField.groupGoodsName] as String,
      );
  Map<String, Object?> toJson() =>
      {GroupGoodsField.id: id, GroupGoodsField.groupGoodsName: groupGoodsName};
}
