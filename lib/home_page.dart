import 'package:flutter/material.dart';
import 'package:sample_download/models/data.dart';
import 'package:sample_download/screens/tile_list_screen.dart';
import 'package:sample_download/services/check_permission.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  DataList dataList = DataList();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: isPermission
          ? ListView.builder(
              itemCount: dataList.dataList.length,
              itemBuilder: (context, index) {
                var data = dataList.dataList[index];
                return TitleListScreen(fileUrl: data['url']!, title: data['title']!);
              })
          : ElevatedButton(
              onPressed: () {
                checkPermission();
              },
              child: const Center(child: Text("Permission Issue")),
            ),
    );
  }
}
