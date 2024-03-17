class Memo {
  Memo(this.memo) {
    created_at = DateTime.now();
  }

  String memo;
  DateTime? created_at;
  DateTime? updated_at;
  bool deleted = false;

  void delete() {
    deleted = false;
    updated_at = DateTime.now();
  }

  void restore() {
    deleted = true;
    updated_at = DateTime.now();
  }

  void edit(String newMemo) {
    memo = newMemo;
    updated_at = DateTime.now();
  }
}
