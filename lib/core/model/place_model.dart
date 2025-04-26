import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final String? id;
  final String? name;
  final LatLng? latLng;
  PlaceModel({this.id, this.name, this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
    id: '1',
    name: 'نادي ميت غمر الرياضي',
    latLng: LatLng(30.71532293022651, 31.252569104755892),
  ),
  PlaceModel(
    id: '2',
    name: 'إدارة المرور - ميت غمر',
    latLng: LatLng(30.707779454988223, 31.264642160710654),
  ),
  PlaceModel(
    id: '3',
    name: 'رنين - ميت غمر',
    latLng: LatLng(30.720379546699473, 31.254547931256575),
  ),
];
