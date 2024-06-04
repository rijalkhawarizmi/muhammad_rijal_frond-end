import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siscom/common/util/format_rupiah.dart';
import 'package:siscom/common/widgets/button.dart';
import 'package:siscom/common/widgets/text_formfield.dart';
import 'package:siscom/core/home/controller/database_controller.dart';
import 'package:siscom/core/home/data/model/goods_model.dart';
import 'package:siscom/core/home/data/model/group_goods_model.dart';
import 'package:siscom/core/home/screen/home.dart';
import '../data/model/categories_model.dart';

class AddUpdateGoods extends StatelessWidget {
  AddUpdateGoods({super.key});
  late TextEditingController goodsImage;
  late TextEditingController goodsName;

  late TextEditingController categoryID;

  late TextEditingController groupsGoods;

  late TextEditingController stock;

  late TextEditingController price;
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      _imageFile = pickedFile;
      Get.find<DatabaseController>().pickImage(_imageFile!.path);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    GoodsModel? goodsModel = Get.arguments;

    goodsImage = TextEditingController(text: goodsModel?.goodsImage);
    goodsName = TextEditingController(text: goodsModel?.goodsName);
    categoryID = TextEditingController(text: goodsModel?.categoryID.toString());
    groupsGoods =
        TextEditingController(text: goodsModel?.goodsGroup.toString());
    stock = TextEditingController(text: goodsModel?.stock.toString());
    price = TextEditingController(
        text: goodsModel?.price != null
            ? RupiahFormat.formatRupiah(goodsModel?.price)
            : "");

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: AppBar(
        title: Text(goodsModel != null ? "Edit" : "Add"),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    goodsModel?.goodsImage != null
                        ? Image.file(
                            File(goodsModel!.goodsImage!),
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : GetBuilder<DatabaseController>(
                            init: DatabaseController(),
                            builder: (DatabaseController controller) =>
                                _imageFile == null || controller.image == null
                                    ? InkWell(
                                        onTap: () =>
                                            _pickImage(ImageSource.gallery),
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: const Center(
                                            child: Text('Pilih Gambar'),
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        File(controller.image!),
                                        width: double.infinity,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Nama Barang*',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    CustomTextField(
                      validate: (v) {
                        if (v!.isEmpty) {
                          return 'Nama Barang Belum diisi';
                        }
                        return null;
                      },
                      controller: goodsName,
                      hintText: 'Masukkan nama barang',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GetBuilder<DatabaseController>(
                          init: DatabaseController(),
                          builder: (DatabaseController controller) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kategori Barang*',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                DropdownButtonFormField<CategoryModel>(
                                  validator: (v) {
                                    if (goodsModel?.goodsName != null) {
                                      return null;
                                    } else if (v?.categoryName == null) {
                                      return 'Kategori Barang Belum diisi';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      hintText: goodsModel?.categoryID != null
                                          ? controller.categoriesList
                                              .where((element) =>
                                                  element.id ==
                                                  goodsModel?.categoryID)
                                              .first
                                              .categoryName
                                          : 'Masukkan kategori barang',
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      )),
                                  value: controller.selectedCategory,
                                  onChanged: (CategoryModel? newValue) {
                                    controller
                                        .chooseDropdownCategory(newValue!);
                                  },
                                  items: controller.categoriesList
                                      .map((CategoryModel category) {
                                    return DropdownMenuItem<CategoryModel>(
                                      value: category,
                                      child: Text(category.categoryName ?? ""),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'Kelompok Barang*',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                DropdownButtonFormField<GroupGoodsModel>(
                                  validator: (v) {
                                    if (goodsModel?.goodsGroup != null) {
                                      return null;
                                    } else if (v?.groupGoodsName == null) {
                                      return 'Kategori Barang Belum diisi';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      hintText: goodsModel?.goodsGroup ??
                                          "Masukkan kelompok barang",
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      )),
                                  value: controller.selectedGroupGoodsModel,
                                  onChanged: (GroupGoodsModel? newValue) {
                                    controller
                                        .chooseDropdownGroupGoods(newValue!);
                                  },
                                  items: controller.groupGoodsList
                                      .map((GroupGoodsModel groupGoods) {
                                    return DropdownMenuItem<GroupGoodsModel>(
                                      value: groupGoods,
                                      child: Text(groupGoods.groupGoodsName!),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          }),
                    ),
                    const Text(
                      'Stok*',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    CustomTextField(
                        textInputType: TextInputType.number,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return 'Stok Belum diisi';
                          }
                          return null;
                        },
                        controller: stock,
                        hintText: "Stock"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Harga*',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    CustomTextField(
                        textInputType: TextInputType.number,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return 'Price Belum diisi';
                          }
                          return null;
                        },
                        onChange: (v) {
                          price.value = price.value.copyWith(
                            text: RupiahFormat.formatAsRupiah(v!),
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  offset:
                                      RupiahFormat.formatAsRupiah(v).length),
                            ),
                          );
                        },
                        controller: price,
                        hintText: "Price"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: CustomButton(
            color: Colors.indigo.shade900,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final controller = Get.find<DatabaseController>();

                final goodsModels = GoodsModel(
                    id: goodsModel?.id ?? UniqueKey().hashCode,
                    goodsImage: _imageFile?.path ?? goodsModel?.goodsImage,
                    goodsName: goodsName.text.isNotEmpty
                        ? goodsName.text
                        : goodsModel?.goodsName,
                    categoryID: controller.selectedCategory?.id ??
                        goodsModel?.categoryID ??
                        controller.selectedCategory?.id,
                    stock: stock.text.isNotEmpty
                        ? int.parse(stock.text)
                        : goodsModel?.stock,
                    goodsGroup:
                        controller.selectedGroupGoodsModel?.groupGoodsName ??
                            goodsModel?.goodsGroup,
                    price: price.text.isNotEmpty
                        ? int.parse(price.text.replaceAll(".", ""))
                        : goodsModel?.price);

                if (goodsModel?.id == null) {
                  await controller.createGoods(goodsModels);
                  await controller.goodsLists();
                } else {
                  await controller.updateGoods(goodsModels);
                  await controller.goodsLists();
                }
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (c) {
                  return const Home();
                }), (route) => false);
              }
            },
            text: goodsModel?.id != null ? "Edit Barang" : "Tambah Barang"),
      ),
    );
  }
}
