// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:m_pms/resources/resources.dart';
// import 'package:m_pms/utils/location_utils.dart';
// import 'dart:convert';
// import 'package:latlong2/latlong.dart';
//
// import 'package:m_pms/utils/utils.dart';
// import 'package:m_pms/view/widgets/widgets.dart';
//
// class MapBrowser extends StatefulWidget {
//   @override
//   _MapBrowserState createState() => _MapBrowserState();
// }
//
// class _MapBrowserState extends State<MapBrowser> {
//   // Define the controller for the map
//   final MapController mapController = MapController();
//
//   // Define a list to hold the search results
//   List<SearchResult> searchResults = [];
//   LatLng initialPosition = LatLng(12.002,  8.5920);// Kano, Nigeria
//   LatLng userPosition = LatLng(12.002,  8.5920);// Kano, Nigeria
//
//   @override
//   void initState() {
//     getUserPosition();
//     super.initState();
//   }
//
//   void getUserPosition(){
//     LocationHelper.determinePosition(bestAccuracy: true).then((position){
//       userPosition = LatLng(position.latitude, position.longitude);
//       if(mounted){
//         setState(() {
//         });
//       }
//       mapController.move(userPosition, mapController.zoom);
//     }).catchError((e){
//       Alert.message(context,title: "Unable to determine position", message: e.toString(), error: true);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton.small(
//             onPressed: (){
//             getUserPosition();
//           },
//             heroTag: 'current location fab',
//             backgroundColor: AppColors.primaryColor,
//             child:const Icon(Icons.gps_fixed),
//           ),
//           const SizedBox(width: 20,),
//           FloatingActionButton(onPressed: (){
//             Navigator.pop(context, mapController.center);
//           },
//             child:const Icon(Icons.done),
//             heroTag: 'done fab',
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   FlutterMap(
//                     mapController: mapController,
//                     options: MapOptions(
//                       center: initialPosition,
//                       zoom: 15.0,
//                     ),
//                     children: [
//                       TileLayer(
//                         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                         userAgentPackageName: 'com.lexington.ksf_app',
//                       ),
//                       MarkerLayer(
//                         markers: [
//                           Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: userPosition,
//                             builder: (ctx) => Icon(
//                               Icons.location_on,
//                               color: AppColors.primaryColor,
//                               size: 50,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   // Expanded(child:
//                   Align(alignment: Alignment.topCenter,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(height:10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           AppIconButton(
//                             backgroundColor: Colors.white.withAlpha(230),
//                             icon: Icons.clear,
//                             onTap: (){
//                               Navigator.pop(context);
//                             },
//                           ),
//                           AppSearchField(
//                             widthPercentage: 85,
//                             fillColor: Colors.white.withAlpha(230),
//                             hintText: "Search places...",
//                             suffixIcon: Icon(Icons.search),
//                             loader: (String str) async {
//                               return searchPlaces(str);
//                             },
//                             itemBuilder: (context, item){
//                               SearchResult result= item as SearchResult;
//                               return ListTile(
//                                 title: Text(result.displayName),
//                                 subtitle: Text('${result.lat}, ${result.lon}'),
//
//                               );
//                             },
//                             onSuggestionSelected: (suggestion){
//                               SearchResult result = suggestion as SearchResult;
//                                 mapController.move(LatLng(result.lat,result.lon), mapController.zoom);
//
//                             },
//                           ),
//                         ],
//                       )
//                     ],
//                   )
//                   // )
//                   ),
//                   Icon(
//                     Icons.location_on,
//                     color: AppColors.accentColor,
//                     size: 50,
//                   ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Timer? canceller;
//   void debouncer(Duration delay,Function fn) {
//     if (canceller?.isActive ?? false) canceller?.cancel();
//     canceller = Timer(delay, () {
//       fn();
//     });
//   }
//
//   // Define the function to search for places
//   Future<List<SearchResult>> searchPlaces(String query) async {
//     Completer<List<SearchResult>> completer = Completer();
//     debouncer(Duration(milliseconds: 500), ()async{
//       String apiUrl =
//           'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5&country=Nigeria&countrycodes=ng&state=Kano';
//       http.Response response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         print(response.body);
//         List<dynamic> data = jsonDecode(response.body);
//         var result= data.map((result) => SearchResult.fromJson(result)).toList();
//         return completer.complete(result);
//       }
//       return completer.complete([]);
//     });
//     return completer.future;
//   }
// }
//
// // Define a model for the search results
// class SearchResult {
//   final String displayName;
//   final double lat;
//   final double lon;
//
//   SearchResult({
//     required this.displayName,
//     required this.lat,
//     required this.lon,
//   });
//
//   factory SearchResult.fromJson(Map<String, dynamic> json) {
//     print(json);
//     return SearchResult(
//       displayName: json['display_name'],
//       lat: double.parse(json['lat']),
//       lon: double.parse(json['lon']),
//     );
//   }
// }
