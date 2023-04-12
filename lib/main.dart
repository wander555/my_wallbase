import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'network/http/service_manager.dart';
import 'network/service/custom_service.dart';

import 'loadMoreGrid.dart';

void main() {
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.fade,
    home: Home(),
  ));

  //注册服务
  ServiceManager().registeredService(CustomService());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("appBar")), body: OnlyGridView());
  }
}
