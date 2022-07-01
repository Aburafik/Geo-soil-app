import 'package:flutter/material.dart';
import 'package:geo_app/Services/location_services.dart';
import 'package:intl/intl.dart';

import '../Services/http_services.dart';

class SoilGreenHouseCurrent extends StatefulWidget {
  SoilGreenHouseCurrent({Key? key}) : super(key: key);

  @override
  State<SoilGreenHouseCurrent> createState() => _SoilGreenHouseCurrentState();
}

class _SoilGreenHouseCurrentState extends State<SoilGreenHouseCurrent> {
  Future? getSoilGHCData;
  dynamic getDisplayGHCData;

  HttpServices httpServices = HttpServices();

  LocationService locationService = LocationService();

  double lat = 0;
  double lng = 0;

  ///getUserLocation

  @override
  void initState() {
    locationService.getUserLocation();

    // getUserLocation();

    getSoilGHCData = httpServices.getSoilGHCData().then((value) async {
      setState(() {
        getDisplayGHCData = value;
        print(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Soil Green House Current"),
        ),
        body: getDisplayGHCData?.isEmpty == false
            ? ListView.builder(
                itemCount: getDisplayGHCData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GreenHouseCurrentDataCard(
                          title: "Ozone",
                          value: getDisplayGHCData[index]["ozone"]["value"],
                          date: getDisplayGHCData[index]["ozone"]
                              ["lastUpdated"],
                          units: getDisplayGHCData[index]["ozone"]["units"],
                        ),
                        GreenHouseCurrentDataCard(
                          title: "co2",
                          value: getDisplayGHCData[index]["co2"]["value"],
                          date: getDisplayGHCData[index]["co2"]["lastUpdated"],
                          units: getDisplayGHCData[index]["co2"]["units"],
                        ),
                        GreenHouseCurrentDataCard(
                          title: "ch4",
                          value: getDisplayGHCData[index]["ch4"]["value"],
                          date: getDisplayGHCData[index]["ch4"]["lastUpdated"],
                          units: getDisplayGHCData[index]["ch4"]["units"],
                        ),
                        GreenHouseCurrentDataCard(
                          title: "ch4",
                          value: getDisplayGHCData[index]["ch4"]["value"],
                          date: getDisplayGHCData[index]["ch4"]["lastUpdated"],
                          units: getDisplayGHCData[index]["ch4"]["units"],
                        ),
                        GreenHouseCurrentDataCard(
                          title: "H20",
                          value: getDisplayGHCData[index]["water_vapor"]
                              ["value"],
                          date: getDisplayGHCData[index]["water_vapor"]
                              ["lastUpdated"],
                          units: getDisplayGHCData[index]["water_vapor"]
                              ["units"],
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class GreenHouseCurrentDataCard extends StatelessWidget {
  GreenHouseCurrentDataCard(
      {Key? key, this.date, this.title, this.value, this.units})
      : super(key: key);

  String? title;
  dynamic? value;
  String? date;
  String? units;

  @override
  Widget build(BuildContext context) {
    var dateTime =
        DateFormat(' EEE, d/M/y\n kk:mm').format(DateTime.parse(date!));

    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(10),
          // ignore: sort_child_properties_last
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 25,
                    child: Text("$title"),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Value:${value.toString()} "),
                    Text("Ubits:$units"),
                    Text("Last Updated: $dateTime"),
                  ],
                ),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height / 4,
        ));
  }
}
