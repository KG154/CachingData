import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/Sqflite_database/databasehelper.dart';
import 'package:localstorage/toasts.dart';
import 'package:sqflite/sqflite.dart';

class MyCheckDb {
  ///check Internet when app open first time or running app
  Future<bool?> checkInternet(context) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        print("InterNet Connected");
        return true;
      } else {
        MyToasts().successToast(context, toast: "Internet Not Connected");
        print("InterNet Not Connected");
        return false;
      }
    } on SocketException catch (ex) {
      print('not connected');
      return false;
    }
  }

  ///Insert or Update data in local storage
  Future<void> insertUpdateDB({
    required Database database,
    required String uri,
    required String body,
    required String response,
  }) async {
    DatabaseHandler().rawData(database, uri, body).then((value) {
      List val = value;
      if (val.length == 0) {
        log("<==== Data Insert ====>");
        DatabaseHandler().insertData(database, uri, body, response);
      } else {
        log("<==== Data Update ====>");
        DatabaseHandler()
            .updateData(database, val.first['id'], uri, body, response);
      }
    });
  }

  ///check internet when app is open
  internetOnOff({void Function()? data}) async {
    MyConnectivity.instance.initialise();
    MyConnectivity.instance.myStream.listen((onData) async {
      if (MyConnectivity.instance.isIssue(onData)) {
        if (MyConnectivity.instance.isShow == false) {
          MyConnectivity.instance.isShow = true;
          await data;
          print("Internet Not Connected22");
        }
      } else {
        if (MyConnectivity.instance.isShow == true) {
          await data;
          print("Internet Connected22");
        }
      }
    });
  }
}

///check Internet connectivity when app open
class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;
  bool isShow = false;

  Future<void> initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    await _checkStatus(result);
    connectivity.onConnectivityChanged.listen(_checkStatus);
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  bool isIssue(dynamic onData) =>
      onData.keys.toList()[0] == ConnectivityResult.none;

  void disposeStream() => controller.close();
}

///other
Future<dynamic> showDialogNotInternet(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Container(
          height: 200,
          // width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          // padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Color(0xFFf65656),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 45,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text("ERROR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )),
                    SizedBox(height: 8),
                    Text("NO AVAILABLE CONNECTION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        )),
                    // SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("Connection could not be able to Reconnect",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black54,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
