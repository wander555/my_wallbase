import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'network/http/service_manager.dart';
import 'network/service/custom_service.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'loadMoreGrid.dart';

void main() {
  runApp(MyApp());
  //   //注册api服务
  ServiceManager().registeredService(CustomService());
  FlutterDisplayMode.setHighRefreshRate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      home: Home(),
      builder: EasyLoading.init(),
    );
  }
}

class Controller extends GetxController {}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return Scaffold(
        appBar: AppBar(title: Text("appBar")),
        body: RefreshConfiguration(
            headerTriggerDistance:
                80.0, // header trigger refresh trigger distance
            springDescription: SpringDescription(
                stiffness: 170,
                damping: 16,
                mass:
                    1.9), // custom spring back animate,the props meaning see the flutter api
            maxOverScrollExtent:
                100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
            maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
            enableScrollWhenRefreshCompleted:
                true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
            enableLoadingWhenFailed:
                true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
            hideFooterWhenNotFull:
                true, // Disable pull-up to load more functionality when Viewport is less than one screen
            enableBallisticLoad:
                true, // trigger load more by BallisticScrollActivity
            child: OnlyGridView()));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
