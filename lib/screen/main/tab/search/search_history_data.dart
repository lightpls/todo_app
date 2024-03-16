import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchHistoryData extends GetxController {

  RxList<String> searchHistoryList = <String>[].obs;

  @override
  void onInit() {
    searchHistoryList.addAll(['할일1', '할일2']);
    super.onInit();
  }

  void addHistory(String text) {
    if (searchHistoryList.contains(text) == false) {
      searchHistoryList.add(text);
      debugPrint('add search history : $text');
      debugPrint('searchHistoryList : $searchHistoryList');
    }
  }
}