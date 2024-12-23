// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:intl/intl.dart';
// import 'package:printing/printing.dart';
// import 'package:share_plus/share_plus.dart';

// class SolarQuotationPDF {
//   Future<void> generateAndShareQuotation({
//     required String customerName,
//     required String address,
//     required String mobile,
//     required String refNumber,
//     required DateTime date,
//     required double totalAmount,
//     required double subsidyAmount,
//   }) async {
//     try {
//       // Generate the PDF file
//       final File pdfFile = await generateQuotation(
//         customerName: customerName,
//         address: address,
//         mobile: mobile,
//         refNumber: refNumber,
//         date: date,
//         totalAmount: totalAmount,
//         subsidyAmount: subsidyAmount,
//       );

//       // Generate a meaningful filename
//       final String fileName =
//           'Solar_Quotation_${customerName.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(date)}.pdf';

//       // Create a new file with the proper name
//       final Directory tempDir = await getTemporaryDirectory();
//       final String filePath = '${tempDir.path}/$fileName';
//       final File namedFile = await pdfFile.copy(filePath);

//       // Share the PDF file
//       await Share.shareXFiles(
//         [XFile(namedFile.path)],
//         subject: 'Solar Power System Quotation',
//         text: 'Please find attached the quotation for your solar power system.',
//       );
//     } catch (e) {
//       throw Exception('Failed to share PDF: $e');
//     }
//   }

//   Future<File> generateQuotation({
//     required String customerName,
//     required String address,
//     required String mobile,
//     required String refNumber,
//     required DateTime date,
//     required double totalAmount,
//     required double subsidyAmount,
//   }) async {
//     final pdf = pw.Document();

//     // Define base styles using standard fonts
//     final baseStyle = pw.TextStyle(
//       fontSize: 11,
//       font: await PdfGoogleFonts.courierPrimeRegular(),
//     );

//     final boldStyle = pw.TextStyle(
//       fontSize: 11,
//       font: await PdfGoogleFonts.courierPrimeBold(),
//     );

//     // Create PDF content
//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(32),
//         build: (pw.Context context) {
//           return [
//             _buildHeader(refNumber, date, baseStyle),
//             _buildCustomerInfo(customerName, address, mobile, baseStyle),
//             _buildSubject(boldStyle),
//             _buildIntroduction(baseStyle),
//             _buildCompanyInfo(baseStyle),
//             _buildProductsServices(baseStyle, boldStyle),
//             _buildSpecifications(baseStyle, boldStyle),
//             _buildPricing(totalAmount, subsidyAmount, baseStyle, boldStyle),
//             _buildPaymentTerms(baseStyle, boldStyle),
//             _buildWarranty(baseStyle, boldStyle),
//             _buildFooter(baseStyle, boldStyle),
//           ];
//         },
//       ),
//     );

//     // Save the PDF
//     final output = await getTemporaryDirectory();
//     final file = File('${output.path}/solar_quotation.pdf');
//     await file.writeAsBytes(await pdf.save());
//     return file;
//   }

//   pw.Widget _buildHeader(String refNumber, DateTime date, pw.TextStyle style) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Ref: $refNumber', style: style),
//         pw.Text('Date: ${DateFormat('dd.MM.yyyy').format(date)}', style: style),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildCustomerInfo(
//       String name, String address, String mobile, pw.TextStyle style) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(name, style: style),
//         pw.Text(address, style: style),
//         pw.Text('Mobile: $mobile', style: style),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildSubject(pw.TextStyle style) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Sub: PROPOSAL FOR 3 KW SOLAR GRID TIE SYSTEMS WITH 3 KW STRING INVERTER',
//           style: style,
//         ),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildIntroduction(pw.TextStyle style) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Thank you so very much for the courtesy extended to us during our discussion with you and showing interest in exploring solar power solutions from us.',
//           style: style,
//         ),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildCompanyInfo(pw.TextStyle style) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           '3-DOT Energy solutions- a division of Rightimage Consultants Pvt Ltd -Thrissur, is managed by a group of professionals and businessmen with decades of experience in their respective fields is focused to provide cost effective energy solutions to its customers.',
//           style: style,
//         ),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildProductsServices(
//       pw.TextStyle baseStyle, pw.TextStyle boldStyle) {
//     final products = [
//       'Solar power plants- On grid and Off grid',
//       'Solar Panels',
//       'Solar Inverters',
//       'Solar Batteries',
//       'Solar Lightings',
//       'Solar Water Heaters',
//       'Solar Pump sets(BLDC)',
//       'Energy efficient ceiling fans (BLDC)',
//     ];

//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Our products and services:', style: boldStyle),
//         pw.SizedBox(height: 10),
//         ...products.map((product) => pw.Padding(
//               padding: const pw.EdgeInsets.only(left: 20, bottom: 5),
//               child: pw.Row(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text('*',
//                       style:
//                           baseStyle), // Using asterisk instead of Unicode arrow
//                   pw.SizedBox(width: 5),
//                   pw.Expanded(child: pw.Text(product, style: baseStyle)),
//                 ],
//               ),
//             )),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildSpecifications(
//       pw.TextStyle baseStyle, pw.TextStyle boldStyle) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Products specifications:', style: boldStyle),
//         pw.SizedBox(height: 10),
//         _buildSpecificationTable(baseStyle),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildSpecificationTable(pw.TextStyle style) {
//     return pw.Table(
//       border: pw.TableBorder.all(),
//       children: [
//         pw.TableRow(
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Text('Solar PV Module', style: style),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Text('RAYZON/ADANI 540/550 Wp', style: style),
//             ),
//           ],
//         ),
//         pw.TableRow(
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Text('Inverter', style: style),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Text('MICROTEK/SOFAR 3KW', style: style),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   pw.Widget _buildPricing(double totalAmount, double subsidyAmount,
//       pw.TextStyle baseStyle, pw.TextStyle boldStyle) {
//     final currencyFormat = NumberFormat.currency(
//       symbol: 'Rs. ',
//       locale: 'en_IN',
//       decimalDigits: 2,
//     );

//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Pricing Details:', style: boldStyle),
//         pw.SizedBox(height: 10),
//         pw.Table(
//           border: pw.TableBorder.all(),
//           children: [
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text('Total Amount', style: baseStyle),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text(
//                     currencyFormat.format(totalAmount),
//                     style: baseStyle,
//                   ),
//                 ),
//               ],
//             ),
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text('Subsidy Amount', style: baseStyle),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text(
//                     currencyFormat.format(subsidyAmount),
//                     style: baseStyle,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildPaymentTerms(pw.TextStyle baseStyle, pw.TextStyle boldStyle) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Payment Schedule:', style: boldStyle),
//         pw.SizedBox(height: 10),
//         pw.Row(children: [
//           pw.Text('* ', style: baseStyle),
//           pw.Expanded(
//             child: pw.Text(
//               '50% against order, 40% material supply, & 10% after completion of work',
//               style: baseStyle,
//             ),
//           ),
//         ]),
//         pw.Row(children: [
//           pw.Text('* ', style: baseStyle),
//           pw.Expanded(
//             child: pw.Text(
//               'All payment to be made in favor of "Rightimage Consultants Pvt Ltd"',
//               style: baseStyle,
//             ),
//           ),
//         ]),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildWarranty(pw.TextStyle baseStyle, pw.TextStyle boldStyle) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Warranty:', style: boldStyle),
//         pw.SizedBox(height: 10),
//         pw.Text(
//           'Performance warranty of Solar PV modules are 25 years & Solar Inverter for 10 years.',
//           style: baseStyle,
//         ),
//         pw.SizedBox(height: 20),
//       ],
//     );
//   }

//   pw.Widget _buildFooter(pw.TextStyle baseStyle, pw.TextStyle boldStyle) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text('Sincerely,', style: baseStyle),
//         pw.SizedBox(height: 10),
//         pw.Text('GEORGE THOMAS', style: boldStyle),
//         pw.Text('Managing Director', style: baseStyle),
//       ],
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';

class QuotationPdfGenerator {
  final InquiryModel inquiry;

  QuotationPdfGenerator({required this.inquiry});

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    // Add pages
    pdf.addPage(await _generateFirstPage());
    pdf.addPage(await _generateSecondPage());
    pdf.addPage(await _generateThirdPage());
    pdf.addPage(await _generateFourthPage());

    return pdf.save();
  }

  Future<pw.Page> _generateFirstPage() async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(70),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // _buildHeader(),
            pw.SizedBox(height: 20),
            _buildCustomerDetails(),
            pw.SizedBox(height: 30),
            _buildIntroduction(),
            pw.SizedBox(height: 20),
            _buildProductsAndServices(),
          ],
        );
      },
    );
  }

  Future<pw.Page> _generateSecondPage() async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildSpecifications(),
            pw.SizedBox(height: 20),
            _buildMountingStructure(),
          ],
        );
      },
    );
  }

  Future<pw.Page> _generateThirdPage() async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // _buildCablingDetails(),
            pw.SizedBox(height: 20),
            _buildPricingDetails(),
            pw.SizedBox(height: 20),
            _buildPaymentSchedule(),
          ],
        );
      },
    );
  }

  Future<pw.Page> _generateFourthPage() async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildTermsAndConditions(),
            pw.SizedBox(height: 20),
            _buildWarranty(),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ],
        );
      },
    );
  }

  pw.Widget _buildCustomerDetails() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(inquiry.name,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              if (inquiry.address != null) pw.Text(inquiry.address!),
              if (inquiry.mobileNumber != null)
                pw.Text('Mobile: ${inquiry.mobileNumber}'),
              pw.SizedBox(height: 10),
              pw.Text(
                'Sub: PROPOSAL FOR ${inquiry.proposedCapacity} KW SOLAR GRID TIE SYSTEMS',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline),
              ),
            ],
          ),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Ref: ${inquiry.inquiryNumber}',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Date: ${_formatDate(inquiry.createdAt)}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ]);
  }

  pw.Widget _buildIntroduction() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Sir,\n\nThank you so very much for the courtesy extended to us during our discussion with you and showing interest in exploring solar power solutions from us.',
          style: pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          '3-DOT Energy solutions- a division of Rightimage Consultants  Pvt- ltd –Thrissur, is managed by a group of professionals and businessmen with decades of experience in their respective fields is focused to provide cost effective energy solutions to its customers. Established in 1990 as a manufacturer of Inverters, SMPS and Automobile electronic products,  In the year 2010,  3DOT foray its business into renewable energy sector across the state of Kerala. We have successfully completed over 250 KW solar projects of various capacities for institutions and households. Our client base stands at 150 plus. We are an experienced green energy solutions provider capable of understanding client requirements and provide suitable cost effective solutions for the same. ',
          style: pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  pw.Widget _buildProductsAndServices() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Our products and services:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        _buildBulletList([
          'Solar power plants- On grid and Off grid',
          'Solar Panels',
          'Solar Inverters',
          'Solar Batteries',
          'Solar Lightings',
          'Solar Water Heaters',
          'Solar Pump sets(BLDC)',
          'Energy efficient ceiling fans (BLDC)',
        ]),
      ],
    );
  }

  pw.Widget _buildSpecifications() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Products specifications:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        _buildProductSpecificationTable(),
      ],
    );
  }

  pw.Widget _buildProductSpecificationTable() {
    final products = inquiry.selectedProducts ?? [];
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        // Header row
        pw.TableRow(
          children: [
            _buildTableCell('Product', isHeader: true),
            _buildTableCell('Specifications', isHeader: true),
          ],
        ),
        // Product rows
        ...products.map((product) {
          return pw.TableRow(
            children: [
              _buildTableCell(product.product?.name ?? ''),
              _buildTableCell(
                  _formatSpecifications(product.product?.specifications ?? {})),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildMountingStructure() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Solar Mounting Structure',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'The PV modules will be mounted on fixed metallic structures of adequate strength and appropriate design, which can withstand load of modules. The support structure used in the power plants will be high quality of materials',
          style: pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  pw.Widget _buildPricingDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Pricing Details',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('Particulars'),
                _buildTableCell('Price'),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell(
                    'Supply and Installation of ${inquiry.proposedCapacity} KW Ongrid Solar Power Plant'),
                _buildTableCell(
                  '₹ ${_formatCurrency(inquiry.proposedAmount ?? 0)}',
                  alignment: pw.Alignment.centerRight,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPaymentSchedule() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Payment Schedule:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(inquiry.paymentTerms ??
            '50% against order, 40% material supply, & 10% after completion of work'),
      ],
    );
  }

  pw.Widget _buildTermsAndConditions() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Terms & conditions:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        _buildBulletList([
          'Structure work included',
          'Any additional material/Structure requirement based on site condition at the time of installation will be charged extra.',
          'UG Cable will be extra as per requirement, if necessary',
          'Customer should provide shadow free area for mounting the solar panels.',
          'A space properly ventilated and protected from rain will be provided to install the inverter, switch board etc',
        ]),
      ],
    );
  }

  pw.Widget _buildWarranty() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Warranty:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Performance warranty of Solar PV modules are 25 years & Solar Inverter for 10 years.\n\n'
          'The warranty provided by us does not cover damages to the solar power plant/equipments, due to natural calamities like flood, heavy winds, lightning etc.',
          style: pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'We once again thank you for the opportunity given to represent ourselves and trust that our offer is in line with your requirements and looking forward to hearing from you.',
          style: pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Sincerely,\n\nManaging Director',
          style: pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  // Helper widgets and methods
  pw.Widget _buildTableCell(String text,
      {bool isHeader = false,
      pw.Alignment alignment = pw.Alignment.centerLeft}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(5),
      alignment: alignment,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildBulletList(List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.map((item) {
        return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: 2),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Icon(pw.IconData(0xf111), size: 5),
              pw.SizedBox(width: 5),
              pw.Expanded(child: pw.Text(item))
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  String _formatSpecifications(Map<String, dynamic> specs) {
    return specs.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
}
