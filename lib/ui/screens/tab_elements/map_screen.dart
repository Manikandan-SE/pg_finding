import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../utils/index.dart';

class MapScreen extends StatefulWidget {
  final LocationData? locationData;
  const MapScreen({super.key, this.locationData});

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

  @override
  void initState() {
    super.initState();
    myCurrentPosition = LatLng(widget.locationData?.latitude ?? 12.990840,
        widget.locationData?.longitude ?? 80.214330);
    customMarker();
  }

  void displayInfo(
      {required BitmapDescriptor userIcon, required BitmapDescriptor pgIcon}) {
    final List<Map<String, dynamic>> latlngPoint = [
      {
        'icon': userIcon,
        'latlng': myCurrentPosition,
      },
      {
        'icon': pgIcon,
        'latlng': const LatLng(12.992733526761468, 80.21139742511788),
      },
      {
        'icon': pgIcon,
        'latlng': const LatLng(13.036682665346392, 80.21054139707249),
      },
      {
        'icon': pgIcon,
        'latlng': const LatLng(12.989035016170355, 80.21580923611359),
      },
    ];
    for (var i = 0; i < latlngPoint.length; i++) {
      final markerIcon = latlngPoint[i]['icon'] as BitmapDescriptor;
      final position = latlngPoint[i]['latlng'] as LatLng;
      markers.add(
        Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          icon: markerIcon,
          position: position,
          onTap: () async {
            if (customInfoWindowController.addInfoWindow != null) {
              customInfoWindowController.addInfoWindow!(
                const PgWindowView(),
                position,
              );
              // final coordinates = await fetchPolylinePoints(
              //   destination: position,
              // );
              final coordinates = await fetchPolylineFromOSRM(
                myCurrentPosition,
                position,
              );
              print('osrm res $coordinates');
              generatePolylineFromPoints(coordinates);
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
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
  const PgWindowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              imageUrl:
                  "https://lh3.googleusercontent.com/p/AF1QipNqVC0y-ddz88RrR7UhllUgpwfVMMK72-D_-6KO=s1360-w1360-h1020",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VENKATESWARA PG GENTS',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'HOSTEL NO 87/16 VENKATESWARA NAGAR 3RD MAIN ROAD VELACHERY ROAD',
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
    );
  }
}
