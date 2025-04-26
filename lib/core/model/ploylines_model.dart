import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineModel {
  final String? id;
  final List<LatLng>? points;
  final Color? color;
  final int? width;
  final bool geodesic;
  final int? zIndex;
  PolylineModel({
     this.id,
     this.points,
    this.color,
    this.width,
     this.geodesic=false,
    this.zIndex,
  });
}
List<PolylineModel> polylinesBetweenPoints = [
  PolylineModel(
    id: '1',
    points: [
      LatLng(30.71532293022651, 31.252569104755892),
      LatLng(30.707779454988223, 31.264642160710654),
      LatLng(30.720379546699473, 31.254547931256575),
    ],
    color: Colors.blue,
    width: 5,
    geodesic: true,
    zIndex: 1,

  ),
  PolylineModel(
    id: '2',
    points: [
      LatLng(30.71532293022651, 31.252569104755892),
      LatLng(30.707779454988223, 31.264642160710654),
      LatLng(30.720379546699473, 31.254547931256575),
    ],
    color: Colors.blue,
    width: 5,
    geodesic: true,
    zIndex: 2,
  ),
];  