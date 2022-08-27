import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/class.dart';
import 'package:localstorage/Sqflite_database/databasehelper.dart';
import 'package:localstorage/Model/user_detail_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class UserDataScreen extends StatefulWidget {
  String? id;
  String? name;

  UserDataScreen({Key? key, this.id, this.name}) : super(key: key);

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  updateUi() {
    if (mounted) {
      setState(() {});
    }
  }

  Database? _database;
  userDetailsModel? detailsModel;

  String uri_c = "http://192.168.29.72/Practical_Api/api/get_user_details";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// first create db & calling api
    DatabaseHandler().CreateDataBase().then(
      (value) {
        _database = value;
        getUserDetailsApi();
      },
    );

    /// check internet when app open &
    /// data on  - get data from api &
    /// data off - sqflite db
    MyCheckDb().internetOnOff(
      data: () {
        DatabaseHandler().CreateDataBase().then(
          (value) {
            _database = value;
            getUserDetailsApi();
          },
        );
      },
    );
  }

  /// calling api
  Future<userDetailsModel?> getUserDetailsApi() async {
    /// Check InterNet
    final hasInternet = await MyCheckDb().checkInternet(context);

    var bodyData = {"user_id": widget.id.toString()};
    var headerData = {
      "Token":
          "dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc"
    };
    if (hasInternet == true) {
      /// if InterNet is on than Call api and store data locally

      final response = await http.post(Uri.parse(uri_c),
          body: bodyData, headers: headerData);
      log("body response ===== ${response.body}");
      if (response.statusCode == 200) {
        detailsModel = userDetailsModel.fromJson(jsonDecode(response.body));

        ///when call api then store api, response, body, in local storage
        MyCheckDb().insertUpdateDB(
            database: _database!,
            uri: uri_c,
            body: bodyData.toString(),
            response: response.body);

        updateUi();
        return detailsModel;
      } else {
        detailsModel = userDetailsModel.fromJson(jsonDecode(response.body));
        updateUi();
        return detailsModel;
      }
    } else {
      /// if Internet is off than get data from local storage
      DatabaseHandler()
          .rawData(_database!, uri_c, bodyData.toString())
          .then((value) {
        List val = value;
        if (val.isNotEmpty) {
          detailsModel =
              userDetailsModel.fromJson(jsonDecode(val.first['response']));
          updateUi();
          return detailsModel;
        }
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: detailsModel?.data?.profilePic.toString() ?? "",
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Icon(Icons.person),
                  errorWidget: (context, url, error) => Icon(Icons.person),
                ),
              ),
            ),
            Text("User Id  :- ${detailsModel?.data?.userId.toString() ?? ""}"),
            Text("Name     :- ${detailsModel?.data?.name.toString() ?? ""}"),
            Text("Email Id :- ${detailsModel?.data?.email.toString() ?? ""}"),
          ],
        ),
      ),
    );
  }
}
