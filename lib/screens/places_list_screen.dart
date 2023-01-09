import 'package:flutter/material.dart';
import 'package:places_app/providers/great_places_provider.dart';
import 'package:places_app/screens/add_place_screen.dart';
import 'package:places_app/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: Icon(
              Icons.add_outlined,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<GreatPlacesProvider>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<GreatPlacesProvider>(
              child: const Center(
                child: Text('Got no places yet, start adding some!'),
              ),
              builder: (ctx, greatPlacesData, ch) {
                return greatPlacesData.items.isEmpty
                    ? ch!
                    : ListView.builder(
                        itemCount: greatPlacesData.items.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(greatPlacesData.items[index].image),
                            ),
                            title: Text(greatPlacesData.items[index].title),
                            subtitle: Text(greatPlacesData
                                .items[index].location!.address!),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PlaceDetailsScreen.routeName,
                                arguments: greatPlacesData.items[index].id,
                              );
                            },
                          );
                        },
                      );
              },
            );
          }),
    );
  }
}
