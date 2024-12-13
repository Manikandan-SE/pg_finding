import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pg_finding/utils/index.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/index.dart';

class PgCard extends StatefulWidget {
  final FilterPgModel? pgDetails;
  final double? width;
  final double? height;
  final Function()? onTap;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  final bool? isSaved;
  const PgCard({
    super.key,
    this.width,
    this.height,
    this.onTap,
    this.pgDetails,
    this.isSaved,
    this.onTapSave,
  });

  @override
  State<PgCard> createState() => _PgCardState();
}

class _PgCardState extends State<PgCard> {
  void onTapSave() {
    if (widget.onTapSave != null) {
      widget.onTapSave!(
        pgDetails: widget.pgDetails,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.pgDetails?.img1 ?? '',
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
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(
                8,
              ),
              decoration: BoxDecoration(
                color: getPgCategory(
                              pgCategory: widget.pgDetails?.pgCategory,
                            ) ==
                            'Boys PG' ||
                        getPgCategory(
                              pgCategory: widget.pgDetails?.pgCategory,
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
                      ),
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
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 45,
              height: 40,
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
                  widget.isSaved != null && !widget.isSaved!
                      ? Icons.favorite_border_outlined
                      : Icons.favorite,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(
                10,
              ),
              width: double.infinity,
              height: context.height * 0.085,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                color: const Color.fromARGB(227, 255, 255, 255),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.pgDetails?.pg_name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatAmount(widget.pgDetails?.amount),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.pgDetails?.city ?? ''},Chennai'.trim(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        getPgType(pgType: widget.pgDetails?.pgType),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
