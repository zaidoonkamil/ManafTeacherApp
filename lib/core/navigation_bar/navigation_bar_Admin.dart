import 'package:flutter/material.dart';
import 'package:manaf_teacher/features/user/view/profile.dart';

import '../../features/admin/view/ads/all_ads.dart';
import '../../features/admin/view/details/details.dart';
import '../../features/admin/view/home.dart';
import '../styles/themes.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key});

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  int currentIndex = 3;
  List<Widget> screens = [
    ProfileUse(),
    Details(),
    AllAdsAdmin(),
    HomeAdmin(),
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
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              label: "الحساب",

              icon: currentIndex == 0
                  ? Image.asset('assets/images/fluent_person-32-filled.png')
                  : Image.asset('assets/images/fluent_person-16-filled (3).png'),
            ),
            BottomNavigationBarItem(
              label: "التفاصيل",
              icon: currentIndex == 1
                  ? Icon(Icons.details,color: primaryColor,)
                  : Icon(Icons.details,color: Colors.black54,)
            ),
            BottomNavigationBarItem(
              label: "الاخبار",
              icon: currentIndex == 2
                  ? Image.asset('assets/images/fluent_news-16-regular (1).png')
                  : Image.asset('assets/images/fluent_news-16-regular.png'),
            ),
            BottomNavigationBarItem(
              label: "الرئيسية",
              icon: currentIndex == 3
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
      )
      ,
    );
  }
}