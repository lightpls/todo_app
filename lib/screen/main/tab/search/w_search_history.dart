import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/data/memory/todo_data.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class SearchHistory extends StatefulWidget {
  final TextEditingController controller;

  const SearchHistory({super.key, required this.controller});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> with TodoDataProvider {

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Row(
              children: todoData.searchHistory
                  .map((query) => SizedBox(
                          width: query.length * 20,
                          child: TextButton(
                              onPressed: () {
                                todoData.searchTodo(query);
                                widget.controller.text = query;
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: context.appColors.textButtonBackground),
                              child: Text(query,
                                  style: TextStyle(color: context.appColors.text))))
                      .pOnly(right: 5))
                  .toList())
          .pOnly(left: 10),
    );
  }
}
