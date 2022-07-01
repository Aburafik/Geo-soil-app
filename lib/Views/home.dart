
import 'package:flutter/material.dart';
import 'package:geo_app/Services/http_services.dart';
import 'package:geo_app/Services/location_services.dart';
import 'package:geo_app/Views/soil_green_house_%20current_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future? getSoilData;
  dynamic? getDisplaySoilData;

  HttpServices httpServices = HttpServices();

  LocationService locationService = LocationService();

  double lat = 0;
  double lng = 0;

  ///getUserLocation

  @override
  void initState() {
    locationService.getUserLocation();

    // getUserLocation();

    getSoilData = httpServices.getSoilData().then((value) async {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        getDisplaySoilData = value;

        lat = prefs.getDouble("lat")!;
        lng = prefs.getDouble("lng")!;
      });

      print(lat);
      print(lng);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("GEO- SOIL APP"),
        ),
        body: getDisplaySoilData?.isEmpty == false
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<List<Placemark>>(
                        future: placemarkFromCoordinates(lat, lng),
                        builder: (context, snapshot) {
                          final data = snapshot.data ?? [];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              Text(
                                data.isEmpty ? 'N/A' : '${data[0].name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          );
                        }),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Soil Moisture: ${getDisplaySoilData[0]["soil_moisture"].round().toString()}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Soil Temperature: ${getDisplaySoilData[0]["soil_temperature"]}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Text(
                                "Scantime: ${getDisplaySoilData[0]["scantime"]}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.teal),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SoilGreenHouseCurrent()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "GET SOIL GHC",
                                style: TextStyle(color: Colors.white),
                              ),
                            ))),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
