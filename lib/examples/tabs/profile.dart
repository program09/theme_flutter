import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ui/widgets/components.dart';
import 'package:ui/widgets/forms.dart';

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
    log('Guardando Tab de Perfil...');
  }

  Future<List<Option>> getOptionssdf() async {
    return [
      Option(value: '1', label: 'Option 1 perfil'),
      Option(value: '2', label: 'Option 2 perfil'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Solid Badges',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildBadgeRow(StyleBadge.solid),

        const SizedBox(height: 32),
        const Text(
          'Mica Badges',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildBadgeRow(StyleBadge.mica),

        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 32),

        const Text(
          'Solid Buttons',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildButtonRow(StyleBtn.solid),

        const SizedBox(height: 32),
        const Text(
          'Outline Buttons',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildButtonRow(StyleBtn.outline),

        const SizedBox(height: 32),
        const Text(
          'Mica Buttons',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildButtonRow(StyleBtn.mica),

        const SizedBox(height: 32),
        const Text(
          'Text Buttons',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildButtonRow(StyleBtn.text),
      ],
    );
  }

  Widget _buildButtonRow(StyleBtn style) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        /// boton all width
        BtnUI(
          fullWidth: true,
          text: 'Primary',
          type: TypeBtn.primary,
          style: style,
          onPressed: () {},
          onLongPress: () {
            log('Long Press');
          },
        ),
        BtnUI(
          text: 'Secondary',
          type: TypeBtn.secondary,
          style: style,
          onPressed: () {},
        ),
        BtnUI(text: 'Info', type: TypeBtn.info, style: style, onPressed: () {}),
        BtnUI(
          text: 'Success',
          type: TypeBtn.success,
          style: style,
          onPressed: () {},
        ),
        BtnUI(
          text: 'Warning',
          type: TypeBtn.warning,
          style: style,
          onPressed: () {},
        ),
        BtnUI(
          text: 'Danger',
          type: TypeBtn.danger,
          style: style,
          onPressed: () {},
        ),
        BtnUI(
          text: 'Loading',
          type: TypeBtn.primary,
          style: style,
          loading: true,
          onPressed: () {},
        ),
        BtnUI(
          text: 'Disabled',
          type: TypeBtn.primary,
          style: style,
          disabled: true,
          onPressed: () {},
        ),
        BtnUI(
          text: 'Icon',
          icon: Icons.star,
          type: TypeBtn.primary,
          style: style,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBadgeRow(StyleBadge style) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        BadgeUI(text: 'Primary', type: TypeBadge.primary, style: style),
        BadgeUI(text: 'Secondary', type: TypeBadge.secondary, style: style),
        BadgeUI(text: 'Success', type: TypeBadge.success, style: style),
        BadgeUI(text: 'Danger', type: TypeBadge.danger, style: style),
        BadgeUI(text: 'Warning', type: TypeBadge.warning, style: style),
        BadgeUI(text: 'Info', type: TypeBadge.info, style: style),
        BadgeUI(text: 'Light', type: TypeBadge.light, style: style),
        BadgeUI(text: 'Dark', type: TypeBadge.dark, style: style),
        BadgeUI(
          text: 'Loading',
          type: TypeBadge.primary,
          style: style,
          loading: true,
        ),
        BadgeUI(
          text: 'Icon',
          icon: Icons.star,
          type: TypeBadge.primary,
          style: style,
        ),
        BadgeUI(
          text: 'Warning Icon',
          icon: Icons.warning,
          type: TypeBadge.warning,
          style: style,
        ),
      ],
    );
  }
}
