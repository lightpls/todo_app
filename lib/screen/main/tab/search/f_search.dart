import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/color_extension.dart';
import 'package:flutter/material.dart';

import 'w_search_result.dart';
import 'w_todo_search_appbar.dart';

class SearchFragment extends StatefulWidget {
  const SearchFragment({super.key});

  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.searchColor.getSwatchByBrightness(100),
      appBar: TodoSearchAppBar(controller: controller,),
      body: ListView(
        children: [
          SearchResult(),
          const Placeholder(),
        ],
      ),
    );
  }
}
