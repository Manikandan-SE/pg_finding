import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/index.dart';
import '../../utils/index.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookingListModel? bookingPg;
  final Function({BookingListModel? bookingDetails})? onChangeBookingStatus;
  const BookingDetailsScreen({
    super.key,
    this.bookingPg,
    this.onChangeBookingStatus,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool isInvoiceLoading = false;

  String? bookingStatus;

  @override
  void initState() {
    super.initState();
    setState(() {
      bookingStatus =
          widget.bookingPg != null && widget.bookingPg!.booked != null
              ? widget.bookingPg!.booked
              : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Details',
        ),
        actions: [
          widget.bookingPg != null &&
                  widget.bookingPg!.booked != null &&
                  bookingStatus == 'Cancelled'
              ? const SizedBox()
              : PopupMenuButton<String>(
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
                                onPressed: () async {
                                  await AppServices().patchCancelBookedpg(
                                    pgId:
                                        widget.bookingPg?.pgDetails?.pgId ?? 0,
                                    status: 'Cancelled',
                                  );
                                  // Add your cancellation logic here
                                  Navigator.of(context).pop();
                                  if (widget.onChangeBookingStatus != null) {
                                    widget.onChangeBookingStatus!(
                                      bookingDetails: widget.bookingPg,
                                    );
                                  }
                                  setState(() {
                                    bookingStatus = 'Cancelled';
                                  });
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
              Container(
                padding: const EdgeInsets.all(
                  16,
                ),
                margin: const EdgeInsets.all(
                  16,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                child: Column(
                  children: [
                    widget.bookingPg != null &&
                            widget.bookingPg!.booked != null &&
                            bookingStatus == 'Cancelled'
                        ? const SizedBox()
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade100,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Transaction ID:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.bookingPg?.transactionId ?? '',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: context.height * 0.03,
                              ),
                            ],
                          ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BookingInfo(
                          title: 'Booking ID',
                          value: '${widget.bookingPg?.bookingId ?? ''}',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'Booking Date',
                          value: widget.bookingPg?.bookingDate ?? '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'Booking Status',
                          value: bookingStatus ?? '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'PG Name',
                          value: widget.bookingPg?.pgDetails?.pgName ?? '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'PG Address',
                          value: widget.bookingPg?.pgDetails?.pgAddress ?? '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'Booked Amount',
                          value: formatAmount(
                            widget.bookingPg?.pgDetails?.amount,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'Room Category',
                          value: getPgType(
                            pgType: widget.bookingPg?.pgDetails?.pgType,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'PG Category',
                          value: getPgCategory(
                            pgCategory: widget.bookingPg?.pgDetails?.pgCategory,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'PG Owner Name',
                          value:
                              widget.bookingPg?.pgDetails?.owner?.ownerName ??
                                  '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BookingInfo(
                          title: 'PG Owner Ph No',
                          value: widget.bookingPg?.pgDetails?.owner
                                  ?.ownerPhoneNumber ??
                              '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bookingPg != null &&
              widget.bookingPg!.booked != null &&
              bookingStatus == 'Cancelled'
          ? const SizedBox()
          : Container(
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
    final bookingPg = widget.bookingPg;
    final pgDetails = bookingPg?.pgDetails;
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
                            getUserData()?.name ?? 'Buddy',
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
                            bookingPg?.bookingDate ?? '11/12/2024',
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
                            pgDetails?.pgName ?? '',
                          ),
                          // pw.Expanded(
                          //   child:
                          pw.Text(
                            pgDetails?.pgAddress ?? '',
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                          // ),
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
                          '${bookingPg?.bookingId ?? ''}',
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
                          bookingPg?.transactionId ?? '',
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
                          getPgCategory(
                            pgCategory: pgDetails?.pgCategory,
                          ),
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
                          getPgType(pgType: pgDetails?.pgType),
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
                        formatAmount(pgDetails?.amount),
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

class BookingInfo extends StatelessWidget {
  final String title;
  final String value;
  const BookingInfo({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '$title:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
