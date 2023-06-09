import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:my_wallbase/permission_check.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uri_to_file/uri_to_file.dart';

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

  //下载图片
  _downloadImg(String url, String id) async {
    bool permission_result = await _requestPermission();

    if (!permission_result) {
      EasyLoading.showError("下载失败!");
      return false;
    }

    EasyLoading.show(status: '正在设置...');
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data), //转字节
        quality: 100,
        name: id);
    return result;
  }

  //设置为背景图片
  void setWallpaperFromFile(String url, String id) async {
    String filePath = "";
    await _downloadImg(url, id).then((data) async {
      if (data) {
        File file = await toFile(data['filePath']);
        filePath = file.path;
      } else {
        filePath = "";
      }
    });

    // logger.i(filePath);

    if (filePath == "") {
      EasyLoading.showError("设置失败!");
    } else {
      String result = "";
      try {
        result = await AsyncWallpaper.setWallpaperFromFile(
          filePath: filePath,
          wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
          goToHome: false,
          // toastDetails: ToastDetails.success(),
          // errorToastDetails: ToastDetails.error(),
        )
            ? '设置成功!'
            : '设置失败!';
        logger.e(result);
      } on Exception catch (e) {
        logger.e(e);
        result = '获取失败!';
      }

      EasyLoading.showSuccess(result);
      EasyLoading.dismiss();
    }
  }

//申请权限
  _requestPermission() async {
    bool result =
        await permissionCheckAndRequest(context, Permission.storage, "存储");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        onTap: () =>
                            setWallpaperFromFile(widget.url, widget.id),
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
