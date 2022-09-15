import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/controller/UserApiController.dart';
import 'package:todo_emp/model/location.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/model/tasks.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/screen/to_do_ui/AllTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/ApiTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/CompleteTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/asyncTasksScreen.dart';
import 'package:todo_emp/screen/to_do_ui/control/NewTaskScreen.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/drawer_list_tile.dart';
import 'package:todo_emp/widgets/drawer_list_tile2.dart';
import 'package:todo_emp/widgets/loading2.dart';

import '../../providers/location_provider.dart';

class TodoMainPage extends StatefulWidget {
  @override
  State<TodoMainPage> createState() => _TodoMainPageState();
}

class _TodoMainPageState extends State<TodoMainPage>
    with SingleTickerProviderStateMixin, Helpers {
  late TabController tabController;
  bool async = false;

  initTabController() {
    tabController = TabController(length: 4, vsync: this);
    // tabController.animateTo(2);
  }

  int? counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTabController();
    refreshTasks();

//     counter= await Provider.of<TaskProvider>(context, listen: false).counterCmp;
// print('$counter');
  }

  Future refreshTasks() async {
    // print('ctini 456');
    //completeTasks=await TaskProvider().read2();
     await Provider.of<TaskProvider>(context, listen: false).readAll();
    await Provider.of<TaskProvider>(context, listen: false).read2();

    @override
    void setState(VoidCallback fn) {
      // TODO: implement setState
      super.setState(fn);
      // =Provider.of<TaskProvider>(context, listen: true).counterCmp;
      Provider.of<TaskProvider>(context, listen: false).read2();

      counter = Provider.of<TaskProvider>(context, listen: false)
          .completeTasks
          .length;

      // List<taskModel> completeTasks = <taskModel>[];
      //
      // completeTasks= TaskProvider().completeTasks;
      // _index = completeTasks.length;
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // setState(() {
    //   counter = Provider.of<TaskProvider>(context, listen: false)
    //       .completeTasks
    //       .length;
    // });
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
      key: _scaffoldKey,
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
                // setState(() { TaskProvider.  });

                print(" ${UserPreferences().chek}");

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NewTaskScreen()));
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
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: () async {
            _scaffoldKey.currentState?.openDrawer();
            print("object");
            List<Location>? locations;

            locations = await Provider.of<LocationProvider>(context, listen: false).read();
            for (int i = 0; i < locations!.length; i++) {
              print(
                  'index ${i} location ${locations[i].latitude} longitude ${locations[i].longitude}  time ${locations[i].time}  updatetime ${locations[i].updatetime}task_id ${locations[i].task_id}');
            }
            setState(() {
               Provider.of<TaskProvider>(context, listen: false).read2();

              Provider.of<TaskProvider>(context, listen: false).completeTasks;

              counter= Provider.of<TaskProvider>(context, listen: false).completeTasks.length;

            });

            print(
                '${Provider.of<TaskProvider>(context, listen: false).completeTasks.length}');

            print('${counter}');
          }
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          children: [
            SizedBox(
              height: 10,
            ),
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                currentAccountPicture:

                    // CircleAvatar(
                    //   radius: 30,
                    //   child: Image.network(
                    //       '${UserPreferences().image}',width: 50,height: 50,),
                    // ),
                    CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('${UserPreferences().image}',scale: 50),
                ),
                accountName: Text(
                  '${UserPreferences().name}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                accountEmail: Text(
                  '${UserPreferences().IdUser}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )),
            Divider(
              indent: 0,
              endIndent: 50,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            DrawerListTile2(
              title: "الرئيسية",
              iconData: Icons.home,
              onTab: () {
                Navigator.pushNamed(context, '/TodoMainPage');
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile2(
              title: "اضافة مهام",
              iconData: Icons.add_box_outlined,
              onTab: () {
                print(
                    '${Provider.of<TaskProvider>(context, listen: false).completeTasks.length}');
                print('${counter}');
                Navigator.pushNamed(context, '/NewTaskScreen');
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "ترحيل بيانات",
              iconData: Icons.cloud_upload,
              counter: '${counter}',
              onTab: () async {

                _checkConnectivityState();
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
            DrawerListTile2(
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
            DrawerListTile2(
              title: "المهام",
              iconData: Icons.calendar_month,
              onTab: () {
                Navigator.pushNamed(context, '/CalenderScreen');
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile2(
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
            DrawerListTile2(
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
          ApiTasksScreen(),
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

  Future<bool> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
            TaskApiController().createTask(context: context),
            message: Text('جاري ترحيل المهام ...')),
      );
      Provider.of<TaskProvider>(context, listen: false).completeTasks;      print('Connected to a Wi-Fi network');
      return true;
    } else if (result == ConnectivityResult.mobile) {
      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
            TaskApiController().createTask(context: context),
            message: Text('جاري ترحيل المهام ')),
      );
      Provider.of<TaskProvider>(context, listen: false).completeTasks;
      print('Connected to a mobile network');
      return true;
    } else {
      context.showFlashDialog(
        persistent: true,
        title: Text('خطأ'),
        content: Text('تعذر الاتصال بالانترنت '),


      );
      print('Not connected to any network');


      return false;
    }


  }
}
