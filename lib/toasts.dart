import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class MyToasts {
  successToast(BuildContext context, {Color? color, String? toast}) {
    final Widget widget = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF2FFFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        toast ?? "Success",
        style: TextStyle(
            color: Color(0xFF2E3E5C),
            fontWeight: FontWeight.w500,
            fontSize: 15),
      ),
    );

    final ToastFuture toastFuture = showToastWidget(
      widget,
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
      onDismiss: () {
        debugPrint('Toast has been dismissed.');
      },
    );
  }

  erroToast(BuildContext context, {Color? color, String? toast}) {
    final Widget widget = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFFE9E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              toast ?? "Error",
              style: TextStyle(
                  color: Color(0xFF2E3E5C),
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  warningToast(BuildContext context, {Color? color, String? toast}) {
    final Widget widget = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFFE9E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        toast ?? "Warning",
        style: TextStyle(
            color: Color(0xFF2E3E5C),
            fontWeight: FontWeight.w500,
            fontSize: 15),
      ),
    );

    final ToastFuture toastFuture = showToastWidget(
      widget,
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
      onDismiss: () {
        debugPrint('Toast has been dismissed.');
      },
    );
  }
}
