import 'dart:convert';

class ResponseTransactionHistory {
  String? rESPONSECODE;
  String? rELOAD;
  String? tRANSACTIONDATA;
  String? rESPONSEMESSAGE;

  ResponseTransactionHistory(
      {this.rESPONSECODE,
      this.rELOAD,
      this.tRANSACTIONDATA,
      this.rESPONSEMESSAGE});

  ResponseTransactionHistory.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rELOAD = json['RELOAD'];
    tRANSACTIONDATA = json['TRANSACTION_DATA'];
    // tRANSACTIONDATA =
    //     tRANSACTIONDATA?.substring(1, (tRANSACTIONDATA?.length)! - 1);

    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RELOAD'] = this.rELOAD;
    data['TRANSACTION_DATA'] = this.tRANSACTIONDATA;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    return data;
  }
}

class TransactionData {
  String? pAYMENTTYPE;
  String? iNVOICEID;
  String? sTATUS;
  String? cREATEDATE;
  String? ePOSPAYMENTOPTION;
  String? aMOUNT;
  String? bUSINESSNAME;
  String? tXNTYPE;

  TransactionData(
      {this.pAYMENTTYPE,
      this.iNVOICEID,
      this.sTATUS,
      this.cREATEDATE,
      this.ePOSPAYMENTOPTION,
      this.aMOUNT,
      this.bUSINESSNAME,
      this.tXNTYPE});

  TransactionData.fromJson(Map<String, dynamic> json) {
    pAYMENTTYPE = json['PAYMENT_TYPE'];
    iNVOICEID = json['INVOICE_ID'];
    sTATUS = json['STATUS'];
    cREATEDATE = json['CREATE_DATE'];
    ePOSPAYMENTOPTION = json['EPOS_PAYMENT_OPTION'];
    aMOUNT = json['AMOUNT'];
    bUSINESSNAME = json['BUSINESS_NAME'];
    tXNTYPE = json['TXNTYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYMENT_TYPE'] = this.pAYMENTTYPE;
    data['INVOICE_ID'] = this.iNVOICEID;
    data['STATUS'] = this.sTATUS;
    data['CREATE_DATE'] = this.cREATEDATE;
    data['EPOS_PAYMENT_OPTION'] = this.ePOSPAYMENTOPTION;
    data['AMOUNT'] = this.aMOUNT;
    data['BUSINESS_NAME'] = this.bUSINESSNAME;
    data['TXNTYPE'] = this.tXNTYPE;
    return data;
  }
}
