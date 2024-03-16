import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/w_text_field_with_delete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widget/w_arrow.dart';
import 'search_history_data.dart';

class TodoSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;

  const TodoSearchAppBar({required this.controller, super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  State<StatefulWidget> createState() => _TodoSearchAppBarState();
}

class _TodoSearchAppBarState extends State<TodoSearchAppBar> {

  late final searchData = Get.find<SearchHistoryData>();

  @override
  void initState() {
    Get.put(SearchHistoryData());
    widget.controller.addListener(() {

    });

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SearchHistoryData>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tap(
            onTap: () => Nav.pop(context),
            child: const SizedBox(
                width: 56,
                height: kToolbarHeight,
                child: Arrow(
                  direction: AxisDirection.left,
                ))),
        Expanded(
          child: TextFieldWithDelete(
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            texthint: '검색어를 입력하세요',
            onEditingComplete: (){
              searchData.addHistory(widget.controller.text);
              widget.controller.text = '';
              AppKeyboardUtil.hide(context);
            },
          ).pOnly(top: 6),
        ),//
        width20,
      ],
    );
  }
}

