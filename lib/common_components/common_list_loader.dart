import 'package:flutter/material.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/utils/assets_path.dart';

class LoadingList extends StatelessWidget {
  const LoadingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/icon/load-more.gif"),
        ],
      ),
    );
  }
}
