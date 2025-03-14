import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/package_provider.dart';
import 'package:construction_store_mobile_app/views/ui/package_detail_page.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Packages")),
      body: Consumer<PackageProvider>(
        builder: (context, packageProvider, child) {
          final packages = packageProvider.packages;

          if (packages.isEmpty) {
            return const Center(child: Text("No packages saved yet."));
          }

          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return ListTile(
                title: Text(package['name']),
                subtitle: Text("${package['items'].length} items"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, package['key']);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackageDetailPage(package: package),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String packageKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Package"),
          content: const Text("Are you sure you want to delete this package?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PackageProvider>(
                  context,
                  listen: false,
                ).deletePackage(packageKey);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
