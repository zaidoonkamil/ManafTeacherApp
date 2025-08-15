import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manaf_teacher/features/admin/view/lessons/add_lessons.dart';
import 'package:manaf_teacher/features/admin/view/lessons/all_video.dart';
import 'package:manaf_teacher/features/user/view/lessons/lessons.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/background.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/view/ads.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'lessons/add_video.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getAds(context: context, page: '1')
        ..getProfile(context: context)
      ..getLessons(context: context,),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is UpdateLockSuccessState){
            showToastSuccess(
                text: 'تم التحديث',
                context: context);
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  ConditionalBuilder(
                      condition: cubit.profileModel != null,
                      builder: (c){
                        return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                '! مرحباا مجددا',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              Text(
                                                cubit.profileModel!.name.toString(),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 8,),
                                          Image.asset('assets/images/Group 1171275633 (2).png'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 26,),
                                Column(
                                  children: [
                                    ConditionalBuilder(
                                      condition:cubit.ads.isNotEmpty,
                                      builder:(c){
                                        return Column(
                                          children: [
                                            CarouselSlider(
                                              items: cubit.ads.isNotEmpty
                                                  ? cubit.ads.expand((ad) => ad.images.map((imageUrl) => Builder(
                                                builder: (BuildContext context) {
                                                  DateTime dateTime = ad.createdAt;
                                                  String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      navigateTo(context, AdsUser(
                                                        tittle: ad.title,
                                                        desc: ad.description,
                                                        image: imageUrl,
                                                        time: formattedDate,
                                                      ));
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: Image.network(
                                                        "$url/uploads/$imageUrl",
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ))).toList()
                                                  : [],
                                              options: CarouselOptions(
                                                height: 160,
                                                viewportFraction: 0.85,
                                                enlargeCenterPage: true,
                                                initialPage: 0,
                                                enableInfiniteScroll: true,
                                                reverse: true,
                                                autoPlay: true,
                                                autoPlayInterval: const Duration(seconds: 6),
                                                autoPlayAnimationDuration:
                                                const Duration(seconds: 1),
                                                autoPlayCurve: Curves.fastOutSlowIn,
                                                scrollDirection: Axis.horizontal,
                                                onPageChanged: (index, reason) {
                                                  currentIndex=index;
                                                  cubit.slid();
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 8,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: List.generate(cubit.ads.length, (index) {
                                                return Container(
                                                  width: currentIndex == index ? 30 : 8,
                                                  height: 7.0,
                                                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: currentIndex == index
                                                        ? primaryColor
                                                        : Colors.white,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      },
                                      fallback: (c)=> Container(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 26,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        ': المحاضرات',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      navigateTo(context, AddLessons(courseId: '1'));
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                        border: Border.all(
                                      color: Colors.white,
                                        width: 1.5,
                                      )
                                      ),
                                      child: Text('اضافة محاضرة جديد',textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                     navigateTo(context, AddVideo());
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                        border: Border.all(
                                      color: Colors.white,
                                        width: 1.5,
                                      )
                                      ),
                                      child: Text('اضافة فيديو',textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                     navigateTo(context, AllVideo());
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                        border: Border.all(
                                      color: Colors.white,
                                        width: 1.5,
                                      )
                                      ),
                                      child: Text('عرض كل الفيديوات',textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ConditionalBuilder(
                                      condition: cubit.getLessonsModel.isNotEmpty,
                                      builder: (c){
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: cubit.getLessonsModel.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                navigateTo(context, Lessons(
                                                    videoUrl: cubit.getLessonsModel[index].videoUrl,
                                                    title: cubit.getLessonsModel[index].title,
                                                    description: cubit.getLessonsModel[index].description,
                                                    pdfUrl: cubit.getLessonsModel[index].pdfUrl,
                                                    images: '$url/uploads/${cubit.getLessonsModel[index].images[0]}'));
                                              },
                                              child: Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Color(0XFF212529),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.5,
                                                    )
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(8),
                                                          topRight: Radius.circular(8),
                                                      ),
                                                      child: Image.network(
                                                        '$url/uploads/${cubit.getLessonsModel[index].images[0]}',
                                                        height: 130,
                                                        width: double.maxFinite,
                                                        fit: BoxFit.fill,
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
                                                                cubit.getLessonsModel[index].title.toString(),
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
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  cubit.getLessonsModel[index].description.toString(),
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
                                                    SizedBox(height: 14),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          cubit.deleteLessons(
                                                              id: cubit.getLessonsModel[index].id.toString(),
                                                              context: context);
                                                        },
                                                        child: Container(
                                                          width: double.maxFinite,
                                                          padding: EdgeInsets.symmetric(vertical: 12),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8),
                                                              color: Colors.red
                                                          ),
                                                          child: Text('حذف',textAlign: TextAlign.center,),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            cubit.getLessonsModel[index].isLocked ? '🔒 مقفول' : '🔓 مفتوح',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          Switch(
                                                            value: cubit.getLessonsModel[index].isLocked,
                                                            onChanged: (value) {
                                                              cubit.updateLock(
                                                                context: context,
                                                                isLocked: value,
                                                                id: cubit.getLessonsModel[index].id.toString(),
                                                              );
                                                              print( cubit.getLessonsModel[index].id.toString());
                                                              cubit.getLessonsModel[index].isLocked = value;
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
                                            ),
                                            SizedBox(height: 14,),
                                          ],
                                        );
                                      },
                                    );
                                      },
                                      fallback: (c)=>CircularProgressIndicator(color: primaryColor,)
                                  ),
                                ),
                              ],
                            )
                        );
                      },
                      fallback: (c)=>Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator(color: primaryColor,)),
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
