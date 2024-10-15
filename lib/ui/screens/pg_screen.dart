import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';

import 'index.dart';

class PGScreen extends StatefulWidget {
  const PGScreen({super.key});

  @override
  State<PGScreen> createState() => _PGScreenState();
}

class _PGScreenState extends State<PGScreen> {
  int _selectedIndex = 0;

  LocationData? locationData;
  String currentAddress = '';
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => _getCurrentPosition(),
    // );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    try {
      locationData = await location.getLocation();
      if (locationData != null &&
          locationData!.latitude != null &&
          locationData!.longitude != null) {
        _getAddressFromLatLng(
          latitude: locationData!.latitude!,
          longitude: locationData!.longitude!,
        );
      }
    } catch (e) {
      print('Location Error $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services'),
          ),
        );
        return false;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
          ),
        );
        return false;
      }
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(
      {required double latitude, required double longitude}) async {
    await geocoding
        .placemarkFromCoordinates(latitude, longitude)
        .then((List<geocoding.Placemark> placemarks) {
      geocoding.Placemark place = placemarks[0];
      print('address ${jsonEncode(place)}');
      currentAddress =
          '${place.subLocality != null && place.subLocality!.isNotEmpty ? '${place.subLocality},' : ''} ${place.locality != null && place.locality!.isNotEmpty ? '${place.locality},' : ''} ${place.postalCode != null && place.postalCode!.isNotEmpty ? '${place.postalCode},' : ''} TN'
              .trim(); //${place.administrativeArea}
      setState(() {});
    }).catchError((e) {
      debugPrint(e);
    });
  }

//GeoLocator code

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //   )).then((Position position) {
  //     setState(() => _currentPosition = position);
  //     _getAddressFromLatLng(position);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services'),
  //       ),
  //     );

  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Location permissions are denied'),
  //         ),
  //       );
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.'),
  //       ),
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    // print('userDetails ${jsonEncode(getUserData())}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            currentAddress: currentAddress,
          ),
          MapScreen(
            locationData: locationData,
          ),
          const Text('Saved PG'),
          const Text('Bookings'),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 8,
            ),
            child: GNav(
              rippleColor: Colors.grey.shade300,
              hoverColor: Colors.grey.shade100,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              duration: const Duration(
                milliseconds: 400,
              ),
              tabBackgroundColor: Colors.grey.shade100,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.mapMarker,
                  text: 'Map View',
                ),
                GButton(
                  icon: LineIcons.heart,
                  text: 'Saved PG',
                ),
                GButton(
                  icon: LineIcons.bed,
                  text: 'Bookings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

  //  ElevatedButton(
  //             onPressed: () {
  //               handleLogout();
  //               Navigator.of(context).pushNamedAndRemoveUntil(
  //                 initRoute,
  //                 (route) => false,
  //               );
  //             },
  //             child: const Text('Logout'),
  //           )
