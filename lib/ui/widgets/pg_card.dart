import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pg_finding/utils/index.dart';
import 'package:shimmer/shimmer.dart';

class PgCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Function()? onTap;
  const PgCard({super.key, this.width, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
            width: width ?? double.infinity,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    "https://lh3.googleusercontent.com/p/AF1QipNqVC0y-ddz88RrR7UhllUgpwfVMMK72-D_-6KO=s1360-w1360-h1020",
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
                // color: const Color.fromARGB(
                //   100,
                //   255,
                //   0,
                //   0,
                // ), // Transparent red background
                color: const Color.fromARGB(
                  100,
                  0,
                  0,
                  0,
                ),
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: const Text(
                'Boys PG',
                style: TextStyle(
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
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_outlined,
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
              height: context.height * 0.075,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                color: const Color.fromARGB(227, 255, 255, 255),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vimala PG',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹7,000',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Velachery,Chennai',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'double sharing',
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
