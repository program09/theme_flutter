import 'package:flutter/material.dart';
import 'package:ui/widgets/forms/options.dart';
import 'package:ui/widgets/layouts/tabs.dart';

class ProfileExample extends StatefulWidget {
  final Map<String, dynamic>? data;
  final GlobalKey<TabsUIState> keytab;
  final String tabId;
  const ProfileExample({
    super.key,
    this.data,
    required this.keytab,
    required this.tabId,
  });

  @override
  State<ProfileExample> createState() => ProfileExampleState();
}

class ProfileExampleState extends State<ProfileExample> {
  void save() {
    print('Guardando Tab de Perfil...');
  }

  Future<List<Option>> getOptionssdf() async {
    return [
      Option(value: '1', label: 'Option 1 perfil'),
      Option(value: '2', label: 'Option 2 perfil'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile'));
  }
}
