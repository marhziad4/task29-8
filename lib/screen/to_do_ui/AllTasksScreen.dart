import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/task_widget.dart';



class AllTasksScreen extends StatefulWidget {
  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> with Helpers {

bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     refreshTasks();
  }

  Future refreshTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).readAll();
    await Provider.of<TaskProvider>(context, listen: false).taskss;
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
          if (provider.taskss.isNotEmpty) {
           // ListView.clear();
            return ListView.builder(
                itemCount: provider.taskss.length,
                itemBuilder: (context, index) {
                  taskModel task = provider.taskss[index];

                  return TaskWidget(
                    provider.taskss.toList()[index],
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
