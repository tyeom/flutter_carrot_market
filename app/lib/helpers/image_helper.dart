import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageHelper {
  static const _networkImgUrl = 'http://arong.info:7004/articlesImage/';
  static Widget ImageWidget(
      {required String imgPath, double? width, double? height, BoxFit? fit}) {
    if (imgPath.startsWith('articles_')) {
      return CachedNetworkImage(
        placeholder: (_, __) => new CircularProgressIndicator(),
        errorWidget: (_, __, ___) => Icon(Icons.error),
        width: width,
        height: height,
        fit: fit,
        imageUrl: '$_networkImgUrl$imgPath',
      );
    } else {
      return Image.asset(imgPath, width: width, height: height, fit: fit);
    }
  }
}
