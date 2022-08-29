import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String taskName;
  final String date;
  final String taskDescription;
  final String time;

  // final IconData editIcon;
  final IconData deleteIcon;
  void Function() onPressed;
  // void Function() onPressed1;

  TaskCard(
      {required this.taskName,
      required this.date,
      required this.time,
      required this.taskDescription,
      // required this.editIcon,
      required this.deleteIcon,
      required this.onPressed,
      // required this.onPressed1
      });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 150,
        child: Card(
          // width: double.infinity,
          // height: 200.h,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0.16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(25.r),
          //   boxShadow: AppShadow.shadow036,
          // ),
          child: Stack(
            children: [
              SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                    width: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text(
                          widget.taskName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black87),
                        ),
                        Spacer(),
                        // IconButton(
                        //   icon: Icon(
                        //     widget.editIcon,
                        //     size: 25.0,
                        //   ),
                        //   onPressed: () {
                        //   widget.onPressed;
                        //   },
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        IconButton(
                          icon: Icon(
                            widget.deleteIcon,
                            size: 25.0,
                          ),
                          onPressed: () {
                      widget.onPressed;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.taskDescription,
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),

                        Text(
                          widget.time,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blueGrey),
                        ),
                        // Checkbox(
                        //   value:value ,
                        //     //Provider.of<DatabaseProvider>(context).isComplete
                        //   onChanged: (value) {
                        //     Provider.of<DatabaseProvider>(context, listen: false)
                        //         .changeIsCompleteOnNewTaskScreen();
                        //   },
                        //   title: Text('I have complete this task'),
                        // ),
                        SizedBox(
                          width: 20,
                        ),

                        Text(
                          widget.date,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 25,
                  //   width: 0,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
