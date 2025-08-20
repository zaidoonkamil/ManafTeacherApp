import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manaf_teacher/core/widgets/background.dart';
import 'package:manaf_teacher/features/user/view/lessons/lessons.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'package:intl/intl.dart';

import 'ads.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  static int currentIndex = 0;
  static int currentIndex2 = 0;
  static List<String> tips = [
    '✔️ لا تنسَ مراجعة درس اليوم',
    '🧠 التكرار سرّ الإتقان – راجع القواعد باستمرار',
    '🕒 الامتحان يقترب؟ ابدأ الآن وخفّف الضغط',
    '💬 عندك سؤال؟ الأستاذ بانتظارك في قسم التواصل',
    '📊 طوّر مستواك مع كل اختبار – التقدّم يبدأ بخطوة',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getAds(context: context, page: '1')
        ..getProfile(context: context)
      ..getLessons(context: context,),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
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
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
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
                                SizedBox(height: 16,),
                                CarouselSlider(
                                  items: tips.map((tip) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: primaryColor,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tip,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 60,
                                    viewportFraction: 0.9,
                                    enlargeCenterPage: true,
                                    reverse: true,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 5),
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                        currentIndex2 = index;
                                        cubit.slid2();
                                    },
                                  ),
                                ),
                                SizedBox(height: 16,),
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
                                SizedBox(height: 18,),
                                ConditionalBuilder(
                                    condition: cubit.getLessonsModel != null,
                                    builder: (c){
                                  return SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cubit.getLessonsModel!.unlockedLessons.length,
                                      itemBuilder: (context, index) {
                                        final lesson = cubit.getLessonsModel!.unlockedLessons[index];
                                       return cubit.getLessonsModel!.unlockedLessons[index].isLocked == false?
                                       Padding(
                                          padding: const EdgeInsets.only(right: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              navigateTo(
                                                context,
                                                Lessons(
                                                  videoUrl: lesson.videoUrl,
                                                  title: lesson.title,
                                                  description: lesson.description,
                                                  pdfUrl: lesson.pdfUrl,
                                                  images: '$url/uploads/${lesson.images[0]}',
                                                ),
                                              );
                                            },
                                            child: Container(
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ):Container();
                                      },
                                    ),
                                  );
                                    },
                                    fallback: (c)=>Container()
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
