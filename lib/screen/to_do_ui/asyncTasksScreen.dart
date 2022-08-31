import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/task_widget.dart';

class AsyncTasksScreen extends StatefulWidget {
  @override
  State<AsyncTasksScreen> createState() => _AsyncTasksScreenState();
}

class _AsyncTasksScreenState extends State<AsyncTasksScreen>  with Helpers {
  bool isLoading = false;
  bool visible = true;
  bool chek = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshTasks();
  }
  Future refreshTasks()async{
    setState(() {
      isLoading =true;
    });
    // completeTasks=await TaskProvider().read2();
    setState(() {
      isLoading =false;
    });
  }
  @override
  Widget build(BuildContext context) {
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
                  return TaskWidget(
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