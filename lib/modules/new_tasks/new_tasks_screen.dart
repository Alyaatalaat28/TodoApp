import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../shared/components/components.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>
      (
      listener: (context , state){},
      builder: (context , state){
        var tasks = AppCubit.get(context).newTasks;

        return taskBuilder(
            tasks: tasks,
        );
      },
    );
  }
}
