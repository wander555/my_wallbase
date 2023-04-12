import 'dart:math';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Item extends StatefulWidget {
  final String id;
  final String thumUrl;
  final String url;

  Item({required this.id, required this.thumUrl, required this.url});

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

    return Container(
      child: Card(
        //图片撑满布局
        child: ConstrainedBox(
          child: CachedNetworkImage(
            imageUrl: widget.thumUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          constraints: new BoxConstraints.expand(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
