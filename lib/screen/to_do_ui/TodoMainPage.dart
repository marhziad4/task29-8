import 'package:flutter/material.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/controller/UserApiController.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/model/tasks.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/screen/to_do_ui/AllTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/CompleteTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/asyncTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/control/NewTaskScreen.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/drawer_list_tile.dart';

class TodoMainPage extends StatefulWidget {
  @override
  State<TodoMainPage> createState() => _TodoMainPageState();
}

class _TodoMainPageState extends State<TodoMainPage>
    with SingleTickerProviderStateMixin, Helpers {
  late TabController tabController;
  bool async=false;
  initTabController() {
    tabController = TabController(length: 4, vsync: this);
    // tabController.animateTo(2);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTabController();
    TaskProvider().read();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffEBF0F9),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(10),
      //   child: FloatingActionButton(
      //       child: Icon(Icons.add),
      //       backgroundColor: Color(0xff0f31dc),
      //       onPressed: () async {
      //         Navigator.push(
      //             context, MaterialPageRoute(builder: (_) => NewTaskScreen()));
      //         // print(TaskProvider().completeTasks);
      //       }),
      // ),
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 25.0,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => NewTaskScreen()));
              },
            ),
          )
        ],

        // IconButton(
        // icon: Icon(
        // Icons.calendar_month_outlined,
        //   color: Colors.white,
        // ),
        //   onPressed: () {
        //     TableCalendar(
        //       firstDay: DateTime.utc(2010, 10, 16),
        //       lastDay: DateTime.utc(2030, 3, 14),
        //       focusedDay: DateTime.now(),
        //     );
        //   },
        // )
        centerTitle: true,
        backgroundColor: Color(0xff0f31dc),
        // backgroundColor: Colors.white,
        //
        title: Text(
          'الرئيسية',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        bottom: TabBar(
          indicatorColor: Color(0xff0f31dc),
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.task_outlined),
              text: 'المهام',
            ),
            Tab(
              icon: Icon(Icons.task_rounded),
              text: 'مهام المدير ',
            ),
            Tab(
              icon: Icon(Icons.task_rounded),
              text: 'المنجز ',
            ),
            Tab(
              icon: Icon(Icons.task_rounded),
              text: 'تم ترحيلها',
            ),
            // Tab(
            //   icon: Icon(Icons.done),
            //   text: 'تم',
            // ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          children: [
            SizedBox(
              height: 10,
            ),

            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                currentAccountPicture: CircleAvatar(
                  child: Text('O'),
                ),
                accountName: Text(
                  'marh',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                accountEmail: Text(
                  'marh@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )),
            // leading: CircleAvatar(
            //   radius: 30,
            //         backgroundColor: Colors.blue,
            //         child: Text('O'),
            // ),
            // title: Text(
            //   'مرح',
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.black,
            //     fontFamily: 'NotoNaskhArabic',
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),

            // SizedBox(
            //   height: 20,
            // ),
            Divider(
              indent: 0,
              endIndent: 50,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            DrawerListTile(
              title: "الرئيسية",
              iconData: Icons.home,
              onTab: () {
                Navigator.pushNamed(context, '/TodoMainPage');
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "اضافة مهام",
              iconData: Icons.add_box_outlined,
              onTab: () {
                Navigator.pushNamed(context, '/NewTaskScreen');
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "ترحيل بيانات",
              iconData: Icons.cloud_upload,
              onTab: () async {

                TaskApiController()
                    .createTask(context: context);
                Navigator.pop(context);

                // if(async==false){
                //   TaskApiController()
                //       .createTask(context: context);
                // }else{
                //   showSnackBar(
                //       context: context,
                //       content: 'تم ترحيل البيانات سابقا',
                //       error: true);
                // }
                // setState(() {
                //   async=true;
                // });

                // var response = await http.post(
                //   Uri.parse('http://10.12.161.8:82/api/public/api/store'),
                //
                // );
                // var jsonResponse = jsonDecode(response.body);
                // print("hhhh>>${jsonResponse}");


                //
                // var url = Uri.parse(ApiSettings.ADDTASKS);
                // var response = await http.post((url),body: {
                //
                // },
                //     headers: {
                //       'authorization':UserPreferences().token
                //     });
                // TaskApiController().createTask();
                // RouterClass.routerClass.routingToSpecificWidgetWithoutPop(
                //     MyHomePage());
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "حفظ احتياطي",
              iconData: Icons.file_upload_rounded,
              onTab: () async {
                // _writeBackup(tasks);
                // RouterClass.routerClass.routingToSpecificWidgetWithoutPop(
                //     MyHomePage());
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "المهام",
              iconData: Icons.calendar_month,
              onTab: () {
                Navigator.pushNamed(context, '/CalenderScreen');
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "ضبط",
              iconData: Icons.settings,
              onTab: () {
                // RouterClass.routerClass.routingToSpecificWidgetWithoutPop(
                //     Checksis());
              },
            ),
            Divider(
              indent: 0,
              endIndent: 50,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            DrawerListTile(
                iconData: Icons.logout,
                title: "تسجيل خروج",
                onTab: () async {
                  logout();
                  print('object');
                  // Provider.of<AppProvider>(context, listen: false).logOut();

                  // await logout();
                  // showSnackBar(
                  //     context: context, content: 'Logout successfully');
                }),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          AllTasksScreen(),
          // ApiTasksScreen(),
          CompleteTasksScreen(),
          CompleteTasksScreen(),
          AsyncTasksScreen(),
        ],
      ),
    );
  }

  final BackupStorage _backupStorage = BackupStorage(
    organizationName: "MyOrganization",
    applicationName: "LitBackupService",
    fileName: "examplebackup",
    // The installationID should be generated only once after the initial app
    // startup and be stored on a persisten data storage (such as `SQLite`) to
    // ensure the file name matches on each app startup.
    installationID: DateTime.now().millisecondsSinceEpoch.toRadixString(16),
  );

  Future<void> _writeBackup(taskModel backup) async {
    setState(
      () => {
        _backupStorage.writeBackup(backup),
      },
    );
  }

  Tasks get tasks {
    Tasks task = Tasks();
    task.title = 'title';
    task.description = 'description';
    task.status = 2;
    task.done = 0;
    task.create_dept = 4;
    task.create_user = 22;
    task.end_date = '22/08/2022';
    task.start_date = '22/08/2022';
    task.priority = 3;
    task.to_dept = 4;
    task.update_user = 22;
    task.userId = UserPreferences().IdUser;
    return task;
  }

  // Future createTask() async {
  //   bool task = await  Provider.of<TasksApiProvider>(context, listen: false).createTask(context: context, newTask: tasks);
  //   if (task != null) {
  //     // tasks.add(task);
  //     // notifyListeners();
  //     print('object');
  //
  //
  //   }
  //   print('object');
  //
  // }
  Tasks get tasksApi {
    Tasks task = Tasks();
    task.title = 'title';
    task.description = 'description';
    task.status = 0;
    task.done = 0;
    task.create_dept = 22;
    task.create_user = 22;
    task.end_date = '22';
    task.start_date = '22';
    task.priority = 22;
    task.to_dept = 22;
    task.update_user = 22;
    task.userId = UserPreferences().IdUser;

    return task;
  }

  Future<void> logout() async {
    print('log');
    bool status = await UserApiController().logout(context: context);
    if (status) {
      Navigator.pushReplacementNamed(context, '/Login_screen');
    }
  }
}
