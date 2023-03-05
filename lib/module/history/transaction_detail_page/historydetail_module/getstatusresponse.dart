class Getstatusresponse {
  Null? pAYMENTTYPE;
  String? rESPONSECODE;
  String? sTATUS;
  String? rESPONSEMESSAGE;
  Null? mOPTYPE;
  String? tOTALAMOUNT;

  Getstatusresponse(
      {this.pAYMENTTYPE,
      this.rESPONSECODE,
      this.sTATUS,
      this.rESPONSEMESSAGE,
      this.mOPTYPE,
      this.tOTALAMOUNT});

  Getstatusresponse.fromJson(Map<String, dynamic> json) {
    pAYMENTTYPE = json['PAYMENT_TYPE'];
    rESPONSECODE = json['RESPONSE_CODE'];
    sTATUS = json['STATUS'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    mOPTYPE = json['MOP_TYPE'];
    tOTALAMOUNT = json['TOTAL_AMOUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYMENT_TYPE'] = this.pAYMENTTYPE;
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['STATUS'] = this.sTATUS;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['MOP_TYPE'] = this.mOPTYPE;
    data['TOTAL_AMOUNT'] = this.tOTALAMOUNT;
    return data;
  }
}
