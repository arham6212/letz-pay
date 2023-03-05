import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/module/homepage/home_page/homescreen.dart';
import 'package:intl/intl.dart';
import 'package:letzpay/module/invoicepage/Search%20_invoice_module/searchmodel.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';

import 'package:velocity_x/velocity_x.dart';

class SearchTranscation extends StatefulWidget {
  const SearchTranscation({Key? key}) : super(key: key);

  @override
  State<SearchTranscation> createState() => _SearchTranscationState();
}

class _SearchTranscationState extends State<SearchTranscation> {
  late List<SearchModel> users;
  late SearchModel selectedUser = SearchModel("1", "All");
  late List<SearchModel> status;
  late SearchModel selectedStatus = SearchModel("1", "All");
  late List<SearchModel> transsit;
  late SearchModel selectedTranssit = SearchModel("1", "EPOS");

  TextEditingController dateinput =
      TextEditingController(); //text editing controller for text field(date from)
  TextEditingController dateinputto = TextEditingController();
  String currentDate = DateFormat('dd-MMM-yy').format(DateTime.now());

  setSelectedUser(SearchModel user) {
    setState(() {
      selectedUser = user;
    });
  }

  setSelectedStatus(SearchModel statuss) {
    setState(() {
      selectedStatus = statuss;
    });
  }

  setSelectedTranssit(SearchModel transsits) {
    setState(() {
      selectedTranssit = transsits;
    });
  }

  @override
  void initState() {
    users = SearchModel.paymentlist();
    status = SearchModel.statuslist();
    transsit = SearchModel.transactionlist();
    dateinput.text =
        currentDate; //set the initial value of text field(date from)

    dateinputto.text =
        currentDate; //set the initial value of text field(date to)

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () => {
                  Navigator.of(context)
                      .pushReplacementNamed('/fhome'), //redirect to home screen
                }),
        title: searchTranscationTittle.text.color(white).make(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, right: 20),
                child: paymentType.text.size(15).make(),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(left: 25, right: 20),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (() {
                    setState(
                      () {
                        RadioDailoug();
                      },
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        selectedUser.name.text.make(),
                        Icon(
                          Icons.arrow_drop_down_circle,
                          size: 30,
                          color: Vx.hexToColor(darkblue),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              VSpace(5),
// statuslist feild
              Padding(
                padding: EdgeInsets.only(left: 25, right: 20),
                child: statusMode.text.size(15).make(),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(left: 25, right: 20),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (() {
                    setState(
                      () {
                        RadioDailougstatus();
                      },
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        selectedStatus.name.text.make(),
                        Icon(
                          Icons.arrow_drop_down_circle,
                          size: 30,
                          color: Vx.hexToColor(darkblue),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              VSpace(5),
//transactionlist feild
              Padding(
                padding: EdgeInsets.only(left: 25, right: 20),
                child: transMode.text.size(15).make(),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(left: 25, right: 20),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (() {
                    setState(
                      () {
                        RadioDailougtransaction();
                      },
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        selectedTranssit.name.text.make(),
                        Icon(
                          Icons.arrow_drop_down_circle,
                          size: 30,
                          color: Vx.hexToColor(darkblue),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              VSpace(5),
//date form

              Padding(
                padding: EdgeInsets.only(left: 25, right: 20),
                child: dateForm.text.size(15).make(),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(left: 25, right: 20),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (() {
                    setState(
                      () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('dd-MMM-yy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          showPopUpDialog(
                              errorpop, errorDateNotSelected, context);
                          //  showToastMsg("Date is not selected");
                        }
                      },
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        dateinput.text.text.make(),
                        Icon(
                          Icons.calendar_month,
                          size: 30,
                          color: Vx.hexToColor(darkblue),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              VSpace(5),
//date to
              Padding(
                padding: EdgeInsets.only(left: 25, right: 20),
                child: dateTo.text.size(15).make(),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(left: 25, right: 20),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (() {
                    setState(
                      () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('dd-MMM-yy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinputto.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          // showToastMsg("Date is not selected");
                        }
                      },
                    );
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        dateinputto.text.text.make(),
                        Icon(
                          Icons.calendar_month,
                          size: 30,
                          color: Vx.hexToColor(darkblue),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              VSpace(20),
              formbutton(
                context: context,
                searchButton,
                onpressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//paymentlist radio
  RadioDailoug() {
    // SearchModel searchModel = users[0];

    // selectedUser = SearchModel("", "");
    List<Widget> widgets = [];
    for (SearchModel user in users) {
      widgets.add(
        RadioListTile(
          value: user,
          groupValue: selectedUser,
          //title: Text(user.id),
          title: Text(user.name),
          onChanged: (SearchModel? currentUser) {
            //  print("Current User ${currentUser?.name}");
            // showToastMsg("Selected ${currentUser?.name}");
            setSelectedUser(currentUser!);
            Navigator.pop(context);
            // RadioDailoug();
          },
          selected: selectedUser == user,
          activeColor: primaryBlueColor,
        ),
      );
    }
    //   return widgets;
    // }

    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min, children: widgets))));
  }

  //statuslist radio
  RadioDailougstatus() {
    // SearchModel searchModel = users[0];

    // selectedUser = SearchModel("", "");
    List<Widget> widgetsS = [];
    for (SearchModel statuss in status) {
      widgetsS.add(
        RadioListTile(
          value: statuss,
          groupValue: selectedStatus,
          //title: Text(user.id),
          title: Text(statuss.name),
          onChanged: (SearchModel? currentUser) {
            //  print("Current User ${currentUser?.name}");
            // showToastMsg("Selected ${currentUser?.name}");
            setSelectedStatus(currentUser!);
            Navigator.pop(context);
            // RadioDailougstatus();
          },
          selected: selectedStatus == statuss,
          activeColor: primaryBlueColor,
        ),
      );
    }
    //   return widgets;
    // }

    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min, children: widgetsS))));
  }

//transactionlist radio
  RadioDailougtransaction() {
    // SearchModel searchModel = users[0];

    // selectedUser = SearchModel("", "");
    List<Widget> widgetsT = [];
    for (SearchModel transsits in transsit) {
      widgetsT.add(
        RadioListTile(
          value: transsits,
          groupValue: selectedTranssit,
          //title: Text(user.id),
          title: Text(transsits.name),
          onChanged: (SearchModel? currentUser) {
            //  print("Current User ${currentUser?.name}");
            // showToastMsg("Selected ${currentUser?.name}");
            setSelectedTranssit(currentUser!);
            Navigator.pop(context);
            // RadioDailougtransaction();
          },
          selected: selectedTranssit == transsits,
          activeColor: primaryBlueColor,
        ),
      );
    }
    //   return widgets;
    // }

    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min, children: widgetsT))));
  }
}
