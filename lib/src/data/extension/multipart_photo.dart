import 'dart:io';

import 'package:dio/dio.dart';

/// Wraps a picked photo's local [path] as a multipart file part.
Future<MultipartFile> photoPart(String path) =>
    MultipartFile.fromFile(path, filename: File(path).uri.pathSegments.last);
