class ResponseRequestOption {
  String? pAYMENTOPTIONS;

  ResponseRequestOption({this.pAYMENTOPTIONS});

  ResponseRequestOption.fromJson(Map<String, dynamic> json) {
    pAYMENTOPTIONS = json['PAYMENT_OPTIONS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYMENT_OPTIONS'] = this.pAYMENTOPTIONS;
    return data;
  }
}

class PaymentOptionData {
  late String pAYMENTOPTIONS;

  PaymentOptionData({required this.pAYMENTOPTIONS});

  String toJson() {
    final String data;
    data = this.pAYMENTOPTIONS;
    return data;
  }
}
