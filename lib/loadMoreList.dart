import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Item.dart';
import 'package:logger/logger.dart';

import 'network/api/index_api.dart';

//only ListView
class OnlyListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OnlyListViewState();
  }
}

class _OnlyListViewState extends State<OnlyListView> {
  var logger = Logger();
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  List<dynamic> list = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();

  Widget buildCtn() {
    return ListView.separated(
      key: _contentKey,
      reverse: true,
      padding: EdgeInsets.only(left: 5, right: 5),
      itemBuilder: (c, i) => Item(
        title: list[i]["thumbs"]["small"],
      ),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          // color: Colors.greenAccent,
        );
      },
      itemCount: list.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      key: _refresherKey,
      controller: _refreshController,
      enablePullUp: true,
      child: buildCtn(),
      header: WaterDropMaterialHeader(),
      physics: BouncingScrollPhysics(),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 500),
      ),
      onRefresh: () async {
        //monitor fetch data from network
        // await Future.delayed(Duration(milliseconds: 1000));

        // for (int i = 0; i < 10; i++) {
        //   data.add("Item $i");
        // }

        // if (mounted) setState(() {});
        // _refreshController.refreshCompleted();

        /*
        if(failed){
         _refreshController.refreshFailed();
        }
      */

        IndexApi api = IndexApi();
        Map<String, dynamic> query = {
          "topRange": "1d",
          "apikey": "dKH33i2L11kM1ZzuiT8MIPm9hYCQ74Tb",
          "resolutions": "2160x3840",
          "sorting": "favorites",
          "purity": "100"
        };
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
        //monitor fetch data from network
        await Future.delayed(Duration(milliseconds: 1000));
//        for (int i = 0; i < 10; i++) {
//          data.add("Item $i");
//        }
        // list = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

        if (mounted) setState(() {});
        _refreshController.loadComplete();
      },
    );
  }
}
