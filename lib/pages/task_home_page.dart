import 'package:flutter/material.dart';
import 'package:todo_task_app/models/task.dart';
import 'task_editor_page.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<Task> _tasks = [];

  void _addOrUpdateTask([Task? task]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskEditorPage(existingTask: task),
      ),
    );

    if (result != null && result is Task) {
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == result.id);
        if (index >= 0) {
          _tasks[index] = result;
        } else {
          _tasks.add(result);
        }
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index].isComplete = !_tasks[index].isComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    final open = _tasks.where((t) => !t.isComplete).toList();
    final completed = _tasks.where((t) => t.isComplete).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Open Tasks'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(open),
            _buildTaskList(completed),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addOrUpdateTask(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks found.'));
    }

    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => _deleteTask(_tasks.indexOf(task)),
            child: ListTile(
              leading: Checkbox(
                value: task.isComplete,
                onChanged: (_) => _toggleComplete(_tasks.indexOf(task)),
              ),
              title: Text(task.title),
              subtitle: Text('Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
              onTap: () => _addOrUpdateTask(task),
            ),
          );
        },
      ),
    );
  }
}
