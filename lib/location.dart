import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';

List<Coordinates> coordinatesList = [];

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);
}

class LocationTracker extends StatefulWidget {
  const LocationTracker({Key? key}) : super(key: key);

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildListView(), // Display the list of coordinates
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    // Load the list of coordinates from local storage
    _loadCoordinatesList();

    return ListView.builder(
      itemCount: coordinatesList.length,
      itemBuilder: (context, index) {
        final coordinates = coordinatesList[index];
        return ListTile(
          title: Text('Latitude: ${coordinates.latitude}'),
          subtitle: Text('Longitude: ${coordinates.longitude}'),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Start a timer that adds coordinates every 1 minute
    Timer.periodic(Duration(minutes: 1), (Timer timer) {
      _getLocation().then((position) {
        if (position != null) {
          setState(() {
            coordinatesList
                .add(Coordinates(position.latitude, position.longitude));
            _saveCoordinatesList();
          });
        } else {
          print("Error getting location");
        }
      });
    });
  }

  Future<Position?> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      return position;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  void _loadCoordinatesList() {
    final getStorage = GetStorage();
    final savedList = getStorage.read<List>('coordinatesList');

    if (savedList != null) {
      setState(() {
        coordinatesList = savedList.map((coords) {
          return Coordinates(
            coords['latitude'] as double,
            coords['longitude'] as double,
          );
        }).toList();
      });
    }
  }

  void _saveCoordinatesList() {
    final getStorage = GetStorage();
    final coordsList = coordinatesList.map((coords) {
      return {'latitude': coords.latitude, 'longitude': coords.longitude};
    }).toList();

    getStorage.write('coordinatesList', coordsList);
  }
}