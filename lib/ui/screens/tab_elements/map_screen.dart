import 'package:custom_info_window/custom_info_window.dart';
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
          onTap: () {
            if (customInfoWindowController.addInfoWindow != null) {
              customInfoWindowController.addInfoWindow!(
                Container(
                  child: Text(
                    latlngPoint[i].toString(),
                  ),
                ),
                position,
              );
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
      },
    );
    BitmapDescriptor.asset(const ImageConfiguration(), userMarker,).then(
      (icon) {
        setState(
          () {
            userIcon = icon;
          },
        );
      },
    );
    displayInfo(pgIcon: pgIcon, userIcon: userIcon);
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
              zoom: 14,
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
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 200,
            width: 250,
            offset: 50,
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
                zoom: 14,
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
