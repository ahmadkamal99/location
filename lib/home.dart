import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyChxPcKJNl3hWkFIwxywbP2U8MNyshUIcQ";
  var myMarkers = HashSet<Marker>();
  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(
        LatLng(31.963158, 35.930359), "origin", BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(30.328960, 35.444832), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.location_on))
      ]),
      body: Stack(children: [
        GoogleMap(
          polylines: Set<Polyline>.of(polylines.values),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(31.963158, 35.930359),
              tilt: 59.440717697143555,
              zoom: 10),
          onMapCreated: (GoogleMapController googleMapController) {
            setState(() {
              myMarkers.add(
                Marker(
                    infoWindow: InfoWindow(
                        title: 'Welcome to petra',
                        snippet: 'visit us to enjoy'),
                    markerId: MarkerId('1'),
                    position: LatLng(30.328960, 35.444832)),
              );
            });
          },
          markers: myMarkers,
        ),
      ]),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        width: 2,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(31.963158, 35.930359),
        PointLatLng(30.328960, 35.444832),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {});
    }

    polylineCoordinates.add(LatLng(31.963158, 35.930359));
    polylineCoordinates.add(LatLng(30.328960, 35.444832));
    _addPolyLine();
  }
}
