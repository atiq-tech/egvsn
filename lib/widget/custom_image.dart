import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:egovisionapp/utils/k_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class CustomImage extends StatelessWidget {
  const CustomImage({
    Key? key,
    required this.path,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.color,
    this.isFile = false,
  }) : super(key: key);
  final String? path;
  final BoxFit fit;
  final double? height, width;
  final Color? color;
  final bool isFile;

  @override
  Widget build(BuildContext context) {
    // final imagePath = path ?? Kimages.kNetworkImage;
    final imagePath = path == null || path == '' ? Kimages.defaultImage : path;

    if (isFile) {
      return Image.file(
        File(imagePath!),
        fit: fit,
        color: color,
        height: height,
        width: width,
      );
    }

    if (imagePath!.endsWith('.svg')) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          imagePath,
          fit: fit,
          height: height,
          width: width,
          color: color,
        ),
      );
    }
    if (imagePath.startsWith('http') ||
        imagePath.startsWith('https') ||
        imagePath.startsWith('www.')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        color: color,
        height: height,
        width: width,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => const Image(image: AssetImage(Kimages.defaultImage)),
      );
    }
    return Image.asset(
      imagePath,
      fit: fit,
      color: color,
      height: height,
      width: width,
    );
  }
}