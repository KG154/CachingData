import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/class.dart';
import 'package:localstorage/Sqflite_database/databasehelper.dart';
import 'package:localstorage/screen/user_data_screen.dart';
import 'package:localstorage/Model/user_list_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  updateUi() {
    if (mounted) {
      setState(() {});
    }
  }

  Database? _database;
  allUserList? _userList;

  String uri_G = "http://192.168.29.72/Practical_Api/api/get_user_list";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// first create db & calling api

    DatabaseHandler().CreateDataBase().then(
      (value) {
        _database = value;
        getUserListApi();
      },
    );

    /// check internet when app open &
    /// data on  - get data from api &
    /// data off - sqflite db
    MyCheckDb().internetOnOff(data: () {
      DatabaseHandler().CreateDataBase().then(
        (value) {
          _database = value;
          getUserListApi();
        },
      );
    });

    //   MyConnectivity.instance.initialise();
    //   MyConnectivity.instance.myStream.listen((onData) {
    //     if (MyConnectivity.instance.isIssue(onData)) {
    //       if (MyConnectivity.instance.isShow == false) {
    //         MyConnectivity.instance.isShow = true;
    //         // showDialogNotInternet(context).then((onValue) {
    //         //   MyConnectivity.instance.isShow = false;
    //         // });
    //         DatabaseHandler().CreateDataBase().then(
    //           (value) {
    //             _database = value;
    //             getUserListApi();
    //           },
    //         );
    //       }
    //     } else {
    //       if (MyConnectivity.instance.isShow == true) {
    //         // Navigator.of(context).pop();
    //         // MyConnectivity.instance.isShow = false;
    //         print("Internet Connected22");
    //         DatabaseHandler().CreateDataBase().then(
    //           (value) {
    //             _database = value;
    //             getUserListApi();
    //           },
    //         );
    //       }
    //     }
    //   });
  }

  /// calling api
  Future<allUserList?> getUserListApi() async {
    /// Check InterNet
    final hasInternet = await MyCheckDb().checkInternet(context);

    var headerData = {
      "Token":
          "dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc"
    };
    if (hasInternet == true) {
      /// if InterNet is on than Call api and store data locally

      final response = await http.get(
        Uri.parse(uri_G),
        headers: headerData,
      );
      if (response.statusCode == 200) {
        _userList = allUserList.fromJson(jsonDecode(response.body));

        ///when call api then store api, response, body, in local storage
        MyCheckDb().insertUpdateDB(
            database: _database!,
            uri: uri_G,
            body: "body",
            response: response.body);

        updateUi();
        return _userList;
      } else {
        _userList = allUserList.fromJson(jsonDecode(response.body));
        updateUi();
        return _userList;
      }
    } else {
      /// if Internet is off than get data from local storage

      DatabaseHandler().rawData(_database!, uri_G, "body").then((value) {
        List val = value;
        if (val.isNotEmpty) {
          _userList = allUserList.fromJson(jsonDecode(val.first['response']));
          updateUi();
          return _userList;
        }
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All User List"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getUserListApi();
        },
        child: ListView.builder(
          itemCount: _userList?.data?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserDataScreen(
                      id: _userList!.data![index].userId.toString(),
                      name: _userList!.data![index].name.toString(),
                    );
                  },
                ));
              },
              leading: SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl:
                        _userList?.data?[index].profilePic.toString() ?? "",
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Icon(Icons.person),
                    errorWidget: (context, url, error) => Icon(Icons.person),
                  ),
                ),
              ),
              title: Text("${_userList?.data?[index].name.toString() ?? ""}"),
              subtitle:
                  Text("${_userList?.data?[index].email.toString() ?? ""}"),
            );
          },
        ),
      ),
    );
  }
}
