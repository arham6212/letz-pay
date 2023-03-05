class SearchModel {
  // final String historyAssetPath;
  final String id;
  final String name;

  // static var paymentlist;

  SearchModel(this.id, this.name);

  static List<SearchModel> paymentlist() {
    return <SearchModel>[
      SearchModel(
        "1",
        "ALL",
      ),
      SearchModel(
        "2",
        "Credit/Debit Card",
      ),
      SearchModel(
        "3",
        "International",
      ),
      SearchModel(
        "4",
        "Net Banking",
      ),
      SearchModel(
        "5",
        "UPI",
      ),
      SearchModel(
         "6",
         "UPI QR",
      ),
      SearchModel(
       "7",
        "PG QR",
      ),
      SearchModel(
       "8",
         "EMI",
      ),
      SearchModel(
       "9",
         "Wallet",
      ),
      SearchModel(
       "10",
         "Cash on Delivery",
      ),
    ];
  }



  static List<SearchModel> statuslist() {
    return <SearchModel>[
  SearchModel(
      "1",
       "ALL",
    ),
    SearchModel(
     "2",
     "Success",
    ),
    SearchModel (
     "3",
     "Failed",
    ),
     SearchModel (
     "3",
     "Cancelled",
    ),
     SearchModel (
     "3",
     "pending",
    ),
    ];
   }

  static List<SearchModel> transactionlist()
   {
  return<SearchModel>[
  SearchModel(
      "1",
       "EPOS",
    ),
    SearchModel(
     "2",
     "Direct",
    ),
    SearchModel (
     "3",
     "All",
    ),

  ];
}
}
