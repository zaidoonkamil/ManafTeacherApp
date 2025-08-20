import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/background.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'lessons/lessons.dart';

class Lectures extends StatelessWidget {
  const Lectures({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()..getLessons(context: context,),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                           const Text(
                              textAlign: TextAlign.right,
                              'المحاضرات',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 26,),
                        Expanded(
                            child: ConditionalBuilder(
                                condition: state is !GetLessonsLoadingState,
                                builder: (c){
                                  return ConditionalBuilder(
                                      condition: cubit.getLessonsModel != null,
                                      builder: (c){
                                        return ListView.builder(
                                            itemCount: cubit.getLessonsModel!.unlockedLessons.length,
                                            itemBuilder: (context,index){
                                              DateTime dateTime = DateTime.parse(cubit.getLessonsModel!.unlockedLessons[index].createdAt.toString());
                                              String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                              return TweenAnimationBuilder(
                                                duration: Duration(milliseconds: 500 + (index * 50)),
                                                tween: Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero),
                                                curve: Curves.easeOut,
                                                builder: (context, Offset offset, child) {
                                                  return Transform.translate(
                                                    offset: offset * 100,
                                                    child: AnimatedOpacity(
                                                      duration: Duration(milliseconds: 300),
                                                      opacity: 1,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child:cubit.getLessonsModel!.unlockedLessons[index].isLocked == false? GestureDetector(
                                                  onTap: () {
                                                    navigateTo(context,
                                                    Lessons(
                                                    videoUrl: cubit.getLessonsModel!.unlockedLessons[index].videoUrl,
                                                      title: cubit.getLessonsModel!.unlockedLessons[index].title,
                                                      description: cubit.getLessonsModel!.unlockedLessons[index].description,
                                                      pdfUrl: cubit.getLessonsModel!.unlockedLessons[index].pdfUrl,
                                                      images: '$url/uploads/${cubit.getLessonsModel!.unlockedLessons[index].images[0]}',
                                                    ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    margin: EdgeInsets.symmetric(vertical: 8,),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.3),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                     child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    cubit.getLessonsModel!.unlockedLessons[index].title,
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: Colors.white,
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      cubit.getLessonsModel!.unlockedLessons[index].description,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        color: Colors.white70,
                                                                      ),
                                                                      textAlign: TextAlign.end,
                                                                      maxLines: 3,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                        Icons.arrow_left,
                                                        color: Colors.white,
                                                        size: 48,
                                                          ),

                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ):Container(),
                                              );
                                            });
                                      },
                                      fallback: (c)=>Center(child: Text('لا يوجد بيانات ليتم عرضها')));
                                },
                                fallback: (c)=>Center(child: CircularProgressIndicator(color: Colors.white,)))
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
