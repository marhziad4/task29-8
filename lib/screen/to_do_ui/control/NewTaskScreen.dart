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
    dateTextController = TextEditingController();
    timeTextController = TextEditingController();
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
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        timeTextController.text =
                            value!.format(context).toString();
                        print(value.format(context).split('AM'));
                      });
                    },
                    //DateFormat.yMMMd().format(DateTime.now())
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاء ادخال الوقت';
                      }
                      return null;
                    },
                    label: "${TimeOfDay.now().format(context).toString()}",
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
                  // Row(
                  //   children: [
                  //     Text('حالة المهمة',style: TextStyle(fontSize: 15),),
                  //     Spacer(),
                  //     DropdownButton(
                  //       // Initial Value
                  //       value: StateValue,
                  //       hint: Text('Select state'),
                  //
                  //       // Down Arrow Icon
                  //       icon: const Icon(
                  //           Icons.keyboard_arrow_down),
                  //
                  //       // Array list of items
                  //       items: States.map((String items) {
                  //         return DropdownMenuItem(
                  //           value: items,
                  //           child: Text(items),
                  //         );
                  //       }).toList(),
                  //       // After selecting the desired option,it will
                  //       // change button value to selected value
                  //       onChanged: (String? newValue) {
                  //         if (newValue != null) {
                  //           StateValue = newValue;
                  //         }
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            // TextField(
            //   controller: _titleTextController,
            //   decoration: InputDecoration(
            //     label: Text(
            //       'عنوان المهة',
            //       style: TextStyle(fontSize: 25),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: new BorderSide(color: Colors.grey),
            //       borderRadius: new BorderRadius.circular(25.7),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: new BorderSide(color: Color(0xff0f31dc)),
            //       borderRadius: new BorderRadius.circular(25.7),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // TextField(
            //   controller: _descriptionTextController,
            //   decoration: InputDecoration(
            //     label: Text(
            //       'تفاصيل',
            //       style: TextStyle(fontSize: 25),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: new BorderSide(color: Colors.grey),
            //       borderRadius: new BorderRadius.circular(25.7),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: new BorderSide(color: Color(0xff0f31dc)),
            //       borderRadius: new BorderRadius.circular(25.7),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 15,
            // ),
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

  // Future<void> save() async {
  //   bool saved = await Provider.of<TaskProvider>(context, listen: false)
  //       .create(task: task);
  //   if (saved) {
  //     print('تم الاضافة بنجاح');
  //     showSnackBar(context: context, content: 'تم الاضافة بنجاح', error: false);
  //   } else {
  //     print('لم تتم الاضافة بنجاح');
  //     showSnackBar(
  //         context: context, content: 'لم تتم الاضافة بنجاح', error: true);
  //   }
  // }

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
      Navigator.pop(context);
    }
  }

  taskModel get tasks {
    taskModel task = taskModel();
    // task.id=0;
    print('${UserPreferences().chek}');
    task.title = titleTextController.text;
    task.userId = UserPreferences().IdUser;
    task.description = descriptionTextController.text;
    task.status = 0;
    task.counter = 0;
    task.isDeleted = 0;
    task.chek =UserPreferences().chek;
    task.date = dateTextController.text.toString();
    task.time = timeTextController.text.toString();
    task.details = 'التفاصيل';
    task.image = null;
    return task;
  }
}
