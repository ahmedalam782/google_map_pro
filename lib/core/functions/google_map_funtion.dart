import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Future<Uint8List> getImageFromRawData(String image,
    {double? width, double? height}) async {
  ByteData data = await rootBundle.load(image);
  final ui.Codec imageCode = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width?.round(),
    targetHeight: height?.round(),
  );
  final ui.FrameInfo frameInfo = await imageCode.getNextFrame();
  final ui.Image uiImage = frameInfo.image;
  final ByteData? byteData =
      await uiImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List bytes = byteData!.buffer.asUint8List();
  return bytes;
}

Future<void> initMapStyle(
    {required String? mapStyleAssets,
    required GoogleMapController? mapController,
    required BuildContext context}) async {
  if (mapStyleAssets != null) {
    var googleMapStyle =
        await DefaultAssetBundle.of(context).loadString(mapStyleAssets);
    mapController!.setMapStyle(googleMapStyle);
  } else {
    var googleMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_json_style/map_style.json');
    mapController!.setMapStyle(googleMapStyle);
  }
}

late Location location;
Future<void> checkAndRequestLocationService() async {
  location = Location();
  // Check if location services are enabled
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    // Request to enable location services
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      // Location services are still not enabled, handle accordingly
      return;
    }
  }
}

Future<bool> checkAndRequestLocationPermission() async {
  // Check if location permission is granted
  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    // Request location permission
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      // Location permission is still not granted, handle accordingly
      return false;
    }
  }
  // Location permission is granted
  if (permissionGranted == PermissionStatus.deniedForever) {
    // Location permission is denied forever, handle accordingly
    return false;
  }
  // Location permission is granted
  return true;
}

Future<void> getCurrentLocation() async {
  // Get the current location
  location.onLocationChanged.listen((LocationData currentLocation) async {
    // Handle the current location data
    var cameraPosition = CameraPosition(
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      zoom: 15,
    );
    //  mapController
    //     ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // Update the map camera position
  });
}

void updateMyLocation() async {
  await checkAndRequestLocationService();
  bool isPermissionGranted = await checkAndRequestLocationPermission();
  if (isPermissionGranted) {
    await getCurrentLocation();
  }
}

class Utils {
  static void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoActionSheetAction(
                onPressed: onClicked,
                child: Text('ok'),
              ),
               CupertinoActionSheetAction(
                child: Text('cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            
            ],
          ),
        ),
      );

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 24)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
