class ReportModel {
 
  final String id;
  final String name;



  ReportModel(this.id, this.name);


   static List<ReportModel> paymentlist() {
    return <ReportModel>[
      ReportModel(
        "1",
        "Sale Captured",
      ),
       ReportModel(
        "2",
        "Sale Settled",
      ),
       ReportModel(
        "3",
        "Refund Capture",
      ),];}
  
  }