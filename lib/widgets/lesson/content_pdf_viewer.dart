import 'package:flutter/material.dart';
import 'dart:io';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class ContentPdfViewer extends StatefulWidget {
  final LessonContent lessonContent;
  final Size screenSize;
  final bool isHorizontal;
  final String pdfStorageUrl;

  ContentPdfViewer({
    @required this.lessonContent,
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.pdfStorageUrl,
  });

  @override
  _ContentPdfViewerState createState() => _ContentPdfViewerState();
}

class _ContentPdfViewerState extends State<ContentPdfViewer> {
  String _localPdfPath = "";
  bool _isLoading = true;
  PdfController _pdfController;
  int _pageCount = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  void initialise() async {
    _localPdfPath = await _getLocalFileName();
    debugPrint("INIT LOCALFILEPATH = $_localPdfPath");
    //try to delete the file if it already exists, may have viewed before, but file could have changed in backend
    await _deleteFile();
    //now get the file using the url and save in the local file path
    await _saveFileFromUrl();

    _pdfController = PdfController(
      document: PdfDocument.openFile(_localPdfPath),
      initialPage: 1,
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _getLocalFileName() async {
    var dir = await getApplicationDocumentsDirectory();
    final String localPdfPath = "${dir.path}/${widget.lessonContent.mediaUrl}";
    return localPdfPath;
  }

  Future<void> _saveFileFromUrl() async {
    var fileUrl = '${widget.pdfStorageUrl}${widget.lessonContent.mediaUrl}';
    try {
      //get the file from the URL
      var data = await http.get(fileUrl);
      var bytes = data.bodyBytes;
      File file = File(_localPdfPath);
      await file.writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception("Error opening pdf file");
    }
  }

  Future<bool> _deleteFile() async {
    try {
      final File file = File(_localPdfPath);
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: PcosLoadingSpinner())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: widget.screenSize.width,
                height: DeviceUtils.getRemainingHeight(widget.screenSize.height,
                        false, widget.isHorizontal, false, false) -
                    100,
                child: PdfView(
                  documentLoader: Center(child: PcosLoadingSpinner()),
                  pageLoader: Center(child: PcosLoadingSpinner()),
                  controller: _pdfController,
                  onDocumentLoaded: (document) {
                    setState(() {
                      _pageCount = document.pagesCount;
                    });
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                ),
              ),
              Center(
                child: Text("Page $_currentPage of $_pageCount"),
              ),
            ],
          );
  }
}
