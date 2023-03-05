import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_functions/common_regex.dart';

class InvoiceSearch extends StatefulWidget {
  const InvoiceSearch({Key? key}) : super(key: key);

  @override
  State<InvoiceSearch> createState() => _InvoiceSearchState();
}

class _InvoiceSearchState extends State<InvoiceSearch> {
  late GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  late String _mobileNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: white),
              onPressed: () => {
                    Navigator.of(context)
                        .pushNamed('/fhome'), //redirect to home screen.
                  }),
          title: Text("Invoice Search", style: TextStyle(color: white))),
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: 25),
                //       child: mobiletittle.text.size(18).make(),
                //     ),
                //     mandatory.text.color(red).make(),
                //   ],
                // ),
                customtextfeild(
                  Controller: mobileController,
                  labelText: mobileTittle,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[0-9]"),
                    )
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return cantbeempty;
                    String mobile = mobileController.text.trim();
                    if (mobile.isEmpty) {
                      return enterMobile;
                    } else if (mobile.length < 10) {
                      return enterMobileProp;
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String value) {
                    _mobileNumber = value;
                  },
                ),
                VSpace(10),
                // Row(
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: 25, right: 20),
                //       child: emailtittle.text.size(18).make(),
                //     ),
                //     mandatory.text.color(red).make(),
                //   ],
                // ),
                customtextfeild(
                  // key: emailKey,
                  labelText: emailTittle,
                  Controller: emailController,
                  keyboardType: TextInputType.emailAddress,

                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return emailblank;
                    } else if (isEmailValid(value!)) {
                      return null;
                    } else {
                      return emailAddressError;
                    }
                  },
                ),
                VSpace(10),
                // Row(
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: 25, right: 20),
                //       child: invoicetittle.text.size(18).make(),
                //     ),
                //     mandatory.text.color(red).make(),
                //   ],
                // ),
                customtextfeild(
                    Controller: invoiceController, labelText: invoiceTittle),
                VSpace(20),
                formbutton(
                  context: context,
                  searchButton,
                  onpressed: () {
                    setState(() {
                      final formstate = _formKey.currentState;
                      if (formstate!.validate()) {
                        formstate.save();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
