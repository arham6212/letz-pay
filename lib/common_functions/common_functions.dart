import 'package:flutter/material.dart';
import 'package:letzpay/common_components/list.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/strings.dart';

//
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

navigateToNextScreen(BuildContext context, Widget widget, bool anim) {
  if (anim) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return widget;
        },
        transitionDuration: const Duration(milliseconds: 2000),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(curve: curveList[36], parent: animation);
          return Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
              axisAlignment: 0.0,
            ),
          );
        }));
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }
  Future pushReplacement(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }
}

//get transaction Icon according to transaction type
String getTransIcon(transType) {
  switch (transType.toString()) {
    case "ALL":
      return upipaymentIcon;
    case "CARD":
      return cardIcon;
    case "IN":
      return internationalIcon;
    case "UPI":
      return upipaymentIcon;
    case "UP":
      return upipaymentIcon;
    case "nb":
      return nbIcon;
    case "NB":
      return nbIcon;
    case "WALLET":
      return walletIcon;
    case "WL":
      return walletIcon;
    case "UPI QR":
      return upiqrIcon;
    case "UPI_QR":
      return upiqrIcon;
    case "PG QR":
      return upiqrIcon;
    case "PG_QR":
      return upiqrIcon;
    case "STATIC QR":
      return upiqrIcon;
    case "STATIC_PG_QR":
      return upiqrIcon;
    case "STATIC_UPI_QR":
      return upiqrIcon;
    case "EM":
      return cardIcon;
    case "CASH":
      return cashondeliveryIcon;
    case "CD":
      return cashondeliveryIcon;
    default:
      return upiqrIcon;
  }
}

//get transaction text according to transaction type
String getTransText(transType) {
  switch (transType.toString().toUpperCase()) {
    case "ALL":
      return transType.toString();
    case "CARD":
      return crDeCardLbl;
    case "CC":
      return creditCardLbl;
    case "DC":
      return debitCardLbl;
    case "IN":
      return internationalLbl;
    case "NB":
      return netBankingLbl;
    case "UP":
      return upiLbl;
    case "UPI_QR":
      return upiQrLbl;
    case "PG_QR":
      return pgQrLbl;
    case "EM":
      return emiLbl;
    case "WL":
      return walletLbl;
    case "CD":
      return cashOnDeliveryLbl;
    default:
      return transType.toString();
  }
}

//get status according to transaction type
String getStatuDtata(transType) {
  switch (transType.toString()) {
    case "ALL":
      return transType.toString();
    case "Success":
      return "Captured";
    case "Captured":
      return "Success";
    case "Pending":
      return "Pending";
    case "Failed":
      return "Failed";
    case "Cancelled":
      return "Cancelled";
    default:
      return transType.toString();
  }
}

//get payment data according to transaction type
String getPaymentData(transType) {
  switch (transType.toString()) {
    case "ALL":
      return transType.toString();
    case crDeCardLbl:
      return "CARD";
    case internationalLbl:
      return "IN";
    case netBankingLbl:
      return "NB";
    case upiLbl:
      return "UP";
    case upiQrLbl:
      return "UPI_QR";
    case pgQrLbl:
      return "PG_QR";
    case emiLbl:
      return "EM";
    case walletLbl:
      return "WL";
    case cashOnDeliveryLbl:
      return "CD";
    default:
      return transType.toString();
  }
}

//convert String to decimal
String convertAmountTwoDecimal(String amount) {
  String strAmount = "0";
  if (amount == null) {
    strAmount = "0";
  } else if (amount.isNotEmpty) {
    strAmount = amount;
  }

  return double.parse(strAmount).toStringAsFixed(2);
}

//get no days between two date
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
