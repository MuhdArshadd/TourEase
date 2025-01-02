import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'business_address_new.dart';
import '../model/business_info.dart';

class PinnedLocationPage extends StatefulWidget {
  final BusinessInfo businessInfo; // Add this line

  const PinnedLocationPage({Key? key, required this.businessInfo}) : super(key: key); // Modify the constructor

  @override
  _PinnedLocationPage createState() => _PinnedLocationPage();
}


class _PinnedLocationPage extends State<PinnedLocationPage> {
  LatLng currentLocation = LatLng(3.68594, 101.52253);
  Marker? tappedMarker;
  String address = '';
  String? street, locality, postalCode;
  double? latitude, longitude;

  void _onMapTapped(LatLng location) {
    setState(() {
      tappedMarker = Marker(
        markerId: MarkerId("tappedLocation"),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
    _getAddressFromLatLng(location);
  }

  //tukar jadi readable address
  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        setState(() {
          street = place.street;
          locality = place.locality;
          postalCode = place.postalCode;
          latitude = location.latitude;
          longitude = location.longitude;
          address = "${place.street}, ${place.locality}, ${place.postalCode}";
        });
      }
    } catch (e) {
      print("Failed to get address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tap on Map to Get Address")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            onTap: _onMapTapped,
            markers: {
              if (tappedMarker != null) tappedMarker!,
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (address.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 10,
              right: 10,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Address: $address",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () { //pass data to model
                print("Latitude before creating BusinessInfo: $latitude");
                print("Longitude before creating BusinessInfo: $longitude");

                if (street != null && locality != null && postalCode != null) {
                  // Update the existing businessInfo with the new coordinates
                  widget.businessInfo.latitude = latitude; // Update latitude
                  widget.businessInfo.longitude = longitude; // Update longitude
                  widget.businessInfo.streetAddress = street!; // Update street address
                  widget.businessInfo.postTown = locality!; // Update post town
                  widget.businessInfo.postCode = postalCode!; // Update postal code


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BusinessAddressNew(businessInfo: widget.businessInfo)
                    ),
                  );
                } else {
                  print('Address details are not complete.');
                }
              },
              child: Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}
