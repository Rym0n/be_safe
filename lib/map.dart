import 'dart:async';

import 'package:be_safe/get_place_name.dart';
import 'package:be_safe/location_service.dart';
import 'package:be_safe/side_bar/side_bar_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MyMapWidget extends StatefulWidget {
  const MyMapWidget({super.key});
  @override
  _MyMapWidgetState createState() => _MyMapWidgetState();
}

class _MyMapWidgetState extends State<MyMapWidget> {
  GoogleMapController? mapController;
  LocationData? currentLocation;
  final TextEditingController _searchController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String cityText = '';
  String eventDescription = '';
  String eventType = 'Dangerous person';
  String placeName = '';
  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadMarkersFromFirebase();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _loadMarkersFromFirebase();
    });
  }

// GET LOCATION
  void _getLocation() async {
    try {
      Location location = Location();
      LocationData userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.7592, 19.4559),
    zoom: 10,
  );

//GET MARKERS
  Future<void> getMarkers(
      double lat,
      double long,
      String placeName,
      String eventType,
      String description,
      DateTime timestamp,
      String documentId) async {
    MarkerId markerId = MarkerId(documentId);
    BitmapDescriptor markerIcon;
    switch (eventType) {
      case 'Theft':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        break;
      case 'Fighting':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        break;
      case 'Dangerous person':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
        break;
      case 'Accident':
        markerIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        break;
      default:
        markerIcon = BitmapDescriptor.defaultMarker;
    }

    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: markerIcon,
      onTap: () {
        _showMarkerDetailsDialog(
            markerId, placeName, eventType, lat, long, description, timestamp);
      },
    );

    setState(() {
      markers[markerId] = _marker;
    });
  }

  //MARKER DIALOG

  void _showMarkerDetailsDialog(
      MarkerId markerId,
      String placeName,
      String eventType,
      double lat,
      double long,
      String description,
      DateTime timestamp) {
    DateTime localTimestamp = timestamp.toLocal().add(const Duration(hours: 1));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(placeName,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Event Type: $eventType',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text(
                  'Description: $description',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Text(
                  'Created at: ${DateFormat('HH:mm').format(localTimestamp)}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => _updateMarkerTime(markerId, 30),
              child: const Icon(Icons.thumb_up, color: Colors.green),
            ),
            TextButton(
              onPressed: () => _deleteMarker(markerId),
              child: const Icon(Icons.thumb_down, color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  void _deleteMarker(MarkerId markerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('location')
          .doc(markerId.value)
          .delete();
      print("Marker successfully deleted from Firebase: ${markerId.value}");

      // Aktualizacja stanu aplikacji
      setState(() {
        markers.remove(markerId); // Usuwanie markera z mapy
      });
    } catch (error) {
      print("Error deleting marker: $error");
    }
  }

  void _updateMarkerTime(MarkerId markerId, int minutesToAdd) async {
    var docRef =
        FirebaseFirestore.instance.collection('location').doc(markerId.value);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      if (minutesToAdd > 0) {
        var data = docSnapshot.data();
        data!['timestamp'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance.collection('location').add(data);
      }

      _deleteMarker(markerId);
    }
  }

  //ADD EVENT

  Future<void> showAddEventDialog(
      BuildContext context, LatLng tappedPoint, String placeName) async {
    String tempEventType = eventType;
    String tempEventDescription = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add event'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        tempEventDescription = value;
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter event description"),
                    ),
                    DropdownButton<String>(
                      value: tempEventType,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          tempEventType = newValue!;
                        });
                      },
                      items: <String>[
                        'Theft',
                        'Fighting',
                        'Dangerous person',
                        'Accident'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add Event'),
                  onPressed: () {
                    addEventToFirebase(tappedPoint, tempEventDescription,
                        tempEventType, placeName);
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  //ADD MARKER TO FIREBASE

  void addEventToFirebase(LatLng location, String description, String type,
      String placeName) async {
    print('Adding event to Firebase...');
    try {
      var docRef = await FirebaseFirestore.instance.collection('location').add({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'placeName': placeName,
        'description': description,
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
      });

      var docSnapshot = await docRef.get();
      var timestamp = (docSnapshot.data()!['timestamp'] as Timestamp).toDate();
      getMarkers(location.latitude, location.longitude, placeName, type,
          description, timestamp, docRef.id);
      print('Event added to Firebase with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding event to Firebase: $e');
    }
  }

  //LOAD MARKERS FROM DATABASE

  void _loadMarkersFromFirebase() async {
    var currentTime = DateTime.now();
    var querySnapshot =
        await FirebaseFirestore.instance.collection('location').get();

    setState(() {
      markers.clear();
    });

    for (var doc in querySnapshot.docs) {
      var timestamp = doc.data()['timestamp'] as Timestamp;
      var markerTime = timestamp.toDate();

      if (currentTime.difference(markerTime).inMinutes <= 30) {
        double lat = doc.data()['latitude'];
        double long = doc.data()['longitude'];
        String placeName = doc.data()['placeName'];
        String eventType = doc.data()['type'];
        String description = doc.data()['description'] ?? 'No description';
        DateTime timestamp = (doc.data()['timestamp'] as Timestamp).toDate();
        String documentId = doc.id;

        await getMarkers(lat, long, placeName, eventType, description,
            timestamp, documentId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(cityText: cityText, onInfoPressed: onInfoPressed),
      appBar: AppBar(
        title: const Text(
          "BESAFE",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 25.0,
            fontFamily: "Oswald",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 226, 222, 205),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                //search bar
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'City name'),
                onChanged: (value) {
                  print(value);
                },
              )),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_searchController.text);
                  _goToPlace(place);
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              onTap: (LatLng tapped) async {
                placeName =
                    await getPlaceName(tapped.latitude, tapped.longitude);
                // final coordinated = new geoCo.Coordinates(
                //           tapped.latitude, tapped.longitude);
                //       var adrress = await geoCo.Geocoder.local
                //           .findAddressesFromCoordinates(coordinated);
                //       var firstAddress = adrress.first;
                // await FirebaseFirestore.instance.collection('location').add({
                //   'latitude': tapped.latitude,
                //   'longitude': tapped.longitude,
                //   'placeName': placeName,
                //   'timestamp': FieldValue.serverTimestamp(),
                //   // 'Address' : tapped.
                // });
                if (!mounted) return;
                await showAddEventDialog(context, tapped, placeName);

                //getMarkers(
                //tapped.latitude, tapped.longitude, placeName, eventType);
              },
              markers: Set<Marker>.of(markers.values),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final String cityName = place['name'];
    print(cityName);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
    var cityInfo = await FirebaseFirestore.instance
        .collection('city_info')
        .doc(cityName)
        .get();
    var newCityText = cityInfo.data()?['info'] ?? 'No data available.';

    setState(() {
      cityText = newCityText;
    });
  }

  void onInfoPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informations about your city"),
          content: Text(cityText),
          actions: <Widget>[
            TextButton(
              child: const Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
