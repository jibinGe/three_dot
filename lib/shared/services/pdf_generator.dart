import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';

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
      margin: const pw.EdgeInsets.all(70),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildSecondPageIntroduction(),
            pw.SizedBox(height: 15),
            _buildProductSpecifications(),
            pw.SizedBox(height: 15),
            _buildMountingStructure(),
          ],
        );
      },
    );
  }

  pw.Widget _buildProductSpecifications() {
    // Get all selected products that have specifications
    final products = inquiry.selectedProducts
            ?.where((p) => p.product?.specifications.isNotEmpty ?? false)
            .toList() ??
        [];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
            'Installation and commissioning of ${inquiry.proposedCapacity} KW Solar Grid Tie System with ${inquiry.proposedCapacity}  KW String Inverter',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
                decoration: pw.TextDecoration.underline)),
        pw.SizedBox(height: 10),
        pw.Text('Products specifications:',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
                decoration: pw.TextDecoration.underline)),
        pw.SizedBox(height: 10),
        ...products
            .map((selectedProduct) =>
                _buildProductSpecTable(selectedProduct.product!))
            .toList(),
      ],
    );
  }

  pw.Widget _buildProductSpecTable(Product product) {
    final specEntries = product.specifications.entries.toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 15),
        pw.Bullet(
            text: '${product.name} Specification',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
                decoration: pw.TextDecoration.underline)),
        // pw.Text('${product.name} Specification',
        //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            // Manufacturer row (common for all products)
            if (product.manufacturer.isNotEmpty)
              _buildSpecTableRow('Manufacturer', product.manufacturer, true),

            // Model row (common for all products)
            if (product.model.isNotEmpty)
              _buildSpecTableRow('Model', product.model, false),

            // Specification rows
            ...specEntries
                .map((entry) => _buildSpecTableRow(
                    entry.key, entry.value.toString(), false))
                .toList(),

            // // Quantity row (from SelectedProductModel)
            // _buildSpecTableRow('Quantity', selectedProduct.quantity.toString()),
          ],
        ),
      ],
    );
  }

  pw.TableRow _buildSpecTableRow(
      String parameter, String value, bool? isFirstRow) {
    return pw.TableRow(
      children: [
        _buildTableCell(parameter,
            isHeader: true, isFirst: isFirstRow ?? false),
        _buildTableCell(value, isFirst: isFirstRow ?? false),
      ],
    );
  }

  pw.Widget _buildSolarPanelSpecs() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Solar PV Module Specification',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('Manufacturer'),
                _buildTableCell('RAYZON/ADANI'),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell('Capacity'),
                _buildTableCell('540/550 Wp'),
              ],
            ),
            // Add all other rows similarly
          ],
        ),
      ],
    );
  }

  pw.Widget _buildInverterSpecs() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Solar Inverter Specification',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('Make'),
                _buildTableCell('MICROTEK/SOFAR'),
              ],
            ),
            // Add other inverter specs
          ],
        ),
      ],
    );
  }

  Future<pw.Page> _generateThirdPage() async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(70),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // _buildCablingDetails(),
            pw.SizedBox(height: 20),
            _buildCoperCabletable(),
            pw.SizedBox(height: 20),
            _buildScopOfWiring(),
            pw.SizedBox(height: 20),
            _buildPricingDetails(),
            pw.SizedBox(height: 20),
            _buildPaymentSchedule(),
          ],
        );
      },
    );
  }

  pw.Widget _buildCoperCabletable() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Copper Cables:',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline),
            textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('Parameter', isHeader: true),
                _buildTableCell('Specifications', isHeader: true),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell(
                  'Type',
                  alignment: pw.Alignment.centerLeft,
                ),
                _buildTableCell(
                  'PVC/XLPE/XLPO',
                  alignment: pw.Alignment.centerLeft,
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell(
                  'Material',
                  alignment: pw.Alignment.centerLeft,
                ),
                _buildTableCell(
                  'Copper  wire',
                  alignment: pw.Alignment.centerLeft,
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell(
                  'Make',
                  alignment: pw.Alignment.centerLeft,
                ),
                _buildTableCell(
                  'Polycab/microtek',
                  alignment: pw.Alignment.centerLeft,
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell(
                  'Working voltage',
                  alignment: pw.Alignment.centerLeft,
                ),
                _buildTableCell(
                  'Up to 1100 V',
                  alignment: pw.Alignment.centerLeft,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildScopOfWiring() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Scope of Wiring:-',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
        ),
        pw.SizedBox(height: 5),
        _buildBulletList([
          'Between Module to array junction box/Main junction box.',
          'Between AJB/MAJB/DC DB to Grid Inverter',
          'Grid Inverter to Ac DB',
          'Ac DB to LT Panel',
        ]),
        pw.SizedBox(height: 15),
        pw.Text(
          'Other Components',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
        ),
        pw.SizedBox(height: 5),
        _buildBulletList([
          'Solar Net meter,Energy meter, ACDB,DCDB,,Isolator',
          'UG Cable:- As per requirement, if necessary',
          'Lightning Arrester Multi spike - Sufficient numbers shall be provided for lightning',
        ]),
      ],
    );
  }

  Future<pw.Page> _generateFourthPage() async {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(70),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 40),
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
              if (inquiry.address != null)
                pw.Text(inquiry.address!,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
              if (inquiry.mobileNumber != null)
                pw.Text('Mobile: ${inquiry.mobileNumber}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
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
                style: pw.TextStyle(
                    fontSize: 12, fontWeight: pw.FontWeight.normal),
              ),
              pw.Text('Date: ${_formatDate(inquiry.createdAt)}',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.normal)),
            ],
          ),
        ]);
  }

  pw.Widget _buildSecondPageIntroduction() {
    return pw.Text(
      'Please find our customized proposal for installing a solar power plant at your facility.\n\nWe request you to kindly review the same and feel free to contact us for any additional information.',
      style: pw.TextStyle(fontSize: 11),
    );
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
          '3-DOT Energy solutions- a division of Rightimage Consultants  Pvt- ltd -Thrissur, is managed by a group of professionals and businessmen with decades of experience in their respective fields is focused to provide cost effective energy solutions to its customers. Established in 1990 as a manufacturer of Inverters, SMPS and Automobile electronic products,  In the year 2010,  3DOT foray its business into renewable energy sector across the state of Kerala. We have successfully completed over 250 KW solar projects of various capacities for institutions and households. Our client base stands at 150 plus. We are an experienced green energy solutions provider capable of understanding client requirements and provide suitable cost effective solutions for the same. ',
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

  pw.Widget _buildMountingStructure() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Features',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
        ),
        pw.SizedBox(height: 5),
        _buildBulletList([
          'Smart monitoring-Wi-Fi communication ',
        ]),
        pw.SizedBox(height: 10),
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
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          pw.Text('Warranty for Net meter - 4 years',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center),
          pw.Text(' against manufacturing defects',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.normal,
              ),
              textAlign: pw.TextAlign.center),
        ]),
        pw.SizedBox(height: 10),
        pw.Text('Power generation Daily :    15 units ,subject to sunlight',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.normal,
            ),
            textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 10),
        pw.Text('Pricing Details for ${inquiry.proposedCapacity} panal',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline),
            textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('Particulars', isFirst: true, isHeader: true),
                _buildTableCell('Price', isFirst: true, isHeader: true),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell(
                    "Supply and Installation of ${inquiry.proposedCapacity} KW Ongrid Solar Power\nPlant with Mono perc panels ${inquiry.proposedCapacity} kW Microtek /Sofar\nInverter and all accessories.(Including GST)",
                    alignment: pw.Alignment.centerLeft,
                    isSecond: true),
                _buildTableCell(
                    "${_formatCurrency(inquiry.proposedAmount ?? 0)}\n  \n ",
                    alignment: pw.Alignment.center,
                    isSecond: true),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell('Total amount',
                    alignment: pw.Alignment.centerLeft, isSecond: true),
                _buildTableCell(
                    '${_formatCurrency(inquiry.proposedAmount ?? 0)}',
                    alignment: pw.Alignment.center,
                    isSecond: true,
                    isHeader: true),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 15),
        pw.Text(
            'Note: KSEB statutory payments charges extra (Rs. 4720.00)\n   Feasibility fee          1180.00(1000+18% tax)\n    Registration fee       3540.00(3000+18% tax)\n\n     (Refundable amount to the client Rs.2400.00)',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 25),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Text('Subsidy amount Rs. 78,000/-',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                  color: PdfColors.green),
              textAlign: pw.TextAlign.left),
        ])
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
          'Payment Schedule:',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
        ),
        pw.SizedBox(height: 5),
        _buildBulletList([
          '50% against order, 40% material supply, & 10% after completion of work',
          'All payment to be made in favor of “Rightimage Consultants Pvt Ltd',
          'UG Cable will be extra as per requirement, if necessary',
          'Bank details: Rightimage Consultants Pvt Ltd. Bank of India , Thrissur Branch A/C No.855030110000076 IFS Code- BKID0008550',
        ]),
        pw.SizedBox(height: 15),
        pw.Text(
          'Terms & conditions:',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
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
          'Price validity:',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Above quoted price is valid for one month only',
          style: pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 15),
        pw.Text(
          'Warranty:',
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'The warranty provided by us does not cover damages to the solar power plant/equipments, due to natural calamities like flood, heavy winds, lightning etc.Customer can take insurance policy for their solar power plant/equipments against such incidents.\n\n'
          'We once again thank you for the opportunity given to represent ourselves and trust that our offer is in line with your requirements and looking forward to hearing from you.\n\nSincerely,',
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
          '\n\n\n\nGeorge Thomas\nManaging Director',
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  // Helper widgets and methods
  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.Alignment alignment = pw.Alignment.centerLeft,
    bool isFirst = false,
    bool isSecond = false,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.all(5),
      alignment: alignment,
      color: isFirst
          ? PdfColor.fromHex("#eeece1")
          : isSecond
              ? PdfColor.fromHex("#dbe5f1")
              : null,
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
        return pw.Bullet(
          text: item,
          style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
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
}
