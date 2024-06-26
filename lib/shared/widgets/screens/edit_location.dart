import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class EditLocation extends StatefulWidget {
  final String? title;
  final double? latitude, longitude;
  final bool getCoordinates ;
  final Function(double, double) onChange;

  const EditLocation(
      {required this.onChange,super.key, this.title, this.getCoordinates=true, this.latitude, this.longitude });

  @override
  State<StatefulWidget> createState() {
    return _EditLocationState();
  }
}

class _EditLocationState extends State<EditLocation> {
  Position? position;

  @override
  void initState() {

    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                (widget.title ?? 'PRECISE LOCATION').toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Iceberg', fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ColorIconButton(
                '',
                Icons.location_on,
                Colors.white,
                borderColor: Theme.of(context).primaryColor,
                iconColor: Theme.of(context).primaryColor,
                iconSize: 40,
              ),
              const SizedBox(height: 20),
              widget.getCoordinates ? Text(
                'GPS LOCATION',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Iceberg', fontWeight: FontWeight.bold),
              ): const SizedBox(),
              const SizedBox(height: 20),
              widget.getCoordinates ? FutureBuilder(
                future: LocationHelper.determinePosition(bestAccuracy: true),
                builder: ((context, snapshot) {
                  var data = snapshot.data;
                  return Text(
                    data == null
                        ? 'Determining location'
                        : 'Lat: ${data.latitude}, Lon: ${data.longitude}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Iceberg', fontWeight: FontWeight.normal),
                  );
                }),
              ):const SizedBox(),
              if(!widget.getCoordinates)Text('Lat: ${widget.latitude}, Lon: ${widget.longitude}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Iceberg', fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              Center(
                  child: AppTextButton(
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      width: 280,
                      label: "CONTINUE",
                      onPressed: () {
                        Navigator.pop(context);
                      })),
            ],
          ),
        ));
  }
}
