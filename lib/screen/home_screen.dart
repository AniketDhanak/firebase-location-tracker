import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_person_demo/latLongModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  GoogleMapController? mapController;
  List<LatLongResponseModel> latLongList = [];
  late DatabaseReference databaseReference;
  String databaseData = "";

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.5590, 73.7868),
    zoom: 12,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();

    databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.child('MapData').onValue.listen((event) {
      log("event: ${event.snapshot.value}");
      DataSnapshot dataSnap = event.snapshot;
      log("Aniket: ${dataSnap.value.toString()}");
      latLongList.clear();
      setState(() {
        for (var element in dataSnap.children) {
          latLongList.add(LatLongResponseModel(lat: element.child('lat').value.toString(), long: element.child('long').value.toString()));
        }
        for(int i = 0 ; i<latLongList.length; i++){
          _addMarker(0, double.parse(latLongList[0].lat), double.parse(latLongList[0].long));
          changePosition(double.parse(latLongList[0].lat), double.parse(latLongList[0].long));
        }
        log("count: ${latLongList.length}");

      });
    });
  }

  _addMarker(dynamic id, double lat, double long) {
    log("Add marker: $id");
    final MarkerId markerId = MarkerId('Marker $id');
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: 'test'),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  changePosition(lat, long) {
    mapController!
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 18));
    _addMarker(0, lat, long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                markers: Set.of(markers.values),
                zoomControlsEnabled: false,
                // zoomGesturesEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  _controller.complete(controller);
                },
              ),
            ),
            Text("Google MAP",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black
              ),),
          ],
        ),
      ),
    );
  }
}
