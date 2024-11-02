import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../utils/index.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool isInvoiceLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Details',
        ),
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (value) {
              if (value == 'cancel') {
                // Handle the cancel booking action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Cancel Booking"),
                      content: const Text(
                          "Are you sure you want to cancel the booking?"),
                      actions: [
                        TextButton(
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            // Add your cancellation logic here
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Booking cancelled",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel Booking'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: context.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.blue.shade100,
                width: double.infinity,
                height: context.height * 0.35,
                child: Image.asset(
                  booking,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.15,
              ),
              spreadRadius: 0,
              blurRadius: 15, // Increased blur radius
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(
              12,
            ),
            backgroundColor: Colors.black,
            overlayColor: Colors.black,
            surfaceTintColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            side: const BorderSide(
              color: Colors.black,
            ),
          ),
          onPressed: !isInvoiceLoading ? createPDF : () {},
          child: !isInvoiceLoading
              ? const Text(
                  'Download Invoice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              : const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  void createPDF() async {
    setState(() {
      isInvoiceLoading = true;
    });
    var applogo = (await rootBundle.load(appLogo)).buffer.asUint8List();
    final doc = pw.Document();
    final fontFamily = await PdfGoogleFonts.firaSansExtraCondensedRegular();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData(
            defaultTextStyle: pw.TextStyle(
          fontSize: 10,
          font: fontFamily,
          color: PdfColor.fromHex(
            '#444444',
          ),
        )),
        build: (context) {
          return pw.Container(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Image(
                      pw.MemoryImage(
                        applogo,
                      ),
                      height: 130,
                    ),
                    pw.SizedBox(
                      width: 100,
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        'Invoice',
                        style: const pw.TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(
                        color: PdfColors.black,
                      ),
                      bottom: pw.BorderSide(
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text(
                            'Guest Name',
                            style: const pw.TextStyle(
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(
                            width: 5,
                          ),
                          pw.Text(
                            'Bubu',
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Invoice Date',
                            style: const pw.TextStyle(
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(
                            width: 5,
                          ),
                          pw.Text(
                            '14/10/2024',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  height: 16,
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'PG Details',
                            style: const pw.TextStyle(
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(
                            height: 5,
                          ),
                          pw.Text(
                            'Bubu PG',
                          ),
                          pw.Text(
                            '8/5, Ragupathy Nagar, Nanganallur, Chennai - 600061',
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Booking ID',
                          style: const pw.TextStyle(
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Text(
                          '12231',
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Transaction ID',
                          style: const pw.TextStyle(
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Text(
                          '1342331',
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'PG Category',
                          style: const pw.TextStyle(
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Text(
                          'Boys PG',
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Room Category',
                          style: const pw.TextStyle(
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Text(
                          'Double Shaeing',
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 16,
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(
                        color: PdfColors.grey400,
                      ),
                      bottom: pw.BorderSide(
                        color: PdfColors.grey400,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'DESCRIPTION',
                          style: const pw.TextStyle(
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                      pw.Text(
                        'AMOUNT',
                        style: const pw.TextStyle(
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey400,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'Total Amount',
                        ),
                      ),
                      pw.Text(
                        '₹7,000',
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  height: 16,
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'General Instruction',
                      style: const pw.TextStyle(
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Text(
                      '- We recommend that you consider finalizing the payment only after reaching a mutual agreement with the pg owner.',
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ),
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Text(
                      '- Before paying to the pg owner, ensure clear communication and understanding among everyone involved.',
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    const fileName = "PG_Finding_App_Invoice.pdf";
    final savePath = path.join(
      dir.path,
      fileName,
    );
    final file = File(
      savePath,
    );
    await file.writeAsBytes(
      await doc.save(),
    );
    OpenFile.open(
      file.path,
    );
    setState(() {
      isInvoiceLoading = false;
    });
  }
}
