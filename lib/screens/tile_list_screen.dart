import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sample_download/services/directory_path.dart';
import 'package:path/path.dart' as Path;

class TitleListScreen extends StatefulWidget {
  const TitleListScreen({super.key, required this.fileUrl, required this.title});

  final String fileUrl;
  final String title;

  @override
  State<TitleListScreen> createState() => _TitleListScreenState();
}

class _TitleListScreenState extends State<TitleListScreen> {
  bool isdownload = false;
  bool fileExist = false;
  double progress = 0.0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  void startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      isdownload = true;
      progress = 0;
    });
    try {
      await Dio().download(widget.fileUrl, filePath, onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Download Successful"),
        ));
      });
      setState(() {
        isdownload = false;
        fileExist = true;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isdownload = false;
      });
    }
  }

  // void cancelDownload() async {
  //   cancelToken.cancel();
  //   setState(() {
  //     isdownload = false;
  //   });
  // }

  // void checkFileExits() async {
  //   var storePath = await getPathFile.getPath();
  //   filePath = '$storePath/$fileName';
  //   bool fileExistCheck = await File(filePath).exists();
  //   setState(() {
  //     fileExist = fileExistCheck;
  //   });
  // }

  void openFile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = Path.basename(widget.fileUrl);
    });
    // checkFileExits();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(widget.title),
        trailing: IconButton(
          onPressed: () {
            fileExist && isdownload == false ? openFile() : startDownload();
          },
          icon: fileExist
              ? const Icon(
                  Icons.save,
                  color: Colors.green,
                )
              : isdownload
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Text(
                          (progress * 100).toStringAsFixed(2),
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    )
                  : const Icon(Icons.download),
        ),
      ),
    );
  }
}
