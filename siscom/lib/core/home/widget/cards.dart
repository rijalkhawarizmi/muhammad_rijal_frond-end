import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siscom/core/home/data/model/categories_model.dart';
import 'package:siscom/core/home/data/model/goods_model.dart';

class Cards extends StatelessWidget {
  const Cards({super.key,required this.title,required this.description,this.isLast=false});
  final String title;
  final String description;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: isLast ? Colors.white: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(description),
        ],
      ),
    );
  }
}
