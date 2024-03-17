import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Memo {
  Memo(String _content) {
    this.content = _content;
    this.created_at = DateTime.now();
  }

  String content = '';
  DateTime? created_at;
  DateTime? updated_at;

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
  final deletedList = <Memo>{};

  void _handleMemoRead(Memo memo, bool read) {
    setState(() {
      if (!read) {
        readList.add(memo);
      } else {
        readList.remove(memo);
      }
    });
  }

  void _handleMemoDelete(Memo memo, bool delete) {
    setState(() {
      if (!delete) {
        widget.memos.add(memo);
        deletedList.remove(memo);
      } else {
        widget.memos.remove(memo);
        deletedList.add(memo);
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
              memoReadCallback: _handleMemoRead,
              memoDeleteCallback: _handleMemoDelete);
        }).toList(),
      ),
    );
  }
}

typedef MemoReadCallback = Function(Memo memo, bool read);
typedef MemoDeleteCallback = Function(Memo memo, bool delete);

class MemoListItem extends StatelessWidget {
  MemoListItem(
      {required this.memo,
      required this.read,
      required this.memoReadCallback,
      required this.memoDeleteCallback});

  final Memo memo;
  final bool read;
  final MemoReadCallback memoReadCallback;
  final MemoDeleteCallback memoDeleteCallback;

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
      isThreeLine: true,
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
      subtitle: Text(
        DateFormat('yyyy-MM-dd hh:mm')
            .format((memo.updated_at ?? memo.created_at) as DateTime),
        style: _getTextStyle(context),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (String? value) {
          if (value == 'delete') {
            memoDeleteCallback(memo, true);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    '수정',
                  ),
                )
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text('삭제'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
