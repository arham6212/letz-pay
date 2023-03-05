class Transsummaryresponse {
  String? tRANSACTIONAMOUNT;
  String? rESPONSECODE;
  String? aDMINSUPPORTPHONE;
  String? rESPONSEMESSAGE;
  String? bUSINESSNAME;
  String? uSERTYPE;
  String? aDMINSUPPORTEMAIL;
  String? lOGO;
  String? tRANSACTIONCOUNT;

  Transsummaryresponse(
      {this.tRANSACTIONAMOUNT,
      this.rESPONSECODE,
      this.aDMINSUPPORTPHONE,
      this.rESPONSEMESSAGE,
      this.bUSINESSNAME,
      this.uSERTYPE,
      this.aDMINSUPPORTEMAIL,
      this.lOGO,
      this.tRANSACTIONCOUNT});

  Transsummaryresponse.fromJson(Map<String, dynamic> json) {
    tRANSACTIONAMOUNT = json['TRANSACTION_AMOUNT'];
    rESPONSECODE = json['RESPONSE_CODE'];
    aDMINSUPPORTPHONE = json['ADMIN_SUPPORT_PHONE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    bUSINESSNAME = json['BUSINESS_NAME'];
    uSERTYPE = json['USER_TYPE'];
    aDMINSUPPORTEMAIL = json['ADMIN_SUPPORT_EMAIL'];
    lOGO = json['LOGO'];
    tRANSACTIONCOUNT = json['TRANSACTION_COUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TRANSACTION_AMOUNT'] = this.tRANSACTIONAMOUNT;
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['ADMIN_SUPPORT_PHONE'] = this.aDMINSUPPORTPHONE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['BUSINESS_NAME'] = this.bUSINESSNAME;
    data['USER_TYPE'] = this.uSERTYPE;
    data['ADMIN_SUPPORT_EMAIL'] = this.aDMINSUPPORTEMAIL;
    data['LOGO'] = this.lOGO;
    data['TRANSACTION_COUNT'] = this.tRANSACTIONCOUNT;
    return data;
  }
}
