import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    // logger.i(widget.colors.split(","));
    // logger.i(widget.colors[0]);

    // final size = MediaQuery.of(context).size;
    // final imgWidth = (size.width - 40) / 3;
    // final imgHeight = imgWidth * (3840 / 2160) * 2;

    return Container(
      //图片撑满布局
      child: ConstrainedBox(
        child: CachedNetworkImage(
          imageUrl: widget.thumUrl,

          // 用图片占位
          // placeholder: (context, url) =>
          //     Image.network("http://via.placeholder.com/169x300"),

          //背景颜色占位
          placeholder: (context, url) =>
              Container(color: HexColor(widget.colors[0])),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        constraints: new BoxConstraints.expand(),
      ),

      //切圆角
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
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
