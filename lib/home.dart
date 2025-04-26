import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_pro/core/functions/google_map_funtion.dart';
import 'package:google_map_pro/core/model/place_model.dart';
import 'package:google_map_pro/core/model/ploylines_model.dart';
import 'package:google_map_pro/popup_menu_map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapStyleAssets,
    this.isMapTypeEnable = true,
    this.markers,
    this.customIcon,
  });
  final CameraTargetBounds cameraTargetBounds;
  final String? mapStyleAssets;
  final bool isMapTypeEnable;
  final Set<Marker>? markers;
  final BitmapDescriptor? customIcon;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;
  MapType mapType = MapType.normal;
  late CameraPosition cameraPosition;
  @override
  void initState() {
    cameraPosition = CameraPosition(
      target: LatLng(30.71532293022651, 31.252569104755892),
      zoom: 15,
    );
    initPolyline();
    initMark();
    initCircle();
    updateMyLocation();
    super.initState();
  }

  DateTime dateTime = DateTime.now();
  Set<Marker> marks = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  void initMark() async {
    var customIcon = widget.customIcon ??
        await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/marks.png');
    marks = places
        .map((e) => Marker(
              markerId: MarkerId(e.id!),
              position: e.latLng!,
              infoWindow: InfoWindow(
                title: e.name,
                snippet: 'this is a snippet',
              ),
              icon: customIcon,
            ))
        .toSet();
    setState(() {});
  }

  void initPolyline() {
    for (var polyline in polylinesBetweenPoints) {
      polylines.add(
        Polyline(
          polylineId: PolylineId(polyline.id!),
          color: polyline.color!,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          width: polyline.width!,
          points: polyline.points!,
          geodesic: polyline.geodesic,
          zIndex: polyline.zIndex ?? 0,
        ),
      );
    }
    setState(() {});
  }

  void initPolygon() {
    polygons.add(
      Polygon(
        polygonId: PolygonId('1'),
        points: [
          LatLng(30.71532293022651, 31.252569104755892),
          LatLng(30.707779454988223, 31.264642160710654),
          LatLng(30.720379546699473, 31.254547931256575),
        ],
        strokeWidth: 2,
        strokeColor: Colors.yellow,
        fillColor: Colors.red.withOpacity(0.5),
      ),
    );
    setState(() {});
  }

  void initCircle() {
    circles.add(
      Circle(
        circleId: CircleId('1'),
        center: LatLng(30.71532293022651, 31.252569104755892),
        radius: 1000,
        fillColor: Colors.red.withOpacity(0.5),
        strokeWidth: 2,
        strokeColor: Colors.yellow,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  circles: circles,
                  polylines: polylines,
                  polygons: polygons,
                  mapType: mapType,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  trafficEnabled: true, // Enable traffic
                  myLocationEnabled: true,
                  buildingsEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    initMapStyle(
                        mapStyleAssets: widget.mapStyleAssets,
                        mapController: mapController,
                        context: context);
                  },
                  markers: widget.markers ?? marks,
                  initialCameraPosition: cameraPosition,
                  cameraTargetBounds: widget.cameraTargetBounds,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(Icons.my_location, color: Colors.black),
            onPressed: () {
              SizedBox(
                width: 350,
                child: CupertinoCalendar(
                  minimumDateTime: DateTime(2024, 7, 10),
                  maximumDateTime: DateTime(2025, 7, 10),
                  initialDateTime: DateTime(2024, 8, 15, 9, 41),
                  currentDateTime: DateTime(2024, 8, 15),
                  timeLabel: 'Ends',
                  mode: CupertinoCalendarMode.date,
                  type: CupertinoCalendarType.compact,
                ),
              );
              // mapController.animateCamera(
              //   CameraUpdate.newCameraPosition(
              //     CameraPosition(
              //       target: LatLng(30.702768262527847, 31.256936070032804),
              //       zoom: 15,
              //     ),
              //   ),
              // );
              // Utils.showSheet(
              //   context,
              //   child:
              //   onClicked: () {
              //     final value = DateFormat('yyyy/MM/dd').format(dateTime);
              //     Utils.showSnackBar(context, 'Selected "$value"');

              //     Navigator.pop(context);
              //   },
              // );
            },
          ),
          SizedBox(height: 10),
          widget.isMapTypeEnable
              ? PopupMenuMapStyle(
                  items: [
                    'normal'.tr(),
                    'satellite'.tr(),
                    'hybrid'.tr(),
                    'terrain'.tr(),
                    'none'.tr()
                  ],
                  length: 5,
                  onSelected: (value) {
                    if (value == 'normal'.tr()) {
                      mapType = MapType.normal;
                    } else if (value == 'satellite'.tr()) {
                      mapType = MapType.satellite;
                    } else if (value == 'terrain'.tr()) {
                      mapType = MapType.terrain;
                    } else if (value == 'hybrid'.tr()) {
                      mapType = MapType.hybrid;
                    } else if (value == 'none'.tr()) {
                      mapType = MapType.none;
                    }
                    setState(() {});
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
