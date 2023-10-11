import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryPath {
  getPath() async {
    final Directory? tempDir = await getExternalStorageDirectory();
    final filePath = Directory("/storage/emulated/0/Download");
    // final filePathc
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
  }
}
