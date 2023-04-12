import 'dart:ui';

import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'info.dart';

class Item extends StatefulWidget {
  final String id;
  final String thumUrl;
  final String url;
  final List colors;

  Item(
      {required this.id,
      required this.thumUrl,
      required this.url,
      required this.colors});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    // final size = MediaQuery.of(context).size;
    // final imgWidth = (size.width - 40) / 3;
    // final imgHeight = imgWidth * (3840 / 2160) * 2;

    return new GestureDetector(
      onTap: () {
        // Get.defaultDialog(title: widget.url);
        Get.to(WallPaperInfo(
            id: widget.id, url: widget.thumUrl, colors: widget.colors));
      },
      child: Container(
        //图片撑满布局
        child: ConstrainedBox(
          // child: CachedNetworkImage(
          //   imageUrl: widget.thumUrl,
          //   // 用图片占位
          //   // placeholder: (context, url) =>
          //   //     Image.network("http://via.placeholder.com/169x300"),

          //   //高斯模糊背景图占位
          //   placeholder: (context, url) => Container(
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(
          //         sigmaX: 20,
          //         sigmaY: 20,
          //       ),
          //       child: Container(color: HexColor(widget.colors[1])),
          //     ),
          //   ),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          //   fit: BoxFit.cover,
          // ),
          child: Container(color: Colors.lightBlue),
          constraints: new BoxConstraints.expand(),
        ),

        //切圆角
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
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
