import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/index.dart';
import '../../../utils/index.dart';

class MapScreen extends StatefulWidget {
  final LocationData? locationData;
  final List<FilterPgModel?>? pgList;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  final bool? fromSearchRoute;
  const MapScreen({
    super.key,
    this.locationData,
    this.pgList,
    this.onTapSave,
    this.fromSearchRoute,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng myCurrentPosition;

  late GoogleMapController googleMapController;

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor pgIcon = BitmapDescriptor.defaultMarker;

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  bool initOnce = true;

  @override
  void initState() {
    super.initState();
    myCurrentPosition = LatLng(widget.locationData?.latitude ?? 12.990840,
        widget.locationData?.longitude ?? 80.214330);
    // customMarker();
  }

  void displayInfo(
      {required BitmapDescriptor userIcon, required BitmapDescriptor pgIcon}) {
    var getLatLngInPgList = widget.pgList != null && widget.pgList!.isNotEmpty
        ? widget.pgList!
            .map((elem) => ({
                  'pgId': elem?.pgId ?? 0,
                  'icon': pgIcon,
                  'latlng': LatLng(
                    elem?.latitude ?? 0.0,
                    elem?.longitude ?? 0.0,
                  ),
                  'pgItem': elem,
                }))
            .toList()
        : [
            {
              'pgId': 1,
              'icon': pgIcon,
              'latlng': const LatLng(12.992733526761468, 80.21139742511788),
              'pgItem': null,
            },
            {
              'pgId': 2,
              'icon': pgIcon,
              'latlng': const LatLng(13.036682665346392, 80.21054139707249),
              'pgItem': null,
            },
            {
              'pgId': 3,
              'icon': pgIcon,
              'latlng': const LatLng(12.989035016170355, 80.21580923611359),
              'pgItem': null,
            },
          ];

    final List<Map<String, dynamic>> latlngPoint = [
      {
        'pgId': -1,
        'icon': userIcon,
        'latlng': myCurrentPosition,
        'pgItem': null,
      },
      ...getLatLngInPgList,
      // {
      //   'icon': pgIcon,
      //   'latlng': const LatLng(12.992733526761468, 80.21139742511788),
      // },
      // {
      //   'icon': pgIcon,
      //   'latlng': const LatLng(13.036682665346392, 80.21054139707249),
      // },
      // {
      //   'icon': pgIcon,
      //   'latlng': const LatLng(12.989035016170355, 80.21580923611359),
      // },
    ];
    for (var i = 0; i < latlngPoint.length; i++) {
      final markerIcon = latlngPoint[i]['icon'] as BitmapDescriptor;
      final position = latlngPoint[i]['latlng'] as LatLng;
      final pgItem = latlngPoint[i]['pgId'] != -1
          ? latlngPoint[i]['pgItem'] as FilterPgModel?
          : null;
      markers.add(
        Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          icon: markerIcon,
          position: position,
          onTap: () async {
            if (customInfoWindowController.addInfoWindow != null) {
              if (latlngPoint[i]['pgId'] != -1) {
                customInfoWindowController.addInfoWindow!(
                  PgWindowView(
                    pgItem: pgItem,
                    onTapSave: widget.onTapSave,
                  ),
                  position,
                );

                final coordinates = await fetchPolylineFromOSRM(
                  myCurrentPosition,
                  position,
                );
                generatePolylineFromPoints(coordinates);
              }
            }
          },
        ),
      );
      setState(() {});
    }
  }

  void customMarker() {
    BitmapDescriptor.asset(
      const ImageConfiguration(),
      pgMarker,
    ).then(
      (icon) {
        setState(
          () {
            pgIcon = icon;
          },
        );
        displayInfo(pgIcon: pgIcon, userIcon: userIcon);
      },
    );
    BitmapDescriptor.asset(
      const ImageConfiguration(),
      userMarker,
    ).then(
      (icon) {
        setState(
          () {
            userIcon = icon;
          },
        );
        displayInfo(pgIcon: pgIcon, userIcon: userIcon);
      },
    );
  }

  // Future<List<LatLng>> fetchPolylinePoints(
  //     {required LatLng destination}) async {
  //   try {
  //     final polylinePoints = PolylinePoints();
  //     final result = await polylinePoints.getRouteBetweenCoordinates(
  //       googleApiKey: googleMapApiKey,
  //       request: PolylineRequest(
  //         origin: PointLatLng(
  //           myCurrentPosition.latitude,
  //           myCurrentPosition.longitude,
  //         ),
  //         destination: PointLatLng(
  //           destination.latitude,
  //           destination.longitude,
  //         ),
  //         mode: TravelMode.driving,
  //         wayPoints: [
  //           PolylineWayPoint(
  //             location: "Sabo, Yaba Lagos Nigeria",
  //           ),
  //         ],
  //       ),
  //     );
  //     if (result.points.isNotEmpty) {
  //       print('mappoints ${result.points}');
  //       return result.points
  //           .map(
  //             (point) => LatLng(
  //               point.latitude,
  //               point.longitude,
  //             ),
  //           )
  //           .toList();
  //     } else {
  //       debugPrint('maperror ${result.errorMessage}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('maperror $e');
  //     return [];
  //   }
  // }

  Future<List<LatLng>> fetchPolylineFromOSRM(LatLng start, LatLng end) async {
    final dio = Dio();
    final url = 'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final decodedData = response.data;
      final polyline = decodedData['routes'][0]['geometry']['coordinates'];

      return polyline.map<LatLng>((point) {
        return LatLng(
            point[1], point[0]); // GeoJSON format is [longitude, latitude]
      }).toList();
    } else {
      throw Exception('Failed to fetch polyline');
    }
  }

  Future<void> generatePolylineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black87,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void initOnceMap() {
    if (initOnce) {
      if (widget.pgList != null && widget.pgList!.isNotEmpty) {
        setState(() {
          initOnce = false;
        });
        customMarker();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initOnceMap();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: myCurrentPosition,
              zoom: 16,
            ),
            markers: markers,
            onMapCreated: (controller) {
              googleMapController = controller;
              customInfoWindowController.googleMapController = controller;
            },
            onTap: (location) {
              if (customInfoWindowController.hideInfoWindow != null) {
                customInfoWindowController.hideInfoWindow!();
              }
            },
            onCameraMove: (position) {
              if (customInfoWindowController.onCameraMove != null) {
                customInfoWindowController.onCameraMove!();
              }
            },
            polylines: Set<Polyline>.of(polylines.values),
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 150,
            width: 200,
            offset: 70,
          ),
          widget.fromSearchRoute != null && widget.fromSearchRoute!
              ? Positioned(
                  top: context.height * 0.07,
                  left: context.height * 0.02,
                  child: Container(
                    width: 45,
                    height: 45,
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.black,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: myCurrentPosition,
                zoom: 16,
              ),
            ),
          );
          markers.clear();
          customMarker();
        },
        child: const Icon(
          Icons.my_location,
          size: 30,
        ),
      ),
    );
  }
}

class PgWindowView extends StatelessWidget {
  final FilterPgModel? pgItem;
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const PgWindowView({
    super.key,
    this.pgItem,
    this.onTapSave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(pgDetailsRoute, arguments: {
          'pgDetails': pgItem,
          'onTapSave': onTapSave,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ),
              child: CachedNetworkImage(
                width: double.infinity,
                height: context.height * 0.1,
                fit: BoxFit.cover,
                imageUrl: pgItem?.img1 ?? '',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pgItem?.pg_name ?? '',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    pgItem?.pgAddress ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
