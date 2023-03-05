class Loginauthrequest {
  String? mOBILENUMBER;
  String? lOGINTYPE;
  String? pIN;

  Loginauthrequest({this.mOBILENUMBER, this.lOGINTYPE, this.pIN});

  Loginauthrequest.fromJson(Map<String, dynamic> json) {
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
