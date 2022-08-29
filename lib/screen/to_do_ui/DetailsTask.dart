import 'package:flutter/material.dart';
import 'package:todo_emp/model/taskModel.dart';



class DetailsTask extends StatefulWidget {
  final taskModel task;

  const DetailsTask({Key? key,required this.task
  }) : super(key: key);

  @override
  State<DetailsTask> createState() => _DetailsTaskState();
}

class _DetailsTaskState extends State<DetailsTask> {
late taskModel task;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
                task.time,
              style: TextStyle(color: Colors.white38),
            ),
            SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
    Widget editButton() => IconButton(
        icon: Icon(Icons.edit_outlined),
        onPressed: () async {
          //
          // await Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => EditTaskScreen(task:task)
          // ));

        });

    Widget deleteButton() => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        // await Provider.of<TaskProvider>(context, listen: false)
        //     .delete(widget.taskId);
        Navigator.of(context).pop();
      },
    );
  }


