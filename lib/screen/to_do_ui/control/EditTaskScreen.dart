import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/model/taskModel.dart';
import 'package:todo_emp/providers/TaskProvider.dart';
import 'package:todo_emp/responsive/size_config.dart';
import 'package:todo_emp/utils/helpers.dart';
import 'package:todo_emp/widgets/app_button_main.dart';
import 'package:todo_emp/widgets/defaultTextFormField.dart';

class EditTaskScreen extends StatefulWidget {
  final taskModel task;

  EditTaskScreen(this.task);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> with Helpers{
  late TextEditingController _titleTextController;
  late TextEditingController _descriptionTextController;
  late TextEditingController _dateTextController;
  late TextEditingController _timeTextController;
  var formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _titleTextController = TextEditingController(text: widget.task.title);
    _descriptionTextController = TextEditingController(text: widget.task.description);
    _dateTextController = TextEditingController(text: widget.task.date);
    _timeTextController = TextEditingController(text: widget.task.time);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _dateTextController.dispose();
    _timeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SizeConfig().designWidth(4.14).designHeight(8.96).init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff0f31dc),
        title: Text(
          'تعديل مهمة',
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
                    controller: _titleTextController,
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
                    controller: _descriptionTextController,
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
                    controller: _timeTextController,
                    type: TextInputType.datetime,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        _timeTextController.text =
                            value!.format(context).toString();
                        print(value.format(context));
                      });
                    },
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاس ادخال الوقت';
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
                    controller: _dateTextController,
                    type: TextInputType.datetime,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2060-05-15'),
                      ).then((value) {
                        _dateTextController.text =
                            DateFormat.yMMMd().format(value!);
                      });
                    },
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'الرجاء ادخال التاريخ';
                      }
                      return null;
                    },
                    label: 'تاريخ المهمة',
                    prefix: Icons.calendar_today,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            AppButtonMain(
              onPressed: () async {
               await performSave();
               Navigator.pop(context);

              },
              title: 'تعديل',
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
  Future performSave() async {
    if (checkData()) {
      await updateContact();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _descriptionTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
        context: context, content: 'الرجاء ادخال البيانات المطلوبة', error: false);
    return false;
  }

  Future updateContact() async {
    bool inserted =
    await Provider.of<TaskProvider>(context, listen: false).update(task: task);
    if (inserted) {
      showSnackBar(
          context: context, content: 'تم التعديل بنجاح', error: false);
      clear();
    } else {
      showSnackBar(
          context: context, content: 'فشل تعديل البيانات', error: true);    }
  }
  taskModel get task {
    taskModel task = widget.task;
    task.title = _titleTextController.text;
    task.description = _descriptionTextController.text;
    task.time = _timeTextController.text;
    task.date = _dateTextController.text;
    return task;
  }

  void clear() {
    _titleTextController.text = '';
    _descriptionTextController.text = '';
    _timeTextController.text = '';
    _dateTextController.text = '';

  }
}
