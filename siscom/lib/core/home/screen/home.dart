import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:siscom/common/util/format_rupiah.dart';
import 'package:siscom/common/widgets/button.dart';
import 'package:siscom/core/home/controller/database_controller.dart';
import 'package:siscom/core/home/data/model/categories_model.dart';
import 'package:siscom/core/home/data/model/goods_model.dart';
import 'package:siscom/core/home/screen/search.dart';
import 'package:siscom/core/home/widget/cards.dart';

import '../widget/bottom_sheet.dart';
import 'add_update.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          height: 60,
          width: 120,
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: Colors.indigo.shade900,
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (c) {
                return AddUpdateGoods();
              }));
              final goodsModel = GoodsModel(
                  id: UniqueKey().hashCode,
                  goodsName: "Motor",
                  categoryID: 1,
                  stock: 3,
                  goodsGroup: "Kendaraan",
                  price: 10000);
              await Get.find<DatabaseController>().createGoods(goodsModel);
              await Get.find<DatabaseController>().goodsLists();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  'Barang',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('List Stock Barang'),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => Search());
                },
                icon: Icon(Icons.search)),
          ],
        ),
        body: GetBuilder<DatabaseController>(
          init: DatabaseController(),
          builder: (DatabaseController controller) => RefreshIndicator(
            onRefresh: controller.goodsLists,
            child: Column(
              children: [
                controller.goodsList.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${controller.goodsList.length} Data ditampilkan'),
                            controller.isShowCheckBox
                                ? const SizedBox()
                                : TextButton(
                                    onPressed: () {
                                      controller.showCheckBox();
                                    },
                                    child: const Text(
                                      "Edit Data",
                                      style: TextStyle(color: Colors.blue),
                                    ))
                          ],
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: ListView.builder(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey.shade400),
                                            ),
                                            child: Column(
                                              children: [
                                                Cards(
                                                    title: "Nama Barang",
                                                    description: controller
                                                        .goodsList[index]
                                                        .goodsName!),
                                                Cards(
                                                    title: "Kategori",
                                                    description: controller
                                                        .goodsList[index]
                                                        .categoryID
                                                        .toString()),
                                                Cards(
                                                    title: "Kelompok",
                                                    description: controller
                                                        .goodsList[index]
                                                        .goodsGroup
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                    controller.deleteByID(
                                                        controller
                                                            .goodsList[index]
                                                            .id!);
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
                                                    Get.back();
                                                    Get.to(
                                                        () => AddUpdateGoods(),
                                                        arguments: controller
                                                            .goodsList.first);
                                                    
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
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
                                                        .goodsList[index]
                                                        .isChechked,
                                                    onChanged: (value) {
                                                      controller
                                                          .selectGoodsbyID(
                                                              value!);
                                                      controller
                                                              .goodsList[index]
                                                              .isChechked =
                                                          controller.isChechked;

                                                      if (controller
                                                          .goodsList[index]
                                                          .isChechked) {
                                                        controller
                                                            .collectGoodsID
                                                            .add(controller
                                                                .goodsList[
                                                                    index]
                                                                .id!);
                                                      } else {
                                                        controller
                                                            .collectGoodsID
                                                            .removeWhere(
                                                                (element) =>
                                                                    element ==
                                                                    controller
                                                                        .goodsList[
                                                                            index]
                                                                        .id);
                                                      }
                                                    },
                                                  )
                                                : const SizedBox(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(controller.goodsList[index]
                                                    .goodsName!),
                                                Text(
                                                    'Stok: ${controller.goodsList[index].stock.toString()}'),
                                                Text(
                                                    'Rp. ${RupiahFormat.formatRupiah(controller.goodsList[index].price!)}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      final item = controller
                                                          .goodsList[index];

                                                      final goodsModel =
                                                          GoodsModel(
                                                              id: item.id,
                                                              goodsImage: item
                                                                  .goodsImage,
                                                              goodsName: item
                                                                  .goodsName,
                                                              categoryID: item
                                                                  .categoryID,
                                                              goodsGroup: item
                                                                  .goodsGroup,
                                                              stock: item.stock,
                                                              price:
                                                                  item.price);
                                                      Get.to(AddUpdateGoods(),
                                                          arguments:
                                                              goodsModel);
                                                    },
                                                    icon: const Icon(Icons
                                                        .edit_calendar_rounded)),
                                                IconButton(
                                                    onPressed: () {
                                                      controller.deleteByID(
                                                          controller
                                                              .goodsList[index]
                                                              .id!);
                                                      controller.goodsLists();
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
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
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.arrow_upward),
                                        Text('Tarik untuk muat data lainnya')
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Stok barang belum ada'),
                                    ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<DatabaseController>(
            init: DatabaseController(),
            builder: (DatabaseController controller) => controller
                    .isShowCheckBox
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              side: const BorderSide(color: Colors.grey),
                              value: controller.isSelectAll,
                              onChanged: (value) {
                                if (controller.isSelectAll) {
                                  controller.checkedAllGoodsCancel(
                                      controller.goodsList);
                                } else {
                                  controller
                                      .checkedAllGoods(controller.goodsList);
                                }
                              },
                            ),
                            Text(controller.isSelectAll
                                ? 'Batal Pilih semua'
                                : 'Pilih semua')
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                side: BorderSide(color: Colors.grey.shade400)),
                            onPressed: () {
                              controller.deleteAllGoods();
                              controller.goodsLists();
                              controller.showCheckBox();
                            },
                            child: const Text(
                              'Hapus Barang',
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ),
                  )
                : const SizedBox()));
  }
}
