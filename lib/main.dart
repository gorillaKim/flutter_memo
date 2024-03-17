import 'package:flutter/material.dart';
import 'memoList.dart';

void main() {
  runApp(MaterialApp(
    title: 'Shopping App',
    home: MemoList(
      memos: [Memo("TEST1"), Memo("TEST2"), Memo("TEST3")],
    ),
  ));
}
