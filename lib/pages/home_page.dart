import 'package:flutter/material.dart';
import 'package:todo/models/todo_mode.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ToDo>> futureToDo;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureToDo = ToDoService().getToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOs'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ToDo>>(
              future: futureToDo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final List<ToDo> todoList = snapshot.data!;
                  return ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(todoList[index].todo),
                      );
                    },
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new todo item',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String newTodo = _textController.text;
                    ToDoService().createTodoItem(newTodo, true);
                    setState(() {
                      futureToDo = ToDoService().getToDo();
                    });
                    _textController.clear();
                  },
                  child: const Text('Add Todo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
