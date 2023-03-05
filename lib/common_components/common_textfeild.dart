import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letzpay/utils/colors.dart';

class CustomFormField extends StatelessWidget {
  //final _text = TextEditingController();
  var _validate = false;

  CustomFormField({
    Key? key,
    required this.hintText,
    this.inputFormatters,
    this.validator,
    this.onchange,
    required Null Function(dynamic value) onChanged,
    required TextInputType keyboardType,
    required this.mController,
    String? errorText,
    required String helperText,
  }) : super(key: key);
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController mController;
  final onchange;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: greyColor, width: 1.0),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.only(left: 25, right: 20),
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        enableInteractiveSelection: true,
        autocorrect: false,
        enableSuggestions: false,
        onChanged: onchange,
        controller: mController,
        toolbarOptions: ToolbarOptions(
          copy: false,
          paste: false,
          cut: false,
          selectAll: false,
        ),

        inputFormatters: inputFormatters,
        // validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
