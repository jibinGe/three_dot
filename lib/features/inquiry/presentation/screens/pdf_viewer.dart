import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/shared/services/pdf_handler.dart';

class QuotationPdfViewer extends StatelessWidget {
  final InquiryModel inquiry;
  final Uint8List pdfBytes;

  const QuotationPdfViewer({
    Key? key,
    required this.inquiry,
    required this.pdfBytes,
  }) : super(key: key);

  String _getFileName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'Quotation_${inquiry.inquiryNumber}_$timestamp.pdf';
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _getFileName();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => PdfFileHandler.savePdf(
              context,
              pdfBytes,
              fileName,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => PdfFileHandler.sharePdf(
              context,
              pdfBytes,
              fileName,
            ),
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => pdfBytes,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        useActions: false,
      ),
    );
  }
}
