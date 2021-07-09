import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelector extends StatefulWidget {
  static const ROUTE = "map_selector";
  final LatLng initLatLang;
  final markerId = MarkerId("my_marker");

  MapSelector(this.initLatLang);

  @override
  _MapSelectorState createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  Marker marker;
  GoogleMapController controller;

  @override
  void initState() {
    marker = widget.initLatLang == null
        ? null
        : Marker(markerId: widget.markerId, position: widget.initLatLang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        centerTitle: true,
        actions: [
          marker == null
              ? SizedBox()
              : IconButton(
                  onPressed: () => _confirmMap(context),
                  icon: Icon(
                    Icons.check,
                  ),
                ),
        ],
      ),
      body: GoogleMap(
        markers: marker == null ? {} : {marker},
        onTap: _mapTapped,
        compassEnabled: true,
        onMapCreated: makeController,
        initialCameraPosition: CameraPosition(
          target: widget.initLatLang == null
              ? LatLng(30.0444, 31.2357)
              : widget.initLatLang,
          zoom: 15,
        ),
      ),
    );
  }

  void makeController(GoogleMapController controller) {
    this.controller = controller;
  }

  _mapTapped(LatLng location) async {
    setState(() {
      marker = Marker(markerId: widget.markerId, position: location);
    });
    if (controller != null)
      await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15,
        ),
      ));
  }

  void _confirmMap(BuildContext context) {
    if (marker != null) Navigator.of(context).pop(marker.position);
  }
}
