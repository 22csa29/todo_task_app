import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskEditorPage extends StatefulWidget {
  final Task? existingTask;
  final void Function(Task task)? onSave;

  const TaskEditorPage({super.key, this.existingTask, this.onSave});

  @override
  State<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingTask?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingTask?.description ?? '');
    _dueDate = widget.existingTask?.dueDate ?? DateTime.now();
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) return;

    final newTask = Task(
      id: widget.existingTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dueDate: _dueDate,
      isComplete: widget.existingTask?.isComplete ?? false,
    );

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Editor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ListTile(
              title: Text('Due: ${_dueDate.toLocal().toString().split(' ')[0]}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
