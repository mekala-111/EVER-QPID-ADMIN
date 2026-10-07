import 'package:flutter/material.dart';

import '../../utils/p_colors.dart';

class LoadingBar {
  static Widget buttonLoad() => SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(color: PColors.colorFFFFFF),
      );

  static Widget loading() {
    return SizedBox.square(
      dimension: 30,
      child: CircularProgressIndicator(color: PColors.primaryColor),
    );
  }

  static popUpLoadingBar(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 40),
              //sconst Text("Loading...")
            ],
          ),
        );
      },
    );
  }

  static offPopLoadingBar(BuildContext context) {
    Navigator.pop(context);
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          color: PColors.primaryColor,
        ),
      ),
    );
  }
}
