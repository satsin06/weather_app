import 'package:flutter/material.dart';

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );

  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}

setSnackbar(String msg, BuildContext context,
    {Color color = Colors.greenAccent,
    Duration duration = const Duration(seconds: 4)}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        //behavior: SnackBarBehavior.floating,
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        backgroundColor: color,
        duration: duration,
      ),
    );
}
