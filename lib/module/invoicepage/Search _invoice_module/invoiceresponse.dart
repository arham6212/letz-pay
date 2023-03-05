class Invoiceresponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? iNVOICEDATA;

  Invoiceresponse({this.rESPONSECODE, this.rESPONSEMESSAGE, this.iNVOICEDATA});

  Invoiceresponse.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    iNVOICEDATA = json['INVOICE_DATA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['INVOICE_DATA'] = this.iNVOICEDATA;
    return data;
  }
}

class InvoceData {
  String? pAYMENTTYPE;
  String? iNVOICEID;
  String? sTATUS;
  String? cREATEDATE;
  String? cUSTMOBILE;
  String? aMOUNT;
  String? ePOSPAYMENTOPTION;
  String? rEMARKS;
  String? cUSTEMAIL;
  String? tXNTYPE;
  String? cUSTNAME;

  InvoceData(
      {this.pAYMENTTYPE,
      this.iNVOICEID,
      this.sTATUS,
      this.cREATEDATE,
      this.cUSTMOBILE,
      this.aMOUNT,
      this.ePOSPAYMENTOPTION,
      this.rEMARKS,
      this.cUSTEMAIL,
      this.tXNTYPE,
      this.cUSTNAME});

  InvoceData.fromJson(Map<String, dynamic> json) {
    pAYMENTTYPE = json['PAYMENT_TYPE'];
    iNVOICEID = json['INVOICE_ID'];
    sTATUS = json['STATUS'];
    cREATEDATE = json['CREATE_DATE'];
    cUSTMOBILE = json['CUST_MOBILE'];
    aMOUNT = json['AMOUNT'];
    ePOSPAYMENTOPTION = json['EPOS_PAYMENT_OPTION'];
    rEMARKS = json['REMARKS'];
    cUSTEMAIL = json['CUST_EMAIL'];
    tXNTYPE = json['TXNTYPE'];
    cUSTNAME = json['CUST_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYMENT_TYPE'] = this.pAYMENTTYPE;
    data['INVOICE_ID'] = this.iNVOICEID;
    data['STATUS'] = this.sTATUS;
    data['CREATE_DATE'] = this.cREATEDATE;
    data['CUST_MOBILE'] = this.cUSTMOBILE;
    data['AMOUNT'] = this.aMOUNT;
    data['EPOS_PAYMENT_OPTION'] = this.ePOSPAYMENTOPTION;
    data['REMARKS'] = this.rEMARKS;
    data['CUST_EMAIL'] = this.cUSTEMAIL;
    data['TXNTYPE'] = this.tXNTYPE;
    data['CUST_NAME'] = this.cUSTNAME;
    return data;
  }
}
