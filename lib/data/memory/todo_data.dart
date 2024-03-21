import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/common/data/preference/prefs.dart';
import 'package:fast_app_base/common/util/async/flutter_async.dart';
import 'package:fast_app_base/data/local/error/local_db_error.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/data/simple_result.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:fast_app_base/screen/dialog/d_message.dart';
import 'package:fast_app_base/screen/main/write/d_write_todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

import '../local/local_db.dart';

class TodoData extends GetxController {
  final RxList<Todo> todoList = <Todo>[].obs;
  final RxList<Todo> searchList = <Todo>[].obs;
  RxList<String> searchHistory = <String>[].obs;
  final RxBool isLoaded = false.obs;

  final todoRepository = LocalDB.instance;

  List<String>? _searchHistory;

  @override
  void onInit() async {
    final remoteTodoList = await todoRepository.getTodoList();
    isLoaded.value = true;
    remoteTodoList.runIfSuccess((data) {
      todoList.addAll(data);
    });
    remoteTodoList.runIfFailure((error) {
      delay(() {
        MessageDialog(error.message).show();
      }, 100.ms);
    });

    _searchHistory = Prefs.searchHistoryList.get();
    _searchHistory ??= <String>[];
    searchHistory.value = _searchHistory!;

    super.onInit();
  }

  int get newId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void addTodo(BuildContext context) async {
    final result = await WriteTodoBottomSheet().show();
    result?.runIfSuccess((data) async {
      final newTodo = Todo(
        id: newId,
        title: data.title,
        dueDate: data.dueDate,
        createdTime: DateTime.now(),
        status: TodoStatus.incomplete,
      );
      final requestResult = await todoRepository.addTodo(newTodo);
      requestResult.runIfSuccess((data) => todoList.add(newTodo));
      requestResult.runIfFailure((error) {
        MessageDialog(error.message).show();
      });
    });
  }

  void changeTodoStatus(Todo todo) async {
    TodoStatus nextStatus = todo.status;
    switch (todo.status) {
      case TodoStatus.complete:
        final result = await ConfirmDialog('다시 처음 상태로 변경하시겠어요?').show();
        if (result?.isFailure == true) {
          return;
        }
        result?.runIfSuccess((data) {
          nextStatus = TodoStatus.incomplete;
        });
      case TodoStatus.incomplete:
        nextStatus = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        nextStatus = TodoStatus.complete;
      case TodoStatus.unknown:
        return;
    }
    final Todo todoForSave = todo.copyWith(status: nextStatus);
    final responseResult = await todoRepository
        .updateTodo(todoForSave); //객체 안의 status 바꿔서 update요청
    processResponseResult(responseResult, todoForSave);
  }

  editTodo(Todo todo) async {
    final result = await WriteTodoBottomSheet(todoForEdit: todo).show();
    final Todo todoForSave = todo.copyWith();

    result?.runIfSuccess((data) async {
      todoForSave.modifyTime = DateTime.now();
      todoForSave.title = data.title;
      todoForSave.dueDate = data.dueDate;

      final responseResult = await todoRepository.updateTodo(todoForSave);
      processResponseResult(responseResult, todoForSave);
    });
  }

  void processResponseResult(
      SimpleResult<void, LocalDBError> result, Todo updatedTodo) {
    result.runIfSuccess((data) {
      updateTodo(updatedTodo);
      updateSearchTodo(updatedTodo);
    });
    result.runIfFailure((error) => MessageDialog(error.message).show());
  }

  void removeTodo(Todo todo) {
    todoList.remove(todo);
    todoRepository.removeTodo(todo.id);
  }

  updateTodo(Todo updatedTodo) {
    final todo = todoList.firstWhere((element) => element.id == updatedTodo.id);
    todo
      ..title = updatedTodo.title
      ..status = updatedTodo.status
      ..dueDate = updatedTodo.dueDate;

    todoList.refresh();
  }

  updateSearchTodo(Todo updatedTodo) {
    final todo = searchList.firstWhere((element) => element.id == updatedTodo.id);
    todo
      ..title = updatedTodo.title
      ..status = updatedTodo.status
      ..dueDate = updatedTodo.dueDate;

    searchList.refresh();
  }
  void searchTodo(String query) async {
    final requestResult = await todoRepository.searchTodo(query);

    requestResult.runIfSuccess((data) {
      searchList.clear();
      searchList.addAll(data);

      if (_searchHistory!.contains(query) == false) {
        _searchHistory!.add(query);

        searchHistory.value = _searchHistory!;
        searchHistory.refresh();

        Prefs.searchHistoryList.set(_searchHistory);
      }
    });

    requestResult.runIfFailure((error) {
      MessageDialog(error.message).show();
    });
  }
}

mixin class TodoDataProvider {
  late final TodoData todoData = Get.find();
}
