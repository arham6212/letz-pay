import 'package:flutter/cupertino.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../common_components/common_widget.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          errorNoDataAvailableLbl.text
              .size(16)
              .color(Vx.hexToColor(balckMainColor))
              .bold
              .make(),
          VSpace(5),
          errorNoDataAvailableDesc.text
              .size(12)
              .color(Vx.hexToColor(greySubTextColor))
              .make(),
        ],
      ),
    );
  }
}
