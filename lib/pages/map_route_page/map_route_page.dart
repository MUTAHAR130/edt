import 'package:edt/pages/home/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps Route")),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return locationProvider.currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: locationProvider.currentLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId("current"),
                      position: locationProvider.currentLocation!,
                    ),
                    if (locationProvider.selectedLocation != null)
                      Marker(
                        markerId: MarkerId("selected"),
                        position: locationProvider.selectedLocation!,
                      ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: PolylineId("route"),
                      points: locationProvider.polylineCoordinates,
                      color: Colors.blue,
                      width: 5,
                    ),
                  },
                  // onTap: (LatLng latLng) {
                  //   locationProvider.setSelectedLocation(latLng);
                  // },
                );
        },
      ),
    );
  }
}
