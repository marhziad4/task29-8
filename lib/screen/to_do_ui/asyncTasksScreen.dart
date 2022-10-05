import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/task_widget_admin.dart';

class AsyncTasksScreen extends StatefulWidget {
  @override
  State<AsyncTasksScreen> createState() => _AsyncTasksScreenState();
}

class _AsyncTasksScreenState extends State<AsyncTasksScreen> with Helpers {
  bool isLoading = false;
  bool visible = true;
  bool chek = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshTasks();
  }

  Future refreshTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).readAsync();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskProvider>(context, listen: false).readAll();

    // TODO: implement build
    return Container(
      child: Consumer<TaskProvider>(
        builder: (
          BuildContext context,
          TaskProvider provider,
          Widget? child,
        ) {
          if (provider.doneAsync.isNotEmpty) {
            return ListView.builder(
                itemCount: provider.doneAsync.length,
                itemBuilder: (context, index) {
                  return TaskWidgetAdmin(
                    provider.doneAsync.toList()[index],
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
    );
  }
}
