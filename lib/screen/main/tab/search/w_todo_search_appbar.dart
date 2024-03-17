import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/w_text_field_with_delete.dart';
import 'package:fast_app_base/data/memory/todo_data.dart';
import 'package:flutter/material.dart';

class TodoSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;

  const TodoSearchAppBar({required this.controller, super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  State<StatefulWidget> createState() => _TodoSearchAppBarState();
}

class _TodoSearchAppBarState extends State<TodoSearchAppBar> with TodoDataProvider{
  final node = FocusNode();

  @override
  void initState() {
    widget.controller.addListener(() {

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWithDelete(
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            focusNode: node,
            texthint: '검색어를 입력하세요',
            onEditingComplete: () {
              todoData.searchTodo(widget.controller.text);
              widget.controller.text = '';
              AppKeyboardUtil.hide(context);
            },
          ).pOnly(left: 10, top: 6),
        ),
        const Icon(Icons.search),
      ],
    );
  }
}
