import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/data/memory/todo_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../todo/w_todo_item.dart';

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> with TodoDataProvider {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: todoData.searchList.isEmpty
              ? todoData.todoList.map((e) => TodoItem(todo: e)).toList()
              : todoData.searchList.map((e) => TodoItem(todo: e)).toList(),
        ).pSymmetric(h: 10.0),
      ),
    );
  }
}
