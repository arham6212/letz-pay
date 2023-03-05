import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/module/homepage/home_page/homescreen.dart';

import 'package:letzpay/utils/colors.dart';

import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_components/common_widget.dart';
import '../../drawer/drawer.dart';
import '../../history/transaction_history_new/transaction_history_new.dart';
import '../../analytics/report_chart_page/salescapture.dart';
import '../../invoicepage/search_model/invoice_detail.dart';

class FHomePage extends StatefulWidget {
  const FHomePage({Key? key}) : super(key: key);

  @override
  State<FHomePage> createState() => _FHomePageState();
}

class _FHomePageState extends State<FHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  PageController controller = PageController(initialPage: 0);

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), //called when click on Home tab
    TransactionHistoryNew(), //called when click on history tab
    SaleCapture(), //called when click on analytics tab
    InvoiceDetails() //called when click on search tab
  ];

  @override
  void initState() {
    super.initState();
  }

  //back press from system show exit dialog
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      _onItemTapped(0);
      return false;
    } else {
      return showPopUpDialogExit(rYouSureLbl, wantExitLbl, context);
    }
    // false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, //handle system back press
      child: Scaffold(
        //  appBar: buildHomeAppBar('Welcome Niraj sexena ',),
        // drawer: DrawerList(
        //   scaffoldKey: _scaffoldKey,
        // ),

        //will confirm  from letzpay team
        /* bottomNavigationBar: 
        FlashyTabBar(
          
          animationCurve: Curves.easeInOutQuad,
          backgroundColor: Colors.white,
          selectedIndex: _selectedIndex,
          animationDuration: Duration(milliseconds: 900),
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            controller.jumpToPage(_selectedIndex);
          }),
          items: [
            FlashyTabBarItem(
              activeColor: Colors.black,
              inactiveColor: lightBlackColor,
              icon: Icon(
                Icons.home_outlined,
                size: 20,
              ),
              title: Text(homeTab,
                  style: fontStyleSmallBottomTab(fontWeight: FontWeight.bold)),
            ),
            FlashyTabBarItem(
              activeColor: Colors.black,
              inactiveColor: lightBlackColor,
              icon: Icon(
                Icons.history_outlined,
                size: 20,
              ),
              title: Text(historyTab,
                  style: fontStyleSmallBottomTab(fontWeight: FontWeight.bold)),
            ),
            FlashyTabBarItem(
              activeColor: Colors.black,
              inactiveColor: lightBlackColor,
              icon: Icon(
                Icons.graphic_eq_sharp,
                size: 20,
              ),
              title: Text(
                analysticsTab,
                style: fontStyleSmallBottomTab(fontWeight: FontWeight.bold),
              ),
            ),
            FlashyTabBarItem(
              activeColor: Colors.black,
              inactiveColor: lightBlackColor,
              icon: Icon(
                Icons.receipt_long,
                size: 20,
              ),
              title: Text(
                searchButton,
                style: fontStyleSmallBottomTab(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ), */

        //bottom navigation tab of home,history,analytics and ssearch
        bottomNavigationBar: BottomNavigationBar(
          // showSelectedLabels: false, // <-- HERE
          // showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16.sp,

          selectedIconTheme: IconThemeData(color: Colors.black),
          // selectedItemColor: Colors.amberAccent,

          backgroundColor: Colors.white,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.home,
                  color: Color.fromRGBO(0, 0, 0, 1),
                  // size: 13,
                ),
                icon: Icon(
                  Icons.home,
                  color: lightBlackColor,
                ),
                label: homeTab,
                backgroundColor: black),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.article_outlined,
                  color: Colors.black,
                ),
                icon: Icon(
                  Icons.article,
                  color: lightBlackColor,
                ),
                label: historyTab),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.graphic_eq_sharp,
                  color: Colors.black,
                ),
                icon: Icon(Icons.graphic_eq_sharp, color: lightBlackColor),
                label: analysticsTab),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.receipt_long,
                  color: Colors.black,
                ),
                icon: Icon(Icons.receipt_long, color: lightBlackColor),
                label: searchButton),
          ],
          // type: BottomNavigationBarType.fixed,
          //  selectedFontSize: 20,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: lightBlackColor,
          onTap: _onItemTapped,
        ),

        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),

        // body: PageView(
        //   scrollDirection: Axis.horizontal,

        //   // reverse: true,
        //   // physics: BouncingScrollPhysics(),
        //   controller: controller,
        //   onPageChanged: (num) {
        //     setState(() {
        //       _selectedIndex = num;
        //     });
        //     // _onItemTapped(num);
        //   },
        //   children: _widgetOptions,
        // ),
      ),
    );
  }

  //according to click on bottom tab option function called
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // controller.jumpToPage(_selectedIndex);
    });
  }
}
