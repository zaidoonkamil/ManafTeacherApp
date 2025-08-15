import 'package:flutter/material.dart';
import 'package:manaf_teacher/core/styles/themes.dart';
import 'package:video_player/video_player.dart';

import '../../core/ navigation/navigation.dart';
import '../../core/navigation_bar/navigation_bar.dart';
import '../../core/navigation_bar/navigation_bar_Admin.dart';
import '../../core/network/local/cache_helper.dart';
import '../../core/widgets/background.dart';
import '../../core/widgets/constant.dart';
import '../auth/view/login.dart';
import '../onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/video/video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    Future.delayed(const Duration(seconds: 3), () {
      Widget? widget;
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      if(CacheHelper.getData(key: 'token') == null){
        token='';
        if (onBoarding == true) {
          widget = const Login();
        } else {
          widget = OnboardingScreen();
        }
      }else{
        if(CacheHelper.getData(key: 'role') == null){
          widget = const Login();
          adminOrUser='user';
        }else{
          adminOrUser = CacheHelper.getData(key: 'role');
          if (adminOrUser == 'admin') {
           widget = BottomNavBarAdmin();
          }else{
            widget = BottomNavBar();
          }
        }
        token = CacheHelper.getData(key: 'token') ;
        id = CacheHelper.getData(key: 'id') ??'' ;
      }

      navigateAndFinishAnimation(context, widget);
    });
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Background(),
            if (_controller.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Expanded(
//       child: Container(
//         width: double.maxFinite,
//         height: double.maxFinite,
//         child: Center(child:
//         Image.asset('assets/images/$logo',width: 150,),
//         ),
//       ),
//     ),
//   ],
// ),
