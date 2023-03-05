class TransactionDetailResponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? tRANSACTIONDETAILS;

  TransactionDetailResponse(
      {this.rESPONSECODE, this.rESPONSEMESSAGE, this.tRANSACTIONDETAILS});

  TransactionDetailResponse.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    tRANSACTIONDETAILS = json['TRANSACTION_DETAILS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['TRANSACTION_DETAILS'] = this.tRANSACTIONDETAILS;
    return data;
  }
}

class TransactionDetail {
  String? ePOSPAYMENTOPTION;
  String? bUSINESSNAME;
  String? mOPTYPE;
  String? rEMARKS;
  String? tXNTYPE;
  String? eXPIRYDATE;
  String? iNVOICEID;
  String? sTATUS;
  String? cREATEDATE;
  String? cUSTMOBILE;
  String? aMOUNT;
  String? tRANSACTIONMODE;
  String? cUSTEMAIL;
  String? tOTALAMOUNT;
  String? cUSTNAME;

  TransactionDetail(
      {this.ePOSPAYMENTOPTION,
      this.bUSINESSNAME,
      this.mOPTYPE,
      this.rEMARKS,
      this.tXNTYPE,
      this.eXPIRYDATE,
      this.iNVOICEID,
      this.sTATUS,
      this.cREATEDATE,
      this.cUSTMOBILE,
      this.aMOUNT,
      this.tRANSACTIONMODE,
      this.cUSTEMAIL,
      this.tOTALAMOUNT,
      this.cUSTNAME});

  TransactionDetail.fromJson(Map<String, dynamic> json) {
    ePOSPAYMENTOPTION = json['EPOS_PAYMENT_OPTION'];
    bUSINESSNAME = json['BUSINESS_NAME'];
    mOPTYPE = json['MOP_TYPE'];
    rEMARKS = json['REMARKS'];
    tXNTYPE = json['TXNTYPE'];
    eXPIRYDATE = json['EXPIRY_DATE'];
    iNVOICEID = json['INVOICE_ID'];
    sTATUS = json['STATUS'];
    cREATEDATE = json['CREATE_DATE'];
    cUSTMOBILE = json['CUST_MOBILE'];
    aMOUNT = json['AMOUNT'];
    tRANSACTIONMODE = json['TRANSACTION_MODE'];
    cUSTEMAIL = json['CUST_EMAIL'];
    tOTALAMOUNT = json['TOTAL_AMOUNT'];
    cUSTNAME = json['CUST_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EPOS_PAYMENT_OPTION'] = this.ePOSPAYMENTOPTION;
    data['BUSINESS_NAME'] = this.bUSINESSNAME;
    data['MOP_TYPE'] = this.mOPTYPE;
    data['REMARKS'] = this.rEMARKS;
    data['TXNTYPE'] = this.tXNTYPE;
    data['EXPIRY_DATE'] = this.eXPIRYDATE;
    data['INVOICE_ID'] = this.iNVOICEID;
    data['STATUS'] = this.sTATUS;
    data['CREATE_DATE'] = this.cREATEDATE;
    data['CUST_MOBILE'] = this.cUSTMOBILE;
    data['AMOUNT'] = this.aMOUNT;
    data['TRANSACTION_MODE'] = this.tRANSACTIONMODE;
    data['CUST_EMAIL'] = this.cUSTEMAIL;
    data['TOTAL_AMOUNT'] = this.tOTALAMOUNT;
    data['CUST_NAME'] = this.cUSTNAME;
    return data;
  }
}

// class InvoiceId {
//   late String iNVOICEID;

//   InvoiceId({required this.iNVOICEID});

//   String toJson() {
//     final String data;
//     data = this.iNVOICEID;
//     return data;
//   }
// }
