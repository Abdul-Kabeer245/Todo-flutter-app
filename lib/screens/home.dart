import 'package:flutter/material.dart';
import 'package:myapp/constants/colors.dart';
import 'package:myapp/model/db_helper.dart';
import 'package:myapp/model/todo.dart';
import 'package:myapp/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  final DbHelper _dbHelper = DbHelper();
  List<ToDo> _foundTodo = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _dbHelper.todos();
    setState(() {
      _foundTodo = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBG,
      appBar: _appBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 20),
                      child: const Text(
                        'All Tasks',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    for (ToDo todos in _foundTodo)
                      TodoItem(
                        todo: todos,
                        onToDoChanged: _handleTodoChange,
                        onToDoDelete: _handleTodoDelete,
                      ),
                  ],
                ))
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a new task',
                        ),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  height: 60,
                  width: 60,
                  color: tdBlue,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      _addTodo();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(right: 0),
                      backgroundColor: tdBlue,
                      elevation: 10,
                      minimumSize: const Size(60, 60),
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleTodoChange(ToDo todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    await _dbHelper.updateToDo(todo);
    _loadTodos();
  }

  void _handleTodoDelete(int id) async {
    await _dbHelper.deleteToDo(id);
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodo() async {
    final todoText = _todoController.text;
    if (todoText.isEmpty) return;
    final newTodo =
        ToDo(id: DateTime.now().millisecondsSinceEpoch, todoText: todoText);

    await _dbHelper.insertTodo(newTodo);
    _todoController.clear();
    _loadTodos();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundTodo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          hintText: 'Search',
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: tdBG,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Image(
                image: AssetImage("assets/images/abdul.jpg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
