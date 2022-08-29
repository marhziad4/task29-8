import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_emp/providers/location_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),

      ),
      body: Consumer<LocationProvider>(
        builder: (
            BuildContext context,
            LocationProvider provider,
            Widget? child,
            ) {
          if (provider.locations.isNotEmpty) {
            return ListView.builder(
              itemCount: provider.locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.category),
                  title: Text(provider.locations[index].latitude??''),
                  subtitle: Text(provider.locations[index].id.toString()),
                  trailing: IconButton(
                    onPressed: () async{
                      await Provider.of<LocationProvider>(context, listen: false).delete(id: provider.locations[index].id);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 80,
                    color: Colors.grey.shade500,
                  ),
                  Text(
                    'NO DATA',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

}
