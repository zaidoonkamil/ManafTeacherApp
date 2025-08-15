import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manaf_teacher/core/styles/themes.dart';
import 'package:manaf_teacher/core/widgets/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/ navigation/navigation.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class Degree extends StatelessWidget {
  const Degree({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
      ..getJustUser(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is GetSubmitGradesSuccessState){
            showToastSuccess(text: 'تم الحفظ', context: context);
            navigateBack(context);
          }
          if(state is AddNotificationSuccessState){
            showToastSuccess(
              text: "تم الارسال بنجاح",
              context: context,
            );
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child:  Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Column(
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
                              'درجات الطلاب',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      cubit.justUserModel != null ?
                      Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        itemCount: cubit.justUserModel!.students.length,
                        itemBuilder: (context, index) {
                          final student = cubit.justUserModel!.students[index];
                          final userId = student.id;
                          if (!cubit.inputGrades.containsKey(userId)) {
                            cubit.inputGrades[userId] = {
                              'unitName': student.grade.unitName,
                              'lectureName': student.grade.lectureName,
                              'lectureNos': List<String>.from(student.grade.lectureNos),
                              'examGrades': List<int>.from(student.grade.examGrades),
                              'originalGrades': List<int>.from(student.grade.originalGrades),
                              'resitGrades1': List<int>.from(student.grade.resitGrades1),
                              'resitGrades2': List<int>.from(student.grade.resitGrades2),
                            };
                          }

                          Widget buildContainers(String grades) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                  width: double.infinity,
                                    height: 55,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white54),
                                  //  borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    grades.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                )
                                ]
                            );
                          }
                          Widget buildGradeFields(String key, List<dynamic> grades) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: grades.asMap().entries.map((entry) {
                                int i = entry.key;
                                return TextFormField(
                                  initialValue: grades[i].toString(),
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  ),
                                  onChanged: (val) {
                                    int newVal = int.tryParse(val) ?? 0;
                                    grades[i] = newVal;
                                  },
                                );
                              }).toList(),
                            );
                          }
                          return Card(
                            color: Colors.transparent,
                            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(student.name, style: TextStyle(color: Colors.white, fontSize: 16)),
                                      Text("الاسم", style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(student.phone, style: TextStyle(color: Colors.white70)),
                                      Text("رقم الهاتف", style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  TextFormField(
                                    initialValue: cubit.inputGrades[userId]!['unitName'],
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'اسم الوحدة',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (val) {
                                      cubit.inputGrades[userId]!['unitName'] = val;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            buildContainers(cubit.inputGrades[userId]!['lectureName']),
                                            buildGradeFields( 'lectureNos',cubit.inputGrades[userId]!['lectureNos']),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            buildContainers("درجة الامتحان"),
                                            buildGradeFields( 'examGrades', cubit.inputGrades[userId]!['examGrades']),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            buildContainers("الدرجة الاصلية"),
                                            buildGradeFields( 'originalGrades', cubit.inputGrades[userId]!['originalGrades']),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            buildContainers("درجة الاعادة 1"),
                                            buildGradeFields('resitGrades1', cubit.inputGrades[userId]!['resitGrades1']),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            buildContainers("درجة الاعادة 2"),
                                            buildGradeFields('resitGrades2', cubit.inputGrades[userId]!['resitGrades2']),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                 SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      label: Text("إرسال عبر واتساب",style: TextStyle(color: Colors.white),),
                                      onPressed: () async {
                                        final grades = cubit.inputGrades[userId];
                                        final unitName = grades!['unitName'];
                                        final examGrades = grades['examGrades'];
                                        final originalGrades = grades['originalGrades'];
                                        final resit1 = grades['resitGrades1'];
                                        final resit2 = grades['resitGrades2'];
                                        String message = '''
                                        السلام عليكم ${student.name}،
                                        تم تحديث درجاتك للوحدة "$unitName":
                                        📘 درجات الاختبار:
                                        ${examGrades.join(", ")}
                                        📗 الدرجات الأصلية:
                                        ${originalGrades.join(", ")}
                                        📙 إعادة أولى:
                                        ${resit1.join(", ")}
                                        📕 إعادة ثانية:
                                        ${resit2.join(", ")}
                                        يرجى التأكد من الدرجات والرد إن كان هناك استفسار.
                                        ''';
                                        final encodedMessage = Uri.encodeComponent(message);
                                        final phone = student.phone.replaceAll(RegExp(r'[^\d]'), '');
                                        final whatsappUrl = 'https://wa.me/$phone?text=$encodedMessage';

                                        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                                          await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
                                        } else {
                                          showToastError(context: context, text: "لا يمكن فتح واتساب");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    )
                  ) : Center(child: CircularProgressIndicator(color: Colors.white,)),
                    Row(
                      children: [
                        if (state is GetSubmitGradesLoadingState) Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                        else Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final List<Map<String, dynamic>> allGrades = cubit.justUserModel!.students.map((student) {
                                final userId = student.id;
                                final originalGrade = student.grade;
                                final modified = cubit.inputGrades[userId];

                                return {
                                  'userId': userId,
                                  'unitName': modified?['unitName'] ?? originalGrade.unitName,
                                  'lectureName': modified?['lectureName'] ?? originalGrade.lectureName,
                                  'lectureNos': modified?['lectureNos'] ?? originalGrade.lectureNos,
                                  'examGrades': modified?['examGrades'] ?? originalGrade.examGrades,
                                  'originalGrades': modified?['originalGrades'] ?? originalGrade.originalGrades,
                                  'resitGrades1': modified?['resitGrades1'] ?? originalGrade.resitGrades1,
                                  'resitGrades2': modified?['resitGrades2'] ?? originalGrade.resitGrades2,
                                };
                              }).toList();
                              cubit.submitGrades(context: context, allGrades: allGrades);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: primaryColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('حفظ',style: TextStyle(color: Colors.white,fontSize: 16),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state is AddNotificationLoadingState) Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(color: Colors.white,),
                        ) else Expanded(
                          child: GestureDetector(
                            onTap: () {
                              cubit.addNotification(
                                tittle: 'تحديث الدرجات',
                                desc: 'تم تحديث درجاتك',
                                context: context,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: primaryColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ارسال اشعار',style: TextStyle(color: Colors.white,fontSize: 16),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ],
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
