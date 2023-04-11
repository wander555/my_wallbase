import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'network/api/index_api.dart';
import 'network/http/service_manager.dart';
import 'network/service/custom_service.dart';

import 'loadMoreList.dart';

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
        appBar: AppBar(title: Text("appBar")), body: OnlyListView());
  }
}

class TestBody extends StatefulWidget {
  const TestBody({super.key});

  @override
  State<TestBody> createState() => _TestBodyState();
}

class _TestBodyState extends State<TestBody> {
  var logger = Logger();

  void _pressed() {
    IndexApi api = IndexApi();

    Map<String, dynamic> query = {
      "topRange": "1d",
      "apikey": "dKH33i2L11kM1ZzuiT8MIPm9hYCQ74Tb",
      "resolutions": "2160x3840",
      "sorting": "favorites"
    };
    api.request(
        query: query,
        successCallBack: (data) {
          logger.i(data["data"][0]);
        },
        errorCallBack: (error) {
          logger.e(error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: _pressed,
      ),
    );
  }
}
