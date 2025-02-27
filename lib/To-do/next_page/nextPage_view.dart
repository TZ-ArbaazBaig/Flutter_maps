// views/todo_list_page.dart
import 'package:currency_converter/To-do/next_page/nextPage_controller.dart';
import 'package:currency_converter/To-do/next_page/next_page_model.dart';
import 'package:flutter/material.dart';


class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  final TodoController _controller = TodoController();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedHoursController = TextEditingController();

  bool _isEditing = false;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _controller.setToken(context);
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _estimatedHoursController.clear();
  }

  void _addOrUpdateTodo() {
    if (_formKey.currentState!.validate()) {
      final todo = Todo(
        id: _isEditing ? _controller.todos[_editingIndex!].id : _controller.todos.length + 1,
        title: _titleController.text,
        description: _descriptionController.text,
        estimatedHours: int.parse(_estimatedHoursController.text),
        assignee: _controller.selectedAssignee,
        status: _controller.selectedStatus,
        priority: _controller.selectedPriority,
      );

      setState(() {
        _controller.addOrUpdateTodo(
          todo: todo,
          isEditing: _isEditing,
          editingIndex: _editingIndex,
        );
      });

      _resetForm();
      Navigator.of(context).pop();
    }
  }

  void _editTodo(int index) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;

      final todo = _controller.todos[index];
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
      _estimatedHoursController.text = todo.estimatedHours.toString();
      _controller.selectedAssignee = todo.assignee;
      _controller.selectedStatus = todo.status;
      _controller.selectedPriority = todo.priority;
    });

    _showTodoForm();
  }

  void _deleteTodo(int index) {
    setState(() {
      _controller.deleteTodo(index);
    });
  }

  void _showTodoForm() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              TextFormField(
                controller: _estimatedHoursController,
                decoration: const InputDecoration(labelText: 'Estimated Hours'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Estimated Hours is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _controller.selectedAssignee,
                decoration: const InputDecoration(labelText: 'Assignee'),
                items: _controller.assignees
                    .map((assignee) => DropdownMenuItem(
                          value: assignee,
                          child: Text(assignee),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.selectedAssignee = value!;
                }),
                validator: (value) => value == null ? 'Please select an assignee' : null,
              ),
              DropdownButtonFormField<String>(
                value: _controller.selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Open', 'In Progress', 'Completed']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.selectedStatus = value!;
                }),
              ),
              DropdownButtonFormField<String>(
                value: _controller.selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: ['Level 1', 'Level 2', 'Level 3']
                    .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.selectedPriority = value!;
                }),
              ),
              ElevatedButton(
                onPressed: _addOrUpdateTodo,
                child: Text(_isEditing ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isEditing = false;
          });
          _showTodoForm();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _controller.todos.length,
        itemBuilder: (context, index) {
          final todo = _controller.todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.status),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTodo(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTodo(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
