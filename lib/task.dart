import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  final String id;
  String name;
  DateTime time;
  String location;
  bool remind;
  String remindType;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.time,
    required this.location,
    required this.remind,
    required this.remindType,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'time': time.toIso8601String(),
        'location': location,
        'remind': remind,
        'remindType': remindType,
        'isCompleted': isCompleted,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        name: json['name'],
        time: DateTime.parse(json['time']),
        location: json['location'],
        remind: json['remind'],
        remindType: json['remindType'],
        isCompleted: json['isCompleted'] ?? false,
      );
}

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final Function(Task, {bool isEdit}) onSave;

  const AddEditTaskScreen({super.key, this.task, required this.onSave});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  DateTime? _selectedDateTime;
  bool _remind = true;
  String _remindType = 'Nhắc bằng thông báo';

  final List<String> _remindOptions = [
    'Nhắc bằng chuông',
    'Nhắc qua email',
    'Nhắc bằng thông báo'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _nameController = TextEditingController(text: widget.task!.name);
      _locationController = TextEditingController(text: widget.task!.location);
      _selectedDateTime = widget.task!.time;
      _remind = widget.task!.remind;
      _remindType = widget.task!.remindType;
    } else {
      _nameController = TextEditingController();
      _locationController = TextEditingController();
      _selectedDateTime = DateTime.now().add(const Duration(days: 1));
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      final newTask = Task(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        time: _selectedDateTime!,
        location: _locationController.text,
        remind: _remind,
        remindType: _remindType,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      widget.onSave(newTask, isEdit: widget.task != null);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ==================== ẢNH NỀN CHO TRANG THỨ 2 ====================
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/anh2.jpg'),
            fit: BoxFit.contain,
            alignment: Alignment.center,
            opacity: 0.9,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.45),   // Lớp tối giúp form dễ nhìn
          child: Column(
            children: [
              AppBar(
                title: Text(widget.task == null ? 'Thêm công việc mới' : 'Sửa công việc',
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Tên công việc',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.task),
                            fillColor: Colors.white70,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên công việc' : null,
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: _pickDateTime,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedDateTime == null
                                      ? 'Chọn thời gian'
                                      : DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Địa điểm',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                            fillColor: Colors.white70,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa điểm' : null,
                        ),
                        const SizedBox(height: 20),

                        SwitchListTile(
                          title: const Text('Nhắc việc trước 1 ngày', style: TextStyle(color: Colors.white)),
                          value: _remind,
                          onChanged: (val) => setState(() => _remind = val),
                          secondary: const Icon(Icons.notifications_active, color: Colors.white),
                        ),

                        if (_remind) ...[
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _remindType,
                            decoration: const InputDecoration(
                              labelText: 'Phương thức nhắc',
                              border: OutlineInputBorder(),
                              fillColor: Color.fromARGB(179, 203, 202, 202),
                              filled: true,
                            ),
                            items: _remindOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (val) => setState(() => _remindType = val!),
                          ),
                        ],

                        const SizedBox(height: 40),
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Ghi lại công việc', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}