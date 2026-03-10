import 'package:flutter/material.dart';
import 'package:ui/examples/tabs/alerts.dart';
import 'package:ui/examples/tabs/forms.dart';
import 'package:ui/examples/tabs/profile.dart';
import 'package:ui/widgets/layouts/tabs.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final GlobalKey<FormsExampleState> formsKey = GlobalKey<FormsExampleState>();
  final GlobalKey<ProfileExampleState> profileKey =
      GlobalKey<ProfileExampleState>();
  final GlobalKey<AlertsExampleState> alertsKey =
      GlobalKey<AlertsExampleState>();
  final GlobalKey<TabsUIState> tabsKey = GlobalKey<TabsUIState>();
  late List<TabItem> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      TabItem(
        id: 'forms',
        label: 'Formularios',
        icon: Icons.input,
        child: FormsExample(
          key: formsKey,
          keytab: tabsKey,
          tabId: 'forms',
          data: const {'name': 'Formularios'},
        ),
      ),
      TabItem(
        id: 'buttons',
        label: 'Botones',
        icon: Icons.smart_button_rounded,
        child: ProfileExample(
          key: profileKey,
          keytab: tabsKey,
          tabId: 'buttons',
          data: const {'name': 'Botones'},
        ),
        badge: 1,
      ),
      TabItem(
        id: 'alerts',
        label: 'Alertas',
        icon: Icons.notifications,
        child: AlertsExample(
          key: alertsKey,
          keytab: tabsKey,
          tabId: 'alerts',
          data: const {'name': 'Alertas'},
        ),
        badge: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('Example UI'),
              floating: true, // ocultar appbar al bajar
              snap: true, // mostrar appbar al subir
              pinned: false, // appbar static
              elevation: innerBoxIsScrolled ? 4 : 0,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              actions: [
                IconButton(
                  onPressed: () {
                    // Ejemplo de cómo establecer el badge
                    tabsKey.currentState?.setBadge('perfil', 5);
                  },
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () async {
                    final options = await formsKey.currentState?.getOptions();
                    final options2 = await profileKey.currentState
                        ?.getOptionssdf();
                    print('Options: $options');
                    print('Options2: $options2');
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ];
        },
        body: TabsUI(
          key: tabsKey,
          position: PositionTab.top,
          alignment: AlignmentTab.start,
          onTap: (tab) async {
            print('Tab: ${tab.id}');
          },
          tabs: _tabs,
        ),
      ),
    );
  }
}
