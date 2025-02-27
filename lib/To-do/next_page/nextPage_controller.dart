// controllers/todo_controller.dart
import 'dart:convert';
import 'package:currency_converter/To-do/next_page/next_page_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TodoController {
  List<Todo> todos = [];
  List<String> assignees = [];
  String? selectedAssignee;
  String selectedStatus = 'Open';
  String selectedPriority = 'Level 1';

  Future<void> setToken(BuildContext context) async {
    var share = await SharedPreferences.getInstance();
    var token = share.getString('token');
    try {
      final response = await http.get(
        Uri.parse('https://dev-api-v2.s3-app.com/api/v1/usermanagement/superadmin?type=customer'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        List<dynamic> data = result['data'];

        List<String> fullNames = data.map((user) => user['fullname'] as String).toList();
        assignees = fullNames;
        selectedAssignee = assignees.isNotEmpty ? assignees.first : null;
      } else {
        // Handle error response
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void addOrUpdateTodo({
    required Todo todo,
    required bool isEditing,
    required int? editingIndex,
  }) {
    if (isEditing && editingIndex != null) {
      todos[editingIndex] = todo;
    } else {
      todos.add(todo);
    }
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
  }
}
