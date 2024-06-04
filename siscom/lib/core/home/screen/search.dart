import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:siscom/common/util/format_rupiah.dart';
import 'package:siscom/common/widgets/text_formfield.dart';
import 'package:siscom/core/home/controller/database_controller.dart';

import '../../../common/widgets/button.dart';
import '../data/model/goods_model.dart';
import '../widget/bottom_sheet.dart';
import '../widget/cards.dart';
import 'add_update.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    

    return GetBuilder<DatabaseController>(
      init: DatabaseController(),
      builder: (DatabaseController controller) => Scaffold(
          appBar: AppBar(
            title: CustomTextField(
                onChange: (v) {
                  controller.goodsListsSearch(v!);
                },
                controller: search,
                hintText: "Cari data"),
          ),
          body: ListView.builder(
            itemCount: controller.goodsList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index != controller.goodsList.length
                  ? InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          isScrollControlled: true, // to full height
                          useSafeArea: true, // to show under status bar
                          backgroundColor: Colors
                              .white, // to show BorderRadius of Container
                          context: context,
                          builder: (BuildContext context) {
                            return IOSModalStyle(
                              childBody: Center(
                                  child: Column(
                                children: [
                                  Image.file(
                                    File(controller
                                        .goodsList[index].goodsImage!),
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: Column(
                                      children: [
                                        Cards(
                                            title: "Nama Barang",
                                            description: controller
                                                .goodsList[index].goodsName!),
                                        Cards(
                                            title: "Kategori",
                                            description: controller
                                                .goodsList[index].categoryID
                                                .toString()),
                                        Cards(
                                            title: "Kelompok",
                                            description: controller
                                                .goodsList[index].goodsGroup
                                                .toString()),
                                        Cards(
                                            isLast: true,
                                            title: "Stok",
                                            description: controller
                                                .goodsList[index].stock
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Harga"),
                                          Text(
                                              'Rp.${RupiahFormat.formatRupiah(controller.goodsList[index].price!)}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          color: Colors.white,
                                          colorText: Colors.red,
                                          onPressed: () {
                                            controller.deleteByID(controller
                                                .goodsList[index].id!);
                                            controller.goodsLists();
                                            Get.back();
                                          },
                                          text: "Hapus",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          color: Colors.indigo.shade900,
                                          onPressed: () {
                                            Get.to(AddUpdateGoods());
                                          },
                                          text: "Edit Barang",
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    controller.isShowCheckBox
                                        ? Checkbox(
                                            side: const BorderSide(
                                                color: Colors.grey),
                                            value: controller
                                                .goodsList[index].isChechked,
                                            onChanged: (value) {
                                              controller
                                                  .selectGoodsbyID(value!);
                                              controller.goodsList[index]
                                                      .isChechked =
                                                  controller.isChechked;
          
                                              if (controller.goodsList[index]
                                                  .isChechked) {
                                                controller.collectGoodsID.add(
                                                    controller
                                                        .goodsList[index]
                                                        .id!);
                                              } else {
                                                controller.collectGoodsID
                                                    .removeWhere((element) =>
                                                        element ==
                                                        controller
                                                            .goodsList[index]
                                                            .id);
                                              }
                                            },
                                          )
                                        : const SizedBox(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(controller
                                            .goodsList[index].goodsName!),
                                        Text(
                                            'Stok: ${controller.goodsList[index].stock.toString()}'),
                                        Text(
                                            'Kategori ID: ${controller.goodsList[index].categoryID.toString()}'),
                                        Text(
                                            'Kelompok: ${controller.goodsList[index].goodsGroup.toString()}'),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                        'Rp. ${RupiahFormat.formatRupiah(controller.goodsList[index].price!)}'),
                                    Row(
                                      children: [
                                        IconButton(
                                        onPressed: () async {
                                          final item =
                                              controller.goodsList[index];
          
                                          final goodsModel = GoodsModel(
                                              id: item.id,
                                              goodsImage: item.goodsImage,
                                              goodsName: item.goodsName,
                                              categoryID: item.categoryID,
                                              goodsGroup: item.goodsGroup,
                                              stock: item.stock,
                                              price: item.price);
                                          Get.to(AddUpdateGoods(),
                                              arguments: goodsModel);
                                        },
                                        icon: const Icon(
                                            Icons.edit_calendar_rounded)),
                                    IconButton(
                                        onPressed: () {
                                          controller.deleteByID(controller
                                              .goodsList[index].id!);
                                          controller.goodsLists();
                                        },
                                        icon: const Icon(Icons.delete))
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: controller.goodsList.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                controller.goodsLists();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'Refresh untuk melihat data lainnya',
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              ),
                            )
                          : const Center(
                              child: Text('Data tidak tersedia'),
                            ));
            },
          )),
    );
  }
}
