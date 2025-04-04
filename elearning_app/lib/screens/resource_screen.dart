import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String resourcesContent = 'Loading resources...';

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    try {
      final content =
          await rootBundle.loadString('assets/literacy_resources.txt');
      setState(() {
        resourcesContent = content;
      });
    } catch (e) {
      setState(() {
        resourcesContent = 'Error loading resources: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourcesList = resourcesContent.split('\n\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Literacy Resources'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: resourcesList.length,
          itemBuilder: (context, index) {
            final resource = resourcesList[index].trim();
            if (resource.isEmpty) return const SizedBox.shrink();
            final lines = resource.split('\n');
            final title = lines[0];
            final body = lines.sublist(1).join('\n');
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      body,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
