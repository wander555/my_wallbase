import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WallPaperInfo extends StatefulWidget {
  final String url;
  final String thumUrl;
  final String id;
  final List colors;
  final int favorites;

  const WallPaperInfo(
      {super.key,
      required this.id,
      required this.url,
      required this.colors,
      required this.thumUrl,
      required this.favorites});

  @override
  State<WallPaperInfo> createState() => _WallPaperInfoState();
}

class _WallPaperInfoState extends State<WallPaperInfo> {
  Logger logger = new Logger();
  void _downloadImg(String url, String id) async {
    logger.i(url);

    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: id);

    logger.i(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),

        // child: CachedNetworkImage(
        //   imageUrl: widget.url,
        //   // 用图片占位
        //   placeholder: (context, url) => CachedNetworkImage(
        //     imageUrl: widget.thumUrl,
        //     fit: BoxFit.cover,
        //   ),

        //   // progressIndicatorBuilder: (context, url, downloadProgress) =>
        //   //     CircularProgressIndicator(value: downloadProgress.progress),
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        //   fit: BoxFit.cover,
        // ),
        // child: Container(color: Colors.lightBlue),

        child: Stack(
          alignment: Alignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: CachedNetworkImage(
                imageUrl: widget.url,
                // 用图片占位
                placeholder: (context, url) => CachedNetworkImage(
                  imageUrl: widget.thumUrl,
                  fit: BoxFit.cover,
                ),

                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                //     CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                left: 12.0,
                top: 12.0,
                child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          ),
                          Text(
                            widget.favorites.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 2, bottom: 2),
                    ))),
            Positioned(
                bottom: 30,
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _downloadImg(widget.url, widget.id),
                        child: Icon(
                          Icons.download,
                          color: Colors.red,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ))
          ],
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
