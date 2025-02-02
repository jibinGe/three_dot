import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class PdfFileHandler {
  static Future<void> savePdf(
      BuildContext context, Uint8List pdfBytes, String fileName) async {
    try {
      if (kIsWeb) {
        // Web platform handling
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download = fileName;
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
        _showSuccessSnackBar(context, 'PDF downloaded successfully');
        return;
      }

      // Mobile platform handling
      if (Platform.isAndroid) {
        // Request storage permission on Android
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          _showErrorSnackBar(
              context, 'Storage permission is required to save the PDF');
          return;
        }

        // Try to use Download directory first
        Directory? directory;
        try {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } catch (e) {
          directory = await getExternalStorageDirectory();
        }

        if (directory == null) {
          _showErrorSnackBar(context, 'Could not access storage directory');
          return;
        }

        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        _showSuccessSnackBar(
            context, 'PDF saved successfully to Downloads folder');
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        _showSuccessSnackBar(
            context, 'PDF saved successfully to Documents folder');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Error saving PDF: $e');
    }
  }

  static Future<void> sharePdf(
      BuildContext context, Uint8List pdfBytes, String fileName) async {
    try {
      if (kIsWeb) {
        // Web platform sharing
        _showErrorSnackBar(
            context, 'Direct sharing is not supported on web platform');
        return;
      }

      // Mobile platform sharing
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');

      // Write PDF to temporary file
      await file.writeAsBytes(pdfBytes);

      // Share the file
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Sharing PDF',
        subject: fileName,
      );

      // Clean up temporary file
      if (await file.exists()) {
        await file.delete();
      }

      if (result.status == ShareResultStatus.success) {
        _showSuccessSnackBar(context, 'PDF shared successfully');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Error sharing PDF: $e');
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // static void _showSuccessSnackBar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.green,
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  // static void _showErrorSnackBar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }
}
