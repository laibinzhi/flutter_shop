import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryListData> goodsList = [];

  getCategoryGoodsList(List<CategoryListData> list) {
    goodsList = list;
    notifyListeners();
  }

  getMoreList(List<CategoryListData> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
