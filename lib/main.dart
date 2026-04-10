  // import 'package:flutter/material.dart';
  // import 'package:shared_preferences/shared_preferences.dart';
  // import 'dart:convert';
  // import 'package:intl/intl.dart';
  // import 'task.dart';

  // void main() {
  //   runApp(const MyApp());
  // }

  // class MyApp extends StatelessWidget {
  //   const MyApp({super.key});

  //   @override
  //   Widget build(BuildContext context) {
  //     return MaterialApp(
  //       title: 'Nhắc Việc',
  //       debugShowCheckedModeBanner: false,
  //       theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
  //       home: const TaskListScreen(),
  //     );
  //   }
  // }

  // class TaskListScreen extends StatefulWidget {
  //   const TaskListScreen({super.key});

  //   @override
  //   State<TaskListScreen> createState() => _TaskListScreenState();
  // }

  // class _TaskListScreenState extends State<TaskListScreen> {
  //   List<Task> tasks = [];
  //   List<Task> filteredTasks = [];
  //   final TextEditingController searchController = TextEditingController();

  //   @override
  //   void initState() {
  //     super.initState();
  //     _loadTasks();
  //     searchController.addListener(_filterTasks);
  //   }

  //   Future<void> _loadTasks() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final String? data = prefs.getString('tasks');
  //     if (data != null) {
  //       final List<dynamic> jsonList = json.decode(data);
  //       setState(() {
  //         tasks = jsonList.map((e) => Task.fromJson(e)).toList();
  //         tasks.sort((a, b) => a.time.compareTo(b.time));
  //         filteredTasks = List.from(tasks);
  //       });
  //     }
  //   }

  //   Future<void> _saveTasks() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final String data = json.encode(tasks.map((e) => e.toJson()).toList());
  //     await prefs.setString('tasks', data);
  //   }

  //   void _filterTasks() {
  //     final query = searchController.text.toLowerCase();
  //     setState(() {
  //       filteredTasks = tasks.where((task) =>
  //           task.name.toLowerCase().contains(query) ||
  //           task.location.toLowerCase().contains(query)).toList();
  //     });
  //   }

  //   void _addOrUpdateTask(Task task, {bool isEdit = false}) {
  //     setState(() {
  //       if (isEdit) {
  //         final index = tasks.indexWhere((t) => t.id == task.id);
  //         if (index != -1) tasks[index] = task;
  //       } else {
  //         tasks.add(task);
  //       }
  //       tasks.sort((a, b) => a.time.compareTo(b.time));
  //       filteredTasks = List.from(tasks);
  //     });
  //     _saveTasks();
  //   }

  //   void _deleteTask(String id) {
  //     setState(() {
  //       tasks.removeWhere((task) => task.id == id);
  //       filteredTasks = List.from(tasks);
  //     });
  //     _saveTasks();
  //   }

  //   void _toggleComplete(String id) {
  //     setState(() {
  //       final task = tasks.firstWhere((t) => t.id == id);
  //       task.isCompleted = !task.isCompleted;
  //       tasks.sort((a, b) => a.time.compareTo(b.time));
  //       filteredTasks = List.from(tasks);
  //     });
  //     _saveTasks();
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       body: Container(
  //         decoration: const BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/images/anh1.jpg'),
  //             fit: BoxFit.contain,           // Ảnh vừa khít màn hình, không bị cắt
  //             alignment: Alignment.center,
  //             opacity: 0.9,
  //           ),
  //         ),
  //         child: Container(
  //           color: Colors.black.withOpacity(0.45),   // Lớp tối giúp chữ dễ đọc
  //           child: Column(
  //             children: [
  //               AppBar(
  //                 title: const Text('Nhắc Việc', style: TextStyle(color: Colors.white)),
  //                 centerTitle: true,
  //                 backgroundColor: Colors.transparent,
  //                 elevation: 0,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(16),
  //                 child: TextField(
  //                   controller: searchController,
  //                   style: const TextStyle(color: Colors.white),
  //                   decoration: InputDecoration(
  //                     hintText: 'Tìm công việc...',
  //                     hintStyle: const TextStyle(color: Colors.white70),
  //                     prefixIcon: const Icon(Icons.search, color: Colors.white),
  //                     filled: true,
  //                     fillColor: Colors.black.withOpacity(0.5),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide.none,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: filteredTasks.isEmpty
  //                     ? const Center(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Icon(Icons.event_busy, size: 80, color: Colors.white70),
  //                             SizedBox(height: 16),
  //                             Text('Chưa có công việc nào',
  //                                 style: TextStyle(fontSize: 18, color: Colors.white)),
  //                           ],
  //                         ),
  //                       )
  //                     : ListView.builder(
  //                         padding: const EdgeInsets.symmetric(horizontal: 16),
  //                         itemCount: filteredTasks.length,
  //                         itemBuilder: (context, index) {
  //                           final task = filteredTasks[index];
  //                           final isOverdue = task.time.isBefore(DateTime.now()) && !task.isCompleted;

  //                           return Dismissible(
  //                             key: Key(task.id),
  //                             background: Container(
  //                               color: Colors.red,
  //                               alignment: Alignment.centerRight,
  //                               padding: const EdgeInsets.only(right: 20),
  //                               child: const Icon(Icons.delete, color: Colors.white),
  //                             ),
  //                             direction: DismissDirection.endToStart,
  //                             onDismissed: (_) => _deleteTask(task.id),
  //                             child: Card(
  //                               margin: const EdgeInsets.only(bottom: 12),
  //                               elevation: 4,
  //                               color: Colors.white.withOpacity(0.95),
  //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //                               child: ListTile(
  //                                 leading: CircleAvatar(
  //                                   backgroundColor: task.isCompleted
  //                                       ? Colors.green
  //                                       : (isOverdue ? Colors.red : Colors.blue),
  //                                   child: Icon(
  //                                     task.isCompleted ? Icons.check : (isOverdue ? Icons.warning : Icons.event),
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                                 title: Text(
  //                                   task.name,
  //                                   style: TextStyle(
  //                                     decoration: task.isCompleted ? TextDecoration.lineThrough : null,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                                 subtitle: Column(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(DateFormat('dd/MM/yyyy HH:mm').format(task.time)),
  //                                     Text('📍 ${task.location}'),
  //                                     if (task.remind)
  //                                       Text('🛎️ ${task.remindType} (trước 1 ngày)',
  //                                           style: const TextStyle(fontSize: 12, color: Colors.blue)),
  //                                   ],
  //                                 ),
  //                                 trailing: Checkbox(
  //                                   value: task.isCompleted,
  //                                   onChanged: (_) => _toggleComplete(task.id),
  //                                 ),
  //                                 onTap: () => Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (_) => AddEditTaskScreen(task: task, onSave: _addOrUpdateTask),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         backgroundColor: Colors.blue,
  //         onPressed: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (_) => AddEditTaskScreen(onSave: _addOrUpdateTask)),
  //         ),
  //         child: const Icon(Icons.add, size: 30, color: Colors.white),
  //       ),
  //     );
  //   }
  // }
  
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nhắc Việc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
    searchController.addListener(_filterTasks);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('tasks');
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      setState(() {
        tasks = jsonList.map((e) => Task.fromJson(e)).toList();
        tasks.sort((a, b) => a.time.compareTo(b.time));
        filteredTasks = List.from(tasks);
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks', data);
  }

  void _filterTasks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTasks = tasks.where((task) =>
          task.name.toLowerCase().contains(query) ||
          task.location.toLowerCase().contains(query)).toList();
    });
  }

  void _addOrUpdateTask(Task task, {bool isEdit = false}) {
    setState(() {
      if (isEdit) {
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) tasks[index] = task;
      } else {
        tasks.add(task);
      }
      tasks.sort((a, b) => a.time.compareTo(b.time));
      filteredTasks = List.from(tasks);
    });
    _saveTasks();
  }

  void _deleteTask(String id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      filteredTasks = List.from(tasks);
    });
    _saveTasks();
  }

  void _toggleComplete(String id) {
    setState(() {
      final task = tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
      tasks.sort((a, b) => a.time.compareTo(b.time));
      filteredTasks = List.from(tasks);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(''),
            fit: BoxFit.contain,           // Ảnh vừa khít màn hình, không bị cắt
            alignment: Alignment.center,
            opacity: 0.9,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.45),   // Lớp tối giúp chữ dễ đọc
          child: Column(
            children: [
              AppBar(
                title: const Text('Nhắc Việc', style: TextStyle(color: Colors.white)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tìm công việc...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredTasks.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 80, color: Colors.white70),
                            SizedBox(height: 16),
                            Text('Chưa có công việc nào',
                                style: TextStyle(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          final isOverdue = task.time.isBefore(DateTime.now()) && !task.isCompleted;

                          return Dismissible(
                            key: Key(task.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _deleteTask(task.id),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 4,
                              color: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: task.isCompleted
                                      ? Colors.green
                                      : (isOverdue ? Colors.red : Colors.blue),
                                  child: Icon(
                                    task.isCompleted ? Icons.check : (isOverdue ? Icons.warning : Icons.event),
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  task.name,
                                  style: TextStyle(
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateFormat('dd/MM/yyyy HH:mm').format(task.time)),
                                    Text('📍 ${task.location}'),
                                    if (task.remind)
                                      Text('🛎️ ${task.remindType} (trước 1 ngày)',
                                          style: const TextStyle(fontSize: 12, color: Colors.blue)),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (_) => _toggleComplete(task.id),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditTaskScreen(task: task, onSave: _addOrUpdateTask),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEditTaskScreen(onSave: _addOrUpdateTask)),
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
