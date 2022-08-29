import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';

class cardWidget extends StatelessWidget {
  taskModel task;

  cardWidget(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/Map_screen');
        },
        child: Consumer<TaskProvider>(
          builder: (
            BuildContext context,
            TaskProvider provider,
            Widget? child,
          ) {
            if (provider.tasks.isNotEmpty) {
              return ListView.builder(
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                      ),
                      title: Text(
                        "task.title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("task.description"),
                    );
                  });
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 80,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      'لا يوجد بيانات',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
