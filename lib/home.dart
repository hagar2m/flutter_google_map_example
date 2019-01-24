import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;
  String searchAddress;
  int _markerCount = 0;
  LatLng _centerPosition = const LatLng(31.2240349, 29.8148008);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google map'),
      ),
      body: Stack(
        children: <Widget>[
          // map //
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _centerPosition,
              zoom: 10.0,
            ),
          ),

          // search input //
          Positioned(
            top: 20.0,
            right: 20.0,
            left: 20.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search for Address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchAndNavigate,
                        iconSize: 30.0)),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => searchAndNavigate(),
                onChanged: (val) {
                  setState(() {
                    searchAddress = val;
                  });
                },
              ),
            ),
          ),

          // add marker button//
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              onPressed: addMarkerPressed,
              child: Text('Add Marker'),
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) {
      print('result of search address: ${result.toString()}');
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });
  }

  addMarkerPressed() {
    mapController.addMarker(MarkerOptions(
      draggable: false,
      position: LatLng(
        _centerPosition.latitude, 
        _centerPosition.longitude, 
      ),
      infoWindowText: InfoWindowText('Marker', '**'),
    ));
  }
}
