import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pg_finding/utils/index.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/index.dart';
import '../../widgets/index.dart';

class HomeScreen extends StatelessWidget {
  final String currentAddress;
  final List<LocalityModel?>? localityList;
  final List<FilterPgModel?>? pgList;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const HomeScreen({
    super.key,
    required this.currentAddress,
    this.localityList,
    this.pgList,
    this.onTapSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            SizedBox(
              height: context.height * 0.02,
            ),
            const Banner(),
            SizedBox(
              height: context.height * 0.025,
            ),
            SearchField(
              currentAddress: currentAddress,
              onTapSave: onTapSave,
            ),
            SizedBox(
              height: context.height * 0.01,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NearByPGs(
                      pgList: pgList,
                      onTapSave: onTapSave,
                    ),
                    BrowseByLocality(
                      localityList: localityList,
                      onTapSave: onTapSave,
                    ),
                    SizedBox(
                      height: context.height * 0.025,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                  fontSize: 16, //22
                ),
              ),
              Text(
                getUserData()?.name ?? 'Pookie',
                style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 23, //30
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                profileRoute,
              );
            },
            child: SizedBox(
              width: context.width * 0.2,
              child: Image.asset(
                profileAvator,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's Explore the",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      letterSpacing: 1.5,
                      fontSize: 22,
                    ),
                  ),
                  const Text(
                    'Perfect PG',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: -6,
              child: SizedBox(
                width: context.width * 0.38,
                child: Image.asset(
                  explorePG,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  final String currentAddress;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const SearchField({
    super.key,
    required this.currentAddress,
    this.onTapSave,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Future<List<String>> fetchPlaceSuggestions(String query) async {
    final dio = Dio();
    final String photonUrl =
        'https://photon.komoot.io/api/?q=$query&bbox=79.9272,12.8320,80.3547,13.2612';

    try {
      // Send HTTP GET request
      final response = await dio.get(photonUrl);

      if (response.statusCode == 200) {
        // Parse the response
        Map<String, dynamic> data = response.data;
        List<String> suggestions = [];

        for (var feature in data['features']) {
          String placeName = feature['properties']['name'] ?? '';
          String city = feature['properties']['city'] ?? '';
          String country = feature['properties']['country'] ?? '';

          suggestions.add('$placeName, $city, $country');
        }

        return suggestions;
      } else {
        print('Failed to fetch suggestions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    Navigator.of(context).pushNamed(searchRoute, arguments: {
                      'onTapSave': widget.onTapSave,
                    });
                  },
                  autofocus: false,
                  enableInteractiveSelection: false,
                  canRequestFocus: false,
                  onChanged: (value) async {
                    // if (value.isNotEmpty) {
                    //   List<String> suggestions =
                    //       await fetchPlaceSuggestions(value);
                    //   print('placeSuggestions $suggestions');
                    // }
                  },
                  cursorColor: Colors.black54,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      searchFieldRegex,
                    ),
                  ],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      LineIcons.search,
                    ),
                    hintText: 'Search PG by name, area, landmark',
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      right: 25,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: context.width * 0.025,
              // ),
              // Container(
              //   padding: const EdgeInsets.all(
              //     8,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.amber.shade100,
              //     borderRadius: BorderRadius.circular(
              //       10,
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(
              //           0.15,
              //         ),
              //         spreadRadius: 0,
              //         blurRadius: 2,
              //         offset: const Offset(
              //           0,
              //           4,
              //         ),
              //       ),
              //     ],
              //   ),
              //   child: Image.asset(
              //     filter,
              //     width: 25,
              //     height: 25,
              //   ),
              // ),
            ],
          ),
          if (widget.currentAddress.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    LineIcons.mapMarker,
                    size: 18,
                  ),
                  Text(
                    'Current Location: ',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.currentAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class NearByPGs extends StatelessWidget {
  final List<FilterPgModel?>? pgList;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const NearByPGs({
    super.key,
    this.pgList,
    this.onTapSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Text(
                "Near by PG's",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 6,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(searchRoute, arguments: {
                    'onTapSave': onTapSave,
                  });
                },
                child: const Text(
                  "see all",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: context.height * 0.25,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: context.width * 0.04,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: pgList?.length ?? 0,
            itemBuilder: (context, index) {
              return PgCard(
                pgDetails: pgList != null ? pgList![index] : null,
                width: context.width * 0.8,
                height: context.height,
                onTapSave: onTapSave,
                isSaved: pgList != null &&
                        pgList![index] != null &&
                        pgList![index]!.isSaved != null
                    ? pgList![index]!.isSaved
                    : false,
                onTap: () {
                  Navigator.of(context).pushNamed(pgDetailsRoute, arguments: {
                    'pgDetails': pgList != null ? pgList![index] : null,
                    'onTapSave': onTapSave,
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BrowseByLocality extends StatelessWidget {
  final List<LocalityModel?>? localityList;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const BrowseByLocality({
    super.key,
    this.localityList,
    this.onTapSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Text(
            "Browse by Locality",
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: context.height * 0.26,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: context.width * 0.04,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: localityList?.length ?? 0,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(searchRoute, arguments: {
                  'onTapSave': onTapSave,
                });
              },
              child: LocalityCard(
                locality: localityList != null ? localityList![index] : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LocalityCard extends StatelessWidget {
  final LocalityModel? locality;
  const LocalityCard({
    super.key,
    this.locality,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: context.width * 0.5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  10,
                ),
                topRight: Radius.circular(
                  10,
                ),
              ),
              child: CachedNetworkImage(
                width: double.infinity,
                height: context.height * 0.2,
                fit: BoxFit.cover,
                imageUrl: locality?.img ?? '',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(locality?.locality ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
