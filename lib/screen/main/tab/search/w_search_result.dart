import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'search_history_data.dart';

class SearchResult extends StatelessWidget {
  SearchResult({super.key});

  late final searchData = Get.find<SearchHistoryData>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() =>
            ListView(
              children: searchData.searchHistoryList
                  .map((element) => Text(element))
                  .toList(),
            ),
        )
      ],
    );
  }
}