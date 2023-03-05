import 'package:flutter/material.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/strings.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:velocity_x/velocity_x.dart';

class termView extends StatefulWidget {
  const termView({super.key});

  @override
  State<termView> createState() => _termViewState();
}

class _termViewState extends State<termView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: termAndCondition.text.make(),
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
        //display term and condition pdf
        termAndConditionpath,
        key: _pdfViewerKey,
      ),
    );
  }
}
