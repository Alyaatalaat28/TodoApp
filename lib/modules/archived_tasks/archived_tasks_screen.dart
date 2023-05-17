

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../shared/components/components.dart';

class ArchivedTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>
      (
      listener: (context , state){},
      builder: (context , state){
        var tasks = AppCubit.get(context).archivedTasks;

        return taskBuilder(
            tasks: tasks
        );
      },
    );
  }
}
