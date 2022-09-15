import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';

import '../../providers/task_api_provider.dart';


class ApiTasksScreen extends StatefulWidget {
  @override
  State<ApiTasksScreen> createState() => _ApiTasksScreenState();
}

class _ApiTasksScreenState extends State<ApiTasksScreen> {
  late Future<List<taskModel>> _future;
  List<taskModel> tasks = <taskModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<TasksApiProvider>(context, listen: false)
    //     .getTasks(context: context);
  }
  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<AllGoodsViewModel>(context, listen: false).fetchAllItems(id: widget.category.id);
  // }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //final model = Provider.of<AllGoodsViewModel>(context);
    return Consumer<TaskProvider>(
      builder: (
        BuildContext context,
          TaskProvider TaskProvider,
        Widget? child,
      ) {
        // if (value.loading) {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // } else
       if (TaskProvider.tasks.isNotEmpty) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/details_apiTasks_screen');
                },
                child: ListTile(
                  leading: Icon(Icons.task),
                  title: Text(TaskProvider.tasks[index].title),
                  subtitle: Text(TaskProvider.tasks[index].description),
                ),
              );
            },
            itemCount: TaskProvider.completeTasks.length,
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.grey.shade500,
                  size: 80,
                ),
                Text(
                  'لا يوجد بيانات',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
// ListView(
// children: [
// ...snapshot.data!.map((e) =>ListTile(
// title: Text(
// '${tasks[index].title} ${tasks[index].description}'),
// FutureBuilder<List<Tasks>>(
// future: TaskApiController().getTasks(),
// builder: (context, snapshot) {
// if  (snapshot.connectionState == ConnectionState.waiting) {
// print('length111111');
// return Center(child: CircularProgressIndicator());
// } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
// print('length2222222');
// tasks = snapshot.data!;
// print('length${tasks.length}');
// return ListView.separated(
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(
// '${tasks[index].title} ${tasks[index].description}'),
// );
// },
// separatorBuilder: (context, index) {
// return Divider();
// },
// itemCount: tasks.length,
// );
// } else {
// return Center(
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(
// Icons.warning,
// color: Colors.grey.shade500,
// size: 80,
// ),
// Text(
// 'لا يوجد بيانات',
// style: TextStyle(
// color: Colors.grey.shade500,
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// )
// ],
// ),
// );
// }
// },
// );
