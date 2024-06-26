import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class LocationPicker extends StatefulWidget {
  LocationPicker({
    this.latitude = 0,
    this.longitude = 0,
    this.onChange,
    this.title,
    this.refreshCoordinates = false,
    Key? key,
  }) : super(key: key);

  final Function(
      {
      double longitude,
      double latitude})? onChange;
  final String? title;
  final bool refreshCoordinates;
  double latitude;
  double longitude;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Position? position;
  String? error;

  @override
  void initState() {
    print("Getting location ${widget.latitude}");
    if(widget.latitude!=0){
      position = Position(longitude: widget.longitude, latitude: widget.latitude, timestamp: DateTime.now(), accuracy: 0.0, altitude: 0.0, altitudeAccuracy: 0.0, heading: 0.0, headingAccuracy: 0.0, speed: 0.0, speedAccuracy: 0.0);
    }else{
      determineLocation();
    }
    super.initState();
  }

  void determineLocation(){
    if(position?.latitude != 0 && widget.refreshCoordinates){
      return;
    }
    LocationHelper.determinePosition(bestAccuracy: true).then((value) {
      if(mounted){
        setState(() {
          position = value;
        });
        widget.onChange?.call(longitude:value.longitude, latitude:value.latitude);
      }
    }).catchError((err){
      if(mounted){
        setState(() {
          error = err.toString();
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GenericListItem(
        onPressed: () {
          openEditor();
        },
        verticalPadding: 5,
        leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
        label: position == null ? "Determining location" : 'Lat: ${position!.latitude}, Lon: ${position!.longitude}',
        desc: error ?? 'Precise location',
        trailing: IconButton(
            onPressed: () {
              openEditor();
            },
            icon: Icon(
              error != null ? Icons.info : (position == null ? Icons.more_horiz : Icons.verified),
              color: error != null ? Colors.red : (position == null ? Theme.of(context).primaryColor : Colors.green),
            )),
      ),
    );
  }

  void openEditor() {
    Alert.showModal(context, EditLocation(getCoordinates: widget.refreshCoordinates, latitude: widget.latitude, longitude: widget.longitude, title:widget.title ?? 'Your Location',onChange: ( double latitude, double longitude) {
      setState(() {
        widget.latitude = latitude;
        widget.longitude = longitude;
      });
      if (widget.onChange != null) {
        widget.onChange!(
            latitude: latitude,
            longitude: longitude);
      }
    }));
  }
}
