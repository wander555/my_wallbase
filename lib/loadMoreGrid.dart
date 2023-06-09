import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_wallbase/permission_check.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Item.dart';
import 'package:logger/logger.dart';
import 'network/api/index_api.dart';
import 'package:permission_handler/permission_handler.dart';

class OnlyGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnlyGridViewState();
  }
}

class _OnlyGridViewState extends State<OnlyGridView> {
  var logger = Logger();
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  List<dynamic> list = [];
  int _page = 1;
  IndexApi api = IndexApi();
  Map<String, dynamic> query = {
    "topRange": "1d",
    "apikey": "dKH33i2L11kM1ZzuiT8MIPm9hYCQ74Tb",
    "resolutions": "2160x3840",
    // "atleast": "2160x3840",
    "sorting":
        "date_added", //date_added*, relevance, random, views, favorites, toplist
    "purity": "100", //100*/110/111/etc (sfw/sketchy/nsfw)
  };

  //构建子类
  Widget buildCtn() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.5625, //宽高比
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (c, i) => Item(
          id: list[i]["id"],
          thumUrl: list[i]["thumbs"]["original"],
          url: list[i]["path"],
          colors: list[i]["colors"],
          favorites: list[i]["favorites"]),
      itemCount: list.length,
    );
  }

  @override
  void initState() {
    super.initState();
    // _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      child: buildCtn(),
      header: WaterDropMaterialHeader(),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 500),
      ),
      onRefresh: () async {
        _page = 1;
        query = {...query, "page": _page};
        api.request(
            query: query,
            successCallBack: (data) {
              list = data["data"];
              if (mounted) setState(() {});
              _refreshController.refreshCompleted();
            },
            errorCallBack: (error) {
              logger.e(error);
              _refreshController.refreshFailed();
            });
      },
      onLoading: () async {
        _page++;
        query = {...query, "page": _page};
        api.request(
            query: query,
            successCallBack: (data) {
              //增加数据
              list = [...list, ...data["data"]];

              if (mounted) setState(() {});
              _refreshController.loadComplete();
            },
            errorCallBack: (error) {
              logger.e(error);
              _refreshController.loadFailed();
              _page--;
            });
      },
    );
  }
}
