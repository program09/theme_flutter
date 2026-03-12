import 'package:flutter/material.dart';
import 'package:ui/ui/components.dart';
import 'package:ui/ui/forms.dart';

class AlertsExample extends StatefulWidget {
  final Map<String, dynamic>? data;
  final GlobalKey<TabsUIState> keytab;
  final String tabId;

  const AlertsExample({
    super.key,
    this.data,
    required this.keytab,
    required this.tabId,
  });

  @override
  State<AlertsExample> createState() => AlertsExampleState();
}

class AlertsExampleState extends State<AlertsExample> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Solid Alerts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildAlertsColumn(StyleAlert.solid),

        const SizedBox(height: 32),
        const Text(
          'Mica Alerts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildAlertsColumn(StyleAlert.mica),
      ],
    );
  }

  Widget _buildAlertsColumn(StyleAlert style) {
    return Column(
      children: [
        AlertsUI(
          message: 'A simple primary alert—check it out!',
          type: TypeAlert.primary,
          style: style,
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 16),
        AlertsUI(
          title: 'Success Alert',
          message: 'A simple success alert—check it out!',
          type: TypeAlert.success,
          style: style,
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 16),
        AlertsUI(
          title: 'Warning Alert',
          message: 'A simple warning alert—check it out!',
          type: TypeAlert.warning,
          style: style,
          icon: Icons.warning_amber_rounded,
        ),
        const SizedBox(height: 16),
        AlertsUI(
          title: 'Danger Alert',
          message: 'A simple danger alert—check it out!',
          type: TypeAlert.danger,
          style: style,
          icon: Icons.error_outline,
        ),
        const SizedBox(height: 16),
        AlertsUI(
          title: 'Light Alert',
          message: 'A simple light alert with no icon.',
          type: TypeAlert.light,
          style: style,
        ),
        const SizedBox(height: 16),
        AlertsUI(
          title: '',
          message: 'Dark Alert with just a message and an icon.',
          type: TypeAlert.dark,
          style: style,
          icon: Icons.dark_mode_outlined,
        ),
      ],
    );
  }
}
