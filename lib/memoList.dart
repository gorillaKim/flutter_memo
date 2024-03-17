import 'package:flutter/material.dart';

class Memo {
  Memo(String _content) {
    this.content = _content;
    this.created_at = DateTime.now();
  }

  String content = '';
  bool? deleted = false;
  DateTime? created_at;
  DateTime? updated_at;

  void delete() {
    deleted = false;
    updated_at = DateTime.now();
  }

  void restore() {
    deleted = true;
    updated_at = DateTime.now();
  }

  void edit(String _content) {
    content = _content;
    updated_at = DateTime.now();
  }
}

class MemoList extends StatefulWidget {
  const MemoList({required this.memos, super.key});

  final List<Memo> memos;

  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  final readList = <Memo>{};

  void _handleMemoRead(Memo memo, bool read) {
    setState(() {
      if (!read) {
        readList.add(memo);
      } else {
        readList.remove(memo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo list'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: widget.memos.map((memo) {
          return MemoListItem(
              memo: memo,
              read: readList.contains(memo),
              memoReadCallback: _handleMemoRead);
        }).toList(),
      ),
    );
  }
}

typedef MemoReadCallback = Function(Memo memo, bool read);

class MemoListItem extends StatelessWidget {
  MemoListItem(
      {required this.memo, required this.read, required this.memoReadCallback});

  final Memo memo;
  final bool read;
  final MemoReadCallback memoReadCallback;

  Color _getColor(BuildContext context) {
    return read //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!read) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        memoReadCallback(memo, read);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(memo.content[0]),
      ),
      title: Text(
        memo.content,
        style: _getTextStyle(context),
      ),
    );
  }
}
