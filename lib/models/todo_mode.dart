import 'dart:convert';
import 'package:http/http.dart' as http;

class ToDo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const ToDo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }
}

class ToDoService {
  Future<List<ToDo>> getToDo() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/todos'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<ToDo> list = [];
      for (var i = 0; i < data['todos'].length; i++) {
        final entry = data['todos'][i];
        list.add(ToDo.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('Http failed');
    }
  }

  Future<void> createTodoItem(String title, bool completed) async {
    var url = 'https://dummyjson.com/todos/add';
    final Map<String, dynamic> body = {
      'todo': title,
      'completed': completed.toString(),
      'userId': 5
    };
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('Todo item created successfully');
    } else {
      print('Failed to create todo item');
    }
  }
}
