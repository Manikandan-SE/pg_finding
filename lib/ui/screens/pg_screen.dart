import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';

import '../../models/index.dart';
import '../../utils/index.dart';
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

  bool initOncePopularPg = true;

  bool initOnceNearByPg = true;

  List<FilterPgModel?>? pgList;

  List<LocalityModel?>? localityList;

  List<FilterPgModel?>? savedPgList;

  List<BookingListModel?>? bookingPgList;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await fetchLocationUpdates(),
    );
    getLocality();
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
          '${place.subLocality != null && place.subLocality!.isNotEmpty ? '${place.subLocality},' : ''} ${place.locality != null && place.locality!.isNotEmpty ? '${place.locality},' : ''} ${place.postalCode != null && place.postalCode!.isNotEmpty ? '${place.postalCode},' : ''} Tamilnadu'
              .trim(); //${place.administrativeArea}
      getFilterPG(place.subLocality);
      setState(() {});
    }).catchError((e) {
      if (e is PlatformException) {
        print("PlatformException occurred: ${e.message}");
      } else {
        print("Unexpected error: $e");
      }
    });
  }

  void getFilterPG(String? subLocality) async {
    if (subLocality != null && subLocality.isNotEmpty) {
      if (initOnceNearByPg) {
        setState(() {
          initOnceNearByPg = false;
        });
        var tempBaseUrl = await AppServices().fetchBaseUrl();
        var tempUserId = await AppServices().postUserMobileNumber(
          phoneNumber: getUserData()?.phoneNumber ?? '',
        );
        var filteredPgList = await AppServices().fetchFilterPG(
              tempUserId: tempUserId,
              tempBaseUrl: tempBaseUrl,
              city: subLocality.toLowerCase(),
            ) ??
            []; //currentAddress.split(',')[0]

        if (filteredPgList.isNotEmpty) {
          setState(() {
            pgList = filteredPgList;
          });
        } else {
          getPopularPG();
        }
      }
    } else {
      if (initOncePopularPg) {
        setState(() {
          initOncePopularPg = false;
        });
        getPopularPG();
      }
    }
  }

  void getPopularPG() async {
    var tempBaseUrl = await AppServices().fetchBaseUrl();
    var filteredPgList = await AppServices().fetchPopularPG(
      tempBaseUrl: tempBaseUrl,
    );
    setState(() {
      pgList = filteredPgList ?? [];
    });
  }

  Future<void> fetchLocationUpdates() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _getAddressFromLatLng(
            latitude: currentLocation.latitude!,
            longitude: currentLocation.longitude!,
          );
        });
      }
    });
  }

  void getLocality() async {
    var tempBaseUrl = await AppServices().fetchBaseUrl();
    var filteredLocalityList = await AppServices().fetchLocality(
      tempBaseUrl: tempBaseUrl,
    );
    setState(() {
      localityList = filteredLocalityList ?? [];
    });
  }

  void onTapSavePG({FilterPgModel? pgDetails}) {
    if (pgDetails == null) return;
    var tempPgList = List<FilterPgModel>.from(pgList != null ? pgList! : []);
    setState(() {
      pgList = tempPgList.map((pg) {
        if (pg.pgId == pgDetails.pgId) {
          postSave(
            pgDetails: pgDetails,
          );
          return pg.copyWith(
            isSaved: pgDetails.isSaved != null ? !pgDetails.isSaved! : false,
          );
        }
        return pg;
      }).toList();
    });
  }

  void onTapSavePGInSavedList({FilterPgModel? pgDetails}) {
    if (pgDetails == null) return;
    var tempPgList =
        List<FilterPgModel>.from(savedPgList != null ? savedPgList! : []);

    if (pgDetails.isSaved == null ||
        (pgDetails.isSaved != null && pgDetails.isSaved!)) {
      setState(() {
        savedPgList = tempPgList
            .where(
              (pg) => pg.pgId != pgDetails.pgId,
            )
            .toList();
      });
    }
    postSave(
      pgDetails: pgDetails,
    );
    onTapSavePG(
      pgDetails: pgDetails,
    );
  }

  void postSave({FilterPgModel? pgDetails}) async {
    await AppServices().postSave(
      pgId: pgDetails?.pgId,
      isSaved: pgDetails != null && pgDetails.isSaved != null
          ? !pgDetails.isSaved!
          : false,
    );
  }

  void getSavedPGList() async {
    final tempSavedPgList = await AppServices().fetchSavedList();
    setState(() {
      savedPgList = tempSavedPgList;
    });
  }

  void getbookingPGList() async {
    final tempBookingPgList = await AppServices().fetchBookingList();
    setState(() {
      bookingPgList = tempBookingPgList;
    });
  }

  void onChangeBookingStatus({BookingListModel? bookingDetails}) {
    if (bookingDetails == null) return;
    var tempBookingList = List<BookingListModel>.from(
        bookingPgList != null ? bookingPgList! : []);
    setState(() {
      bookingPgList = tempBookingList.map((pg) {
        if (pg.pgDetails?.pgId == bookingDetails.pgDetails?.pgId) {
          return pg.copyWith(
            booked: 'Cancelled',
          );
        }
        return pg;
      }).toList();
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
            localityList: localityList,
            pgList: pgList,
            onTapSave: onTapSavePG,
          ),
          MapScreen(
            locationData: locationData,
            pgList: pgList,
            onTapSave: onTapSavePG,
          ),
          SavedPgScreen(
            savedPgList: savedPgList,
            onTapSavePGInSavedList: onTapSavePGInSavedList,
          ),
          BookingsScreen(
            bookingPgList: bookingPgList,
            onChangeBookingStatus: onChangeBookingStatus,
          ),
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
                if (index == 2) {
                  getSavedPGList();
                }
                if (index == 3) {
                  getbookingPGList();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
