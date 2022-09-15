import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/main.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/task_widget.dart';

class CompleteTasksScreen extends StatefulWidget {
  @override
  State<CompleteTasksScreen> createState() => _CompleteTasksScreenState();
}

class _CompleteTasksScreenState extends State<CompleteTasksScreen>  with Helpers {
  bool isLoading = false;
  bool visible = true;
  bool chek = true;
  @override
  void initState() {
    // print('ctini 123');
    // TODO: implement initState
    super.initState();

    refreshTasks();
  }
  Future refreshTasks()async{
    // print('ctini 456');
    //completeTasks=await TaskProvider().read2();
    // await Provider.of<TaskProvider>(context, listen: false).readAll();
    // await Provider.of<TaskProvider>(context, listen: false).read2();
  }
  @override
  Widget build(BuildContext context) {
   // Provider.of<TaskProvider>(context, listen: false).readAll();
    // TODO: implement build
    return Container(

      child: Consumer<TaskProvider>(
        builder: (
            BuildContext context,
            TaskProvider provider,
            Widget? child,
            ) {
          if (provider.completeTasks.isNotEmpty) {
            return ListView.builder(
              itemCount: provider.completeTasks.length,
              itemBuilder: (context, index) {
                return TaskWidget(
                provider.completeTasks.toList()[index],
               //    completeTasks![index],

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