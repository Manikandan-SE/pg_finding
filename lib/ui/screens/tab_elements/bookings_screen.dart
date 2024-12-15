import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pg_finding/utils/index.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/index.dart';

class BookingsScreen extends StatelessWidget {
  final List<BookingListModel?>? bookingPgList;
  final Function({BookingListModel? bookingDetails})? onChangeBookingStatus;
  const BookingsScreen({
    super.key,
    this.bookingPgList,
    this.onChangeBookingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: Text(
                "My bookings",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: context.width * 0.05,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                itemCount: bookingPgList?.length ?? 0,
                itemBuilder: (context, index) {
                  return BookingsCard(
                    bookingPg:
                        bookingPgList != null ? bookingPgList![index] : null,
                    onChangeBookingStatus: onChangeBookingStatus,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingsCard extends StatelessWidget {
  final BookingListModel? bookingPg;
  final Function({BookingListModel? bookingDetails})? onChangeBookingStatus;
  const BookingsCard({
    super.key,
    this.bookingPg,
    this.onChangeBookingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.height * 0.19,
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(
        //       0.15,
        //     ),
        //     spreadRadius: 0,
        //     blurRadius: 2,
        //     offset: const Offset(
        //       0,
        //       4,
        //     ),
        //   ),
        // ],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: context.height,
              width: context.width * 0.3,
              imageUrl: bookingPg?.pgDetails?.img1 ?? '',
              progressIndicatorBuilder: (context, url, downloadProgress) =>
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bookingPg?.pgDetails?.pgName ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              bookingPg != null && bookingPg?.booked == 'Booked'
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: Text(
                          bookingPg?.booked ?? '',
                          style: TextStyle(
                            color: bookingPg != null &&
                                    bookingPg?.booked == 'Booked'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    bookingPg?.pgDetails?.pgAddress ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    'Chennai',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              formatAmount(bookingPg?.pgDetails?.amount),
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: getPgCategory(
                                              pgCategory: bookingPg
                                                  ?.pgDetails?.pgCategory,
                                            ) ==
                                            'Boys PG' ||
                                        getPgCategory(
                                              pgCategory: bookingPg
                                                  ?.pgDetails?.pgCategory,
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
                                      ), // Transparent red background,
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              child: Text(
                                getPgCategory(
                                  pgCategory: bookingPg?.pgDetails?.pgCategory,
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  bookingDetailsRoute,
                                  arguments: {
                                    'bookingPg': bookingPg,
                                    'onChangeBookingStatus':
                                        onChangeBookingStatus,
                                  },
                                );
                              },
                              child: const Text(
                                "View Details",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
