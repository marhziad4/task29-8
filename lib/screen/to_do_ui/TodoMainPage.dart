import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/controller/TaskApiController.dart';
import 'package:todo_emp/controller/UserApiController.dart';
import 'package:todo_emp/model/location.dart';
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
  }

  Future refreshTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).readAll();
    await Provider.of<TaskProvider>(context, listen: false).read2();

    @override
    void setState(VoidCallback fn) {
      // TODO: implement setState
      super.setState(fn);
      Provider.of<TaskProvider>(context, listen: false).read2();

      counter = Provider.of<TaskProvider>(context, listen: false)
          .completeTasks
          .length;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Color(0xffEBF0F9),
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
              onPressed: () async {
                print(" ${UserPreferences().chek}");
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NewTaskScreen()));
              },
            ),
          )
        ],

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

              locations =
                  await Provider.of<LocationProvider>(context, listen: false)
                      .read();
              for (int i = 0; i < locations!.length; i++) {
                print(
                    'index ${i} location ${locations[i].latitude} longitude ${locations[i].longitude}  time ${locations[i].time}  updatetime ${locations[i].updatetime}task_id ${locations[i].task_id}image_id ${locations[i].image_id}');
              }
              setState(() {
                Provider.of<TaskProvider>(context, listen: false).read2();

                Provider.of<TaskProvider>(context, listen: false).completeTasks;

                counter = Provider.of<TaskProvider>(context, listen: false)
                    .completeTasks
                    .length;
              });

              // print(
              //     '${Provider.of<TaskProvider>(context, listen: false).completeTasks.length}');
              //
              // print('${counter}');
            }),
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
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: '${UserPreferences().image}',
                    height: 20,
                    width: 20,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
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
              },
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile2(
              title: "جلب المهام",
              iconData: Icons.task,
              onTab: () {
                _checkConnectivityStateFetchTask();
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 20,
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
                  showLogoutDialog(
                      context: context,
                      title: 'تسجيل خروج',
                      subTittle: 'هل تريد تسجيل الخروج ؟');
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
      Provider.of<TaskProvider>(context, listen: false).completeTasks;
      print('Connected to a Wi-Fi network');
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

  Future<bool> _checkConnectivityStateFetchTask() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
            TaskApiController().getTasks(context: context),
            message: Text('جاري جلب المهام ...')),
      );
      Provider.of<TaskProvider>(context, listen: false).readTaskAdmin;
      print('Connected to a Wi-Fi network');
      return true;
    } else if (result == ConnectivityResult.mobile) {
      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
            TaskApiController().getTasks(context: context),
            message: Text('جاري جلب المهام ...')),
      );
      Provider.of<TaskProvider>(context, listen: false).readTaskAdmin;
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
