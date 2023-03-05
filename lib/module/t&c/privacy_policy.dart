import 'package:flutter/material.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/strings.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:velocity_x/velocity_x.dart';

class privacyPolicyView extends StatefulWidget {
  const privacyPolicyView({super.key});

  @override
  State<privacyPolicyView> createState() => _privacyPolicyViewState();
}

class _privacyPolicyViewState extends State<privacyPolicyView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: privacyPolicy.text.make(),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.bookmark,
        //       color: Colors.white,
        //      // semanticLabel: 'Bookmark',
        //     ),
        //     onPressed: () {
        //       _pdfViewerKey.currentState?.openBookmarkView();
        //     },
        //   ),
        // ],
      ),
      body: SfPdfViewer.asset(
        //display privacy policy pdf
        privacyPolicypath,
        key: _pdfViewerKey,
      ),
    );
  }
}
