class ToDo {
  int id;
  String? todoText;
  late bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'todoText': todoText, 'isDone': isDone ? 1 : 0};
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
        id: map['id'], todoText: map['todoText'], isDone: map['isDone'] == 1);
  }

  static List<ToDo> todoList() {
    return [
      ToDo(
        id: 1,
        todoText: 'Buy groceries',
        isDone: false,
      ),
      ToDo(
        id: 2,
        todoText: 'Walk the dog',
        isDone: true,
      ),
      ToDo(
        id: 3,
        todoText: 'Read a book',
        isDone: false,
      ),
    ];
  }
}
