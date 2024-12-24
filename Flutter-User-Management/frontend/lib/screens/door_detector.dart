import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(LaunchUnityAppButton());
}


class LaunchUnityAppButton extends StatelessWidget {
  const LaunchUnityAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Show Unity Apps'),
      onPressed: () async {
        final apps = await DeviceApps.getInstalledApplications(
          includeAppIcons: true,
          includeSystemApps: false,
        );
        final unityApps = apps
            .where((app) => app.packageName.startsWith('com.DefaultCompany'))
            .toList();

        print('Found ${unityApps.length} Unity apps');

        if (unityApps.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Unity apps found')),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select Unity App'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: unityApps.length,
                    itemBuilder: (BuildContext context, int index) {
                      Application app = unityApps[index];
                      return ListTile(
                        leading: app is ApplicationWithIcon
                            ? Image.memory(app.icon)
                            : const Icon(Icons.android),
                        title: Text(app.appName),
                        onTap: () {
                          Navigator.of(context).pop();
                          DeviceApps.openApp(app.packageName);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
