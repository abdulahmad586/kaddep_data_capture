//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:m_pms/resources/resources.dart';
//
// class MapView extends StatelessWidget {
//   LatLng position;
//   double? height, width, radius;
//   final MapController? mapController;
//
//   MapView(this.position, {this.height, this.width, this.radius, this.mapController});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(radius ?? 10))
//       ),
//       child: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           center: position,
//           zoom: 16.0,
//           enableMultiFingerGestureRace: false,
//           interactiveFlags: InteractiveFlag.none
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.lexington.ksf_app',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: position,
//                 builder: (ctx) => Icon(
//                   Icons.location_on,
//                   color: AppColors.primaryColor,
//                   size: 50,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }