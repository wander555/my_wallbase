import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WallPaperInfo extends StatefulWidget {
  final String url;
  final String thumUrl;
  final String id;
  final List colors;

  const WallPaperInfo(
      {super.key,
      required this.id,
      required this.url,
      required this.colors,
      required this.thumUrl});

  @override
  State<WallPaperInfo> createState() => _WallPaperInfoState();
}

class _WallPaperInfoState extends State<WallPaperInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        child: CachedNetworkImage(
          imageUrl: widget.url,
          // 用图片占位
          placeholder: (context, url) => CachedNetworkImage(
            imageUrl: widget.thumUrl,
            fit: BoxFit.cover,
          ),

          //高斯模糊背景图占位
          // placeholder: (context, url) => Container(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(
          //       sigmaX: 20,
          //       sigmaY: 20,
          //     ),
          //     child: Container(color: HexColor(widget.colors[0])),
          //   ),
          // ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        // child: Container(color: Colors.lightBlue),
        constraints: new BoxConstraints.expand(),
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
