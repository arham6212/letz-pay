import 'package:letzpay/common_components/logger.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/strings.dart';

class Loginauthresponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? bUSINESSNAME;
  String? uSERTYPE;
  String? sESSIONID;
  String? sUPERMERCHANT_FLAG;
  String? sUPERMERCHANT_PAY_ID;

  Loginauthresponse(
      {this.rESPONSECODE,
      this.rESPONSEMESSAGE,
      this.bUSINESSNAME,
      this.uSERTYPE,
      this.sESSIONID,
      this.sUPERMERCHANT_FLAG,
      this.sUPERMERCHANT_PAY_ID});

  Loginauthresponse.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    bUSINESSNAME = json['BUSINESS_NAME'];
    uSERTYPE = json['USER_TYPE'];
    sESSIONID = json['SESSION_ID'];
    sUPERMERCHANT_FLAG = json['SUPERMERCHANT_FLAG'];
    sUPERMERCHANT_PAY_ID = json['SUPERMERCHANT_PAY_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['BUSINESS_NAME'] = this.bUSINESSNAME;
    data['USER_TYPE'] = this.uSERTYPE;
    data['SESSION_ID'] = this.sESSIONID;
    data['SUPERMERCHANT_FLAG'] = this.sUPERMERCHANT_FLAG;
    data['SUPERMERCHANT_PAY_ID'] = this.sUPERMERCHANT_PAY_ID;
    return data;
  }
}
