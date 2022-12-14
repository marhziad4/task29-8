import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/preferences/user_pref.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/defaultTextFormField.dart';
import '../../../widgets/app_button_main.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> with Helpers {
  late TextEditingController titleTextController;
  late TextEditingController descriptionTextController;
  late TextEditingController dateTextController;
  late TextEditingController timeTextController;
  var formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    titleTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    DateTime now = DateTime.now();
//text:DateFormat('kk:mm:ss').format(now),text:DateFormat('EEE d MMM').format(now)
    dateTextController =
        TextEditingController(text: DateFormat.yMMMd().format(now));
    timeTextController =
        TextEditingController(text: DateFormat('a kk:mm').format(now));
    TaskProvider().read();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleTextController.dispose();
    descriptionTextController.dispose();
    dateTextController.dispose();
    timeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff0f31dc),
        title: Text(
          'اضافة مهمة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  defaultTextFormField(
                    controller: titleTextController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاء ادخال العنوان';
                      }
                      return null;
                    },
                    label: 'عنوان المهمة',
                    prefix: Icons.title,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultTextFormField(
                    controller: descriptionTextController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاء ادخال التفاصيل';
                      }
                      return null;
                    },
                    label: 'تفاصيل المهمة',
                    prefix: Icons.title,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultTextFormField(
                    controller: timeTextController,
                    type: TextInputType.datetime,
                    //initialValue: '14:05',
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.input,
                      ).then((value) {
                        timeTextController.text =
                            value!.format(context).toString();
                        print(value.format(context));
                      });
                    },
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاء ادخال الوقت';
                      }
                      return null;
                    },
                    label: 'وقت المهمة',
                    prefix: Icons.watch_later_outlined,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultTextFormField(
                    controller: dateTextController,
                    type: TextInputType.datetime,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2050-05-15'),
                      ).then((value) {
                        dateTextController.text =
                            DateFormat.yMMMd().format(value!);
                      });
                    },
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاء ادخال التاريخ';
                      }
                      return null;
                    },
                    label: "${DateFormat.yMMMd().format(DateTime.now())}",
                    prefix: Icons.calendar_today,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            AppButtonMain(
              onPressed: () async {
                await perform();
              },
              title: 'حفظ',
            ),
            SizedBox(
              height: 15,
            ),
            AppButtonMain(
              onPressed: () {
                Navigator.pop(context);
              },
              title: 'الغاء',
            ),
          ],
        ),
      ),
    );
  }

  bool checkData() {
    if (titleTextController.text.trim().isNotEmpty &&
        descriptionTextController.text.trim().isNotEmpty) {
      return true;
    }
    showSnackBar(context: context, content: 'يرجى ادخال البيانات', error: true);
    return false;
  }

  Future<void> perform() async {
    if (checkData()) {
      bool saved = await Provider.of<TaskProvider>(context, listen: false)
          .create(task: tasks);
      if (saved) {
        showSnackBar(
            context: context, content: 'تمت العملية بنجاح', error: false);
      }
      Navigator.pushNamed(context, '/TodoMainPage');
    }
  }

  static final _defaultDate = DateTime.now().toString();

  taskModel get tasks {
    taskModel task = taskModel();
    // task.id=0;
    print('${UserPreferences().chek}');
    //task.id = null;
    task.title = titleTextController.text;
    task.userId = UserPreferences().IdUser;
    task.id_pk = '0';
    task.description = descriptionTextController.text;
    task.status = 0;
    task.counter = 0;
    task.isDeleted = 0;
    task.chek = UserPreferences().chek;
    task.date = dateTextController.text.toString();
    task.time = timeTextController.text.toString();
    task.details = null;
    return task;
  }
}
