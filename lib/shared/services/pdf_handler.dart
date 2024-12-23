import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PdfFileHandler {
  static Future<void> savePdf(
      BuildContext context, Uint8List pdfBytes, String fileName) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showErrorSnackBar(
            context, 'Storage permission is required to save the PDF');
        return;
      }

      // Get the downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        _showErrorSnackBar(context, 'Could not access storage directory');
        return;
      }

      // Create the file
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      _showSuccessSnackBar(context, 'PDF saved successfully to ${file.path}');
    } catch (e) {
      _showErrorSnackBar(context, 'Error saving PDF: $e');
    }
  }

  static Future<void> sharePdf(
      BuildContext context, Uint8List pdfBytes, String fileName) async {
    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');

      // Write PDF to temporary file
      await file.writeAsBytes(pdfBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Sharing Quotation PDF',
        subject: fileName,
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Error sharing PDF: $e');
    }
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
