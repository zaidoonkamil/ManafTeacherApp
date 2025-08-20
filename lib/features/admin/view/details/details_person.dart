import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/network/remote/dio_helper.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';


class DetailsPerson extends StatelessWidget {
  const DetailsPerson({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String role;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getLessonsUserLock(context: context, userId: id,),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=AdminCubit.get(context);
          DateTime date = DateTime.parse(createdAt);
          String formattedDate = "${date.year}-${date.month}-${date.day}";
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    navigateBack(context);
                                  },
                                  child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
                              const Text(
                                textAlign: TextAlign.right,
                                'تفاصيل الطلاب',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30,vertical: 14),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0XFF212529),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              )
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Spacer(),
                                  Column(
                                    children: [
                                      Text(name,style: TextStyle(fontSize: 14),),
                                      SizedBox(height: 10,),
                                      Text(phone,style: TextStyle(fontSize: 14),),
                                      SizedBox(height: 10,),
                                      Text(role,style: TextStyle(fontSize: 14),),
                                      SizedBox(height: 10,),
                                      Text(formattedDate,style: TextStyle(fontSize: 14),),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(':الاسم',style: TextStyle(fontSize: 16),),
                                      SizedBox(height: 10,),
                                      Text(':الهاتف',style: TextStyle(fontSize: 16),),
                                      SizedBox(height: 10,),
                                      Text(':الصلاحياة',style: TextStyle(fontSize: 16),),
                                      SizedBox(height: 10,),
                                      Text(':تاريخ الانشاء',style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ConditionalBuilder(
                            condition: cubit.getLessonsModel != null,
                            builder: (c){
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cubit.getLessonsModel!.unlockedLessons.length,
                                itemBuilder: (context, index) {
                                  final lesson = cubit.getLessonsModel!.unlockedLessons[index];
                                  return Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.8,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                              child: Image.network(
                                                '$url/uploads/${lesson.images[0]}',
                                                height: 140,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        lesson.title,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.end,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          lesson.description,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: Colors.white70,
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    cubit.getLessonsModel!.unlockedLessons[index].isLocked ? '🔒 مقفول' : '🔓 مفتوح',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  Switch(
                                                    value: cubit.getLessonsModel!.unlockedLessons[index].isLocked,
                                                    onChanged: (value) {
                                                      cubit.updateLock(
                                                        context: context,
                                                        isLocked: value,
                                                        lessonsId: cubit.getLessonsModel!.unlockedLessons[index].id.toString(),
                                                        userId: id,
                                                      );
                                                      cubit.getLessonsModel!.unlockedLessons[index].isLocked = value;
                                                    },
                                                    activeColor: Colors.green,
                                                    inactiveThumbColor: Colors.red,
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  );
                                },
                              );
                            },
                            fallback: (c)=>Container()
                        ),
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
