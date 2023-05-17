import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../shared/components/components.dart';




class HomeLayout extends StatelessWidget {

  @override
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) =>
              AppCubit
                  .get(context)
                  .screens[AppCubit
                  .get(context)
                  .currentIndex],
              fallback: (context) =>
                  Center(child: CircularProgressIndicator(

                  ),
                  ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      validate: (String? value) {
                                        if (value==null||value.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                      label: 'task title',
                                      prefix: Icons.title
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()).then((
                                          value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    validate: (String? value) {
                                      if (value==null||value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'task time',
                                    prefix: Icons.watch_later_outlined,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2024-10-28'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validate: (String? value) {
                                      if (value==null||value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'task date',
                                    prefix: Icons.calendar_today,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 15.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),

            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },

              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check,
                  ),
                  label: 'Done',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',

                ),
              ],

            ),
          );
        },
      ),
    );
  }


}
