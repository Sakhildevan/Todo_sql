import 'package:flutter/material.dart';
import 'package:to_do_sql/Task/view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:to_do_sql/models/task_model.dart';

class TodoApp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //form key
    return ViewModelBuilder<TodoViewModel>.reactive(
      viewModelBuilder: () => TodoViewModel(),
      onViewModelReady: (model) => model.loadTasks(),
      builder: (context, model, child) => Container(
        // decoration: BoxDecoration(
        //   image: const DecorationImage(
        //     image: AssetImage('assets/back.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Scaffold(
          //backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color(0xFFE59525),
            title: Text('TODO App'),
          ),
          body: model.isBusy
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: model.tasks.length,
                  itemBuilder: (context, index) {
                    final task = model.tasks[index];

                    return Dismissible(
                      key: Key(task.id.toString()),
                      onDismissed: (direction) {
                        model.deleteTask(task.id!);
                      },
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(
                          '${task.title}',
                        ),
                        subtitle: Text(
                          '${task.description}',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          width: 102,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${task.isCompleted ? "Completed" : "pending"}",
                                style: TextStyle(
                                    color: task.isCompleted
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 10),
                              ),
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  task.isCompleted = value!;
                                  model.updateTask(task);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFE59525),
            onPressed: () {
              _showTaskDialog(context, model);
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete???"),
      content: Text("Sure Want to Delete"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showTaskDialog(BuildContext context, TodoViewModel model) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please Enter Title';
                  }
                  return null;
                },
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Title is not empty, proceed with adding the task
                final task = Task(
                  title: titleController.text.toString(),
                  description: descriptionController.text.toString(),
                );
                model.addTask(task);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

// Add a function to confirm task deletion
  void _confirmDeleteTask(
      BuildContext context, TodoViewModel model, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              model.deleteTask(task.id!);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ... rest of the Dismissible code
}
