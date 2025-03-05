import 'dart:developer';

import 'package:edt/pages/home/provider/location_provider.dart';
import 'package:edt/pages/home/widgets/bottom_sheet.dart';
import 'package:edt/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class SearchLocation extends StatefulWidget {
  final String? locationType;

  const SearchLocation({super.key, this.locationType});

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final TextEditingController _searchController = TextEditingController();
  List<PlaceSearchResult> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    if (widget.locationType == 'From') {
      var locPro = Provider.of<LocationProvider>(context, listen: false);
      _searchController.text = locPro.currentAddress ?? ''; 
    } else if (widget.locationType == 'To') {
      var locPro = Provider.of<LocationProvider>(context, listen: false);
      _searchController.text = locPro.selectedAddress ?? '';
    }
  }

  Future<void> _onSearchChanged() async {
    if (_searchController.text.length < 3) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results =
          await PlacesService().searchPlaces(_searchController.text);
      setState(() => _searchResults = results);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onPlaceSelected(PlaceSearchResult place) async {
  var locPro = Provider.of<LocationProvider>(context, listen: false);
  final details = await PlacesService().getPlaceDetails(place.placeId);
  
  if (details != null) {
    String address = details.address;
    double latitude = details.latitude;
    double longitude = details.longitude;
    LatLng selectedLatLng = LatLng(latitude, longitude);

    log('I SEARCHED THE LOACTION HERE $latitude $longitude');

    if (widget.locationType == 'From') {
      locPro.currentAddress = address;
      locPro.currentLatitude = latitude;
      locPro.currentLongitude = longitude;
      locPro.currentLocation = selectedLatLng;
    } else if (widget.locationType == 'To') {
      locPro.selectedAddress = address;
      locPro.selectedLatitude = latitude;
      locPro.selectedLongitude = longitude;
      locPro.selectedLocation = selectedLatLng;
    } else {
      locPro.selectedAddress = address;
      locPro.selectedLatitude = latitude;
      locPro.selectedLongitude = longitude;
      locPro.selectedLocation = selectedLatLng;
    }

    // log('SELECTED LAT LNG ISS $selectedLatLng');
    // log('SELECTED LAT LNG OF PASSEGER ISS ${locPro.currentLatitude} ${locPro.currentLongitude}');
    // log('SELECTED LAT LNG OF DRIVER ISS ${locPro.selectedLatitude} ${locPro.selectedLongitude}');
    Navigator.pop(context, details);
    bottomSheet(context, locPro);
  }
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffe7f0fc),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset('assets/icons/map.svg'),
                      ),
                      hintText: 'Search Location',
                      hintStyle: GoogleFonts.poppins(
                        color: Color(0xffb8b8b8),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xff000000), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: SvgPicture.asset('assets/icons/close.svg'),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else if (_searchResults.isEmpty &&
                    _searchController.text.isNotEmpty)
                  _buildNotFound()
                else
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      return IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => _onPlaceSelected(place),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('assets/icons/clock.svg'),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place.mainText,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xff5a5a5a),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        place.secondaryText,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xffb8b8b8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Image.asset('assets/images/not_found.png'),
        SizedBox(height: 10),
        Text(
          'Not Found',
          style: GoogleFonts.poppins(
            color: Color(0xff5a5a5a),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sorry, the keyword you entered cannot be found, please check again or search with another keyword.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Color(0xffb8b8b8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}