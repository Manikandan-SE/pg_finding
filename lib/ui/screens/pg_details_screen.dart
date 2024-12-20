import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pg_finding/utils/index.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/index.dart';

class PgDetailsScreen extends StatefulWidget {
  final FilterPgModel? pgDetails;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const PgDetailsScreen({
    super.key,
    this.pgDetails,
    this.onTapSave,
  });

  @override
  State<PgDetailsScreen> createState() => _PgDetailsScreenState();
}

class _PgDetailsScreenState extends State<PgDetailsScreen> {
  Razorpay? _razorpay;
  bool isPaymentLoading = false;
  bool isBooked = false;

  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    if (_razorpay != null) {
      _razorpay?.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        _handlePaymentSuccess,
      );
      _razorpay?.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        _handlePaymentError,
      );
      _razorpay?.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        _handleExternalWallet,
      );
    }
    setState(() {
      isSaved = widget.pgDetails?.isSaved ?? false;
    });
    checkPGAlreadyBooked();
  }

  void checkPGAlreadyBooked() async {
    var tempList = await AppServices().fetchFilterPG(
      pgId: '${widget.pgDetails?.pgId ?? ''}',
    );
    if (tempList != null &&
        tempList.isNotEmpty &&
        tempList[0]?.booking_status != null &&
        tempList[0]?.booking_status == 'Booked') {
      setState(() {
        isBooked = true;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      isPaymentLoading = false;
      isBooked = true;
    });
    await AppServices().postBookPg(
      amount: widget.pgDetails?.amount ?? '0',
      booked: 'Booked',
      pgId: widget.pgDetails?.pgId ?? 0,
      transactionId: response.paymentId ?? '',
    );
    print('payment success ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    setState(() {
      isPaymentLoading = false;
      isBooked = false;
    });
    await AppServices().postBookPg(
      amount: widget.pgDetails?.amount ?? '0',
      booked: 'Cancelled',
      pgId: widget.pgDetails?.pgId ?? 0,
    );
    print('payment failed ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    setState(() {
      isPaymentLoading = false;
      isBooked = false;
    });
    await AppServices().postBookPg(
      amount: widget.pgDetails?.amount ?? '0',
      booked: 'Booked',
      pgId: widget.pgDetails?.pgId ?? 0,
    );
    debugPrint('payment debited from ${response.walletName}');
  }

  void makePayment() async {
    setState(() {
      isPaymentLoading = true;
    });
    var options = {
      'key': 'rzp_test_7Qh0tVrzu14RdS',
      'amount': widget.pgDetails != null && widget.pgDetails?.amount != null
          ? (int.parse(widget.pgDetails!.amount!) * 100)
          : 0,
      'name': 'PG Finding App',
      'description': widget.pgDetails?.pg_name ?? '',
      'prefill': {
        'contact': getUserData()?.phoneNumber ?? '',
      }
    };
    try {
      _razorpay?.open(
        options,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void goToDestination() async {
    try {
      double destinationLatitude =
          widget.pgDetails?.latitude ?? 12.97142854321849;
      double destinationLongitude =
          widget.pgDetails?.longitude ?? 80.18270049618685;
      // final uri = Uri(
      //     scheme: "google.navigation",
      //     // host: '"0,0"',  {here we can put host}
      //     queryParameters: {
      //       'q': '$destinationLatitude,$destinationLongitude',
      //       'mode': 'd',
      //     });
      final url =
          'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(
        uri,
      )) {
        await launchUrl(uri);
      } else {
        debugPrint('An error occurred');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void makingPhoneCall() async {
    try {
      final phone = widget.pgDetails?.pgPhoneNumber ?? 7904696681;
      var url = Uri.parse("tel:$phone");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onTapSave() {
    setState(() {
      isSaved = !isSaved;
    });
    if (widget.onTapSave != null) {
      widget.onTapSave!(
        pgDetails: widget.pgDetails,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: context.height * 0.3,
                backgroundColor: Colors.white,
                leading: Container(
                  width: 45,
                  height: 30,
                  margin: const EdgeInsets.all(
                    6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: const Color.fromARGB(
                      227,
                      255,
                      255,
                      255,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.black,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    width: 45,
                    height: 40,
                    margin: const EdgeInsets.all(
                      8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      color: const Color.fromARGB(227, 255, 255, 255),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: onTapSave,
                      icon: Icon(
                        isSaved
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                      ),
                    ),
                  ),
                ],
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(

                    // centerTitle: true,
                    // title: const Text("Collapsing Toolbar",
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 16.0,
                    //     )),
                    background: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(
                      seconds: 3,
                    ),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [
                    widget.pgDetails?.img1 ?? '',
                    widget.pgDetails?.img2 ?? '',
                    widget.pgDetails?.img3 ?? '',
                  ].map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: item,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.yellow.shade100,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 30,
                                        ),
                                        child: Text(
                                          "Couldn't Load Image",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'slide to see all images >>>',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                )),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pgDetails?.pg_name ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              getPgType(pgType: widget.pgDetails?.pgType),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(
                          8,
                        ),
                        decoration: BoxDecoration(
                          color: getPgCategory(
                                        pgCategory:
                                            widget.pgDetails?.pgCategory,
                                      ) ==
                                      'Boys PG' ||
                                  getPgCategory(
                                        pgCategory:
                                            widget.pgDetails?.pgCategory,
                                      ) ==
                                      'Co-Living'
                              ? const Color.fromARGB(
                                  100,
                                  0,
                                  0,
                                  0,
                                )
                              : const Color.fromARGB(
                                  100,
                                  255,
                                  0,
                                  0,
                                ), // Transparent red background
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        child: Text(
                          getPgCategory(
                            pgCategory: widget.pgDetails?.pgCategory,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const LinearLine(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address & Map Direction',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              const Icon(
                                LineIcons.mapMarker,
                                size: 24,
                              ),
                              SizedBox(
                                width: context.width * 0.02,
                              ),
                              Expanded(
                                child: Text(
                                  widget.pgDetails?.pgAddress ?? '',
                                ),
                              ),
                            ],
                          )),
                          IconButton(
                            color: Colors.black,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blue.shade200,
                            ),
                            onPressed: goToDestination,
                            icon: const Icon(
                              LineIcons.directions,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const LinearLine(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room Facilities',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 4.5,
                        ),
                        children: [
                          _roomFacilities(
                            icon: wifi,
                            facility: 'Wifi',
                          ),
                          _roomFacilities(
                            icon: cctc,
                            facility: 'CCTV',
                          ),
                          _roomFacilities(
                            icon: fingerPrint,
                            facility: 'Biometric Lock',
                          ),
                          _roomFacilities(
                            icon: fridge,
                            facility: 'Refrigerator',
                          ),
                          _roomFacilities(
                            icon: water,
                            facility: 'RO Filter',
                          ),
                          _roomFacilities(
                            icon: washingMachine,
                            facility: 'Washing Machine',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const LinearLine(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PG Facilities',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 3.2,
                        ),
                        children: [
                          _pgFacilities(
                            facility: 'Semi-Furnished rooms',
                          ),
                          _pgFacilities(
                            facility: 'Electricity bill is included',
                          ),
                          _pgFacilities(
                            facility: 'Cleaning service is included in rent',
                          ),
                          _pgFacilities(
                            facility: '3-4 times Meal is included',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const LinearLine(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PG Owner Details',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.15,
                              ),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  pgOwner,
                                  // width: context.width * 0.2,
                                  height: context.height * 0.08,
                                ),
                                Text(
                                  widget.pgDetails?.owner?.ownerName ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: makingPhoneCall,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                ),
                                child: Image.asset(
                                  call,
                                  width: context.width * 0.1,
                                  height: context.height * 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const LinearLine(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'General Instruction',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      const Text(
                        '- We recommend that you consider finalizing the payment only after reaching a mutual agreement with the pg owner.',
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      const Text(
                        '- Before paying to the pg owner, ensure clear communication and understanding among everyone involved.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 15, // Increased blur radius
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    formatAmount(widget.pgDetails?.amount),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(
                    12,
                  ),
                  backgroundColor: !isBooked ? Colors.black : Colors.green,
                  overlayColor: !isBooked ? Colors.black : Colors.green,
                  surfaceTintColor: !isBooked ? Colors.black : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  side: BorderSide(
                    color: !isBooked ? Colors.black : Colors.green,
                  ),
                ),
                onPressed: !isPaymentLoading && !isBooked ? makePayment : () {},
                child: !isPaymentLoading
                    ? Text(
                        !isBooked ? 'Book Now' : 'Booked',
                        style: const TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget _roomFacilities({required String icon, required String facility}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          icon,
          width: 24,
          height: 24,
        ),
        SizedBox(
          width: context.width * 0.01,
        ),
        Text(
          facility,
        ),
      ],
    );
  }

  Widget _pgFacilities({required String facility}) {
    return Container(
      padding: const EdgeInsets.all(
        8,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chevron_right,
            size: 24,
          ),
          SizedBox(
            width: context.width * 0.01,
          ),
          Expanded(
            child: Text(
              facility,
            ),
          ),
        ],
      ),
    );
  }
}

class LinearLine extends StatelessWidget {
  const LinearLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      color: Colors.grey,
      height: 0.5,
      width: double.infinity,
    );
  }
}
