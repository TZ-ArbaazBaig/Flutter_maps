import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  List<String> _assignees = [];

  File? image;
  String imagePath = '';

  Future<void> imagePicker(index) async {
    final pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickFile != null) {
        image = File(pickFile.path);
        imagePath = pickFile.path;
        todos[index]['imagePath'] = imagePath;
      } else {
        if (kDebugMode) {
          print("no image picker");
        }
      }
    });
  }

  final List<Map<String, dynamic>> todos = [
    {
      "id": 1,
      'title': 'Design homepage',
      'description': 'Create wireframes for the homepage',
      'estimatedHours': 5,
      'assignee': 'null',
      'status': 'Open',
      'priority': 'Level 1',
      "imagePath": ""
    },
    {
      "id": 2,
      'title': 'Fix login bug',
      'description': 'Resolve login button not working',
      'estimatedHours': 3,
      'assignee': 'null',
      'status': 'In Progress',
      'priority': 'Level 2',
      "imagePath": ""
    },
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedHoursController = TextEditingController();

  String? _selectedAssignee = '';
  String _selectedStatus = 'Open';
  String _selectedPriority = 'Level 1';

  bool _isEditing = false;
  int? _editingIndex;

  final List<String> _statuses = [
    'Open',
    'New',
    'In Progress',
    'Review',
    'Completed'
  ];
  final List<String> _priorities = ['Level 1', 'Level 2', 'Level 3'];

  String _searchQuery = "";

  List<String> _selectedStatuses = [];
  List<String> _selectedPriorities = [];

  @override
  void initState() {
    super.initState();
    setToken();
  }

  Future<void> setToken() async {
    var share = await SharedPreferences.getInstance();
    var token = share.getString('token');
    if (kDebugMode) {
      print('Token: $token');
    }
    try {
      final response = await http.get(
        Uri.parse(
            'https://dev-api-v2.s3-app.com/api/v1/usermanagement/superadmin?type=customer'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        List<dynamic> data = result['data'];

        List<String> fullNames =
            data.map((user) => user['fullname'] as String).toList();
        setState(() {
          _assignees = fullNames.toSet().toList();
          _selectedAssignee = _assignees.isEmpty ? _assignees.first : null;
          if (kDebugMode) {
            print('Assignee $_assignees');

            print('Selected $_selectedAssignee');
          }
        });
      } else {
        if (kDebugMode) {
          print('Failed to fetch data: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _estimatedHoursController.clear();
    // _selectedAssignee = _assignees.isNotEmpty ? _selectedAssignee : null;
    _selectedAssignee = null;
    _selectedPriority = _priorities.first;
  }

  void _addOrUpdateTodo() {
    if (_formKey.currentState!.validate()) {
      final todo = {
        'id': _isEditing ? todos[_editingIndex!]['id'] : todos.length + 1,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'estimatedHours': int.parse(_estimatedHoursController.text),
        'assignee': _selectedAssignee,
        'status': _selectedStatus,
        'priority': _selectedPriority,
      };

      setState(() {
        if (_isEditing) {
          todos[_editingIndex!] = todo;
          _isEditing = false;
          _editingIndex = null;
        } else {
          todos.add(todo);
        }
      });

      _resetForm();
      Navigator.of(context).pop();
    }
  }

  void _editTodo(int index, String current) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;

      final todo = todos[index];
      _titleController.text = todo['title'];
      _descriptionController.text = todo['description'];
      _estimatedHoursController.text = todo['estimatedHours'].toString();
      // _selectedAssignee = _selectedAssignee;
      _selectedAssignee = todo['assignee'] != 'null' ? todo['assignee'] : null;
      _selectedStatus = todo['status'];
      _selectedPriority = todo['priority'];
    });

    _showTodoForm();
  }

  void _deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void adding() {
    setState(() {
      _isEditing = false;
    });
    _showTodoForm();
  }

  void _showTodoForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Title is required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Description is required' : null,
                ),
                TextFormField(
                  controller: _estimatedHoursController,
                  decoration:
                      const InputDecoration(labelText: 'Estimated Hours'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Estimated Hours is required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedAssignee,
                  decoration: const InputDecoration(labelText: 'Assignee'),
                  items: _assignees.isEmpty
                      ? null
                      : _assignees
                          .map((assignee) => DropdownMenuItem(
                                value: assignee,
                                child: Text(assignee),
                              ))
                          .toList(),
                  onChanged: (value) => setState(() {
                    _selectedAssignee = value!;
                  }),
                  validator: (value) =>
                      value == null ? 'Please select an assignee' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: _statuses
                      .map((status) =>
                          DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedStatus = value!;
                  }),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration:
                      const InputDecoration(labelText: 'Priority Level'),
                  items: _priorities
                      .map((priority) => DropdownMenuItem(
                          value: priority, child: Text(priority)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedPriority = value!;
                  }),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addOrUpdateTodo,
                  child: Text(_isEditing ? 'Update' : 'Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredTodos {
    return todos.where((todo) {
      final matchesSearch =
          todo['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              todo['id'].toString().contains(_searchQuery);
      final matchesStatus = _selectedStatuses.isEmpty ||
          _selectedStatuses.contains(todo['status']);
      final matchesPriority = _selectedPriorities.isEmpty ||
          _selectedPriorities.contains(todo['priority']);

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  void showImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.8,
                        maxWidth: constraints.maxWidth * 0.8,
                      ),
                      child: Image.file(File(imagePath), fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  //Filter options
  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MultiSelectDialogField(
              items: _statuses
                  .map((status) => MultiSelectItem(status, status))
                  .toList(),
              title: const Text('Select Status'),
              buttonText: const Text('Filter by Status'),
              initialValue: _selectedStatuses,
              onConfirm: (values) =>
                  setState(() => _selectedStatuses = List<String>.from(values)),
            ),
            const SizedBox(height: 10),
            MultiSelectDialogField(
              items: _priorities
                  .map((priority) => MultiSelectItem(priority, priority))
                  .toList(),
              title: const Text('Select Priority'),
              buttonText: const Text('Filter by Priority'),
              initialValue: _selectedPriorities,
              onConfirm: (values) => setState(
                  () => _selectedPriorities = List<String>.from(values)),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _selectedStatuses.clear();
                  _selectedPriorities.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Clear",
              )),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search Box
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by ID or Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter Button
                ElevatedButton(
                  onPressed: _openFilterDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  child: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),

          //Displaying the List
          _filteredTodos.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                  
                    itemCount: _filteredTodos.length,
                    itemBuilder: (_, index) {
                      final todo = _filteredTodos[index];
                      return Card(
                    
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                       
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
      
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text(
                                'ID: ${todo['id']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Title: ${todo['title']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text('Description: ${todo['description']}'),
                              Text(
                                  'Estimated Hours: ${todo['estimatedHours']}'),
                              Text('Assignee: ${todo['assignee']}'),
                              Text('Status: ${todo['status']}'),
                              Text('Priority Level: ${todo['priority']}'),
                              todo['imagePath'] != null &&
                                      todo['imagePath'].isNotEmpty
                                  ? InkWell(
                                      onTap: () => showImage(todo[
                                          'imagePath']), // Open image popup on tap
                                      child: Text(
                                        'Image: ${todo['imagePath']}', // Display image path as a clickable link
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : const Text('Image: null'),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        _editTodo(index, '${todo['assignee']}'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteTodo(index),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.photo),
                                      onPressed: () => imagePicker(index)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("no data found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: adding,
        child: const Icon(Icons.add),
      ),
    );
  }
}
