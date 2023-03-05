class Transactionsummaryrequest {
  String? mOBILENUMBER;
  String? lOGINTYPE;
  String? pIN;

  Transactionsummaryrequest({this.mOBILENUMBER, this.lOGINTYPE, this.pIN});

  Transactionsummaryrequest.fromJson(Map<String, dynamic> json) {
    mOBILENUMBER = json['MOBILE_NUMBER'];
    lOGINTYPE = json['LOGIN_TYPE'];
    pIN = json['PIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MOBILE_NUMBER'] = this.mOBILENUMBER;
    data['LOGIN_TYPE'] = this.lOGINTYPE;
    data['PIN'] = this.pIN;
    return data;
  }
}
