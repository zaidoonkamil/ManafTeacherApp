import 'package:flutter/material.dart';
import 'package:manaf_teacher/features/user/view/home.dart';
import '../../features/user/view/Lectures.dart';
import '../../features/user/view/dgree.dart';
import '../../features/user/view/exam/exam.dart';
import '../../features/user/view/profile.dart';
import '../styles/themes.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 4;
  List<Widget> screens = [
    ProfileUse(),
    Lectures(),
    DegreeUser(),
    Exam(),
    HomeUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: Offset(0, -3)
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              label: "الحساب",
              icon: currentIndex == 0
                  ? Image.asset('assets/images/fluent_person-32-filled.png')
                  : Image.asset('assets/images/fluent_person-16-filled (3).png'),
            ),
            BottomNavigationBarItem(
              label: "المحاضرات",
              icon: currentIndex == 1
                  ? Image.asset('assets/images/fluent_news-16-regular (1).png')
                  : Image.asset('assets/images/fluent_news-16-regular.png'),
            ),
            BottomNavigationBarItem(
              label: "نتائجي",
              icon: currentIndex == 2
                  ? Image.asset('assets/images/healthicons_i-exam-multiple-choice-outline (1).png')
                  : Image.asset('assets/images/healthicons_i-exam-multiple-choice-outline.png'),
            ),
            BottomNavigationBarItem(
              label: "الاختبارات",
              icon: currentIndex == 3
                  ? Image.asset('assets/images/ph_exam (1).png')
                  : Image.asset('assets/images/ph_exam.png'),
            ),
            BottomNavigationBarItem(
              label: "الرئيسية",
              icon: currentIndex == 4
                  ? Image.asset('assets/images/mynaui_home (1).png')
                  : Image.asset('assets/images/mynaui_home.png'),
            ),
          ],
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}