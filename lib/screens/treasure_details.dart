import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure/models/categories.dart';
import 'package:treasure/models/treasure_model.dart';
import 'package:treasure/services/treasure_service.dart';

class TreasureDetails extends StatelessWidget {
  static const ROUTE = "treasure_details_route";
  final TreasureModel model;
  final _treasureService = TreasureService();

  TreasureDetails(this.model);

  @override
  Widget build(BuildContext context) {
    _treasureService.setTreasureSeenByCurrentUser(model.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        centerTitle: true,
      ),
      body: ListView(children: [
        _buildImageSlider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Text(
            model.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 34),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RawChip(
              avatar: CircleAvatar(
                backgroundImage: NetworkImage(
                  categoryImage(model.category),
                ),
              ),
              label: Text(categoryLabel(model.category)),
            ),
            Row(
              children: [
                Icon(Icons.history),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.sinceFormatted()),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.remove_red_eye),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.viewersIds.length.toString()),
                ),
              ],
            ),
          ],
        ),
        model.location == null
            ? SizedBox()
            : Container(
          padding: EdgeInsets.only(top: 16,left: 16,right: 16),
          height: 150,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: GoogleMap(
              markers: {
                Marker(
                    markerId: MarkerId("my_marker"),
                    position: model.location)
              },
              liteModeEnabled: true,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                target: model.location,
                zoom: 15,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                model.desc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildImageSlider() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CarouselSlider(
        options: CarouselOptions(
            height: 300, enableInfiniteScroll: false, enlargeCenterPage: true),
        items: model.imagesURLS.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void onPressButton() async {}
}
