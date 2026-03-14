import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/examples/tabs/alerts.dart';
import 'package:ui/examples/tabs/forms.dart';
import 'package:ui/examples/tabs/profile.dart';
import 'package:ui/main.dart';
import 'package:ui/routers/go.dart';
import 'package:ui/routers/go_error.dart';
import 'package:ui/ui/forms.dart';

// -------------------- USE EXAMPLE -------------------------

// ─────────────────────────────────────────
//  Rutas nombradas
// ─────────────────────────────────────────
class Routes {
  Routes._();

  static const String home = '/';
  static const String example = '/example';
}

// ─────────────────────────────────────────
//  Páginas / binding
// ─────────────────────────────────────────
class AppPages {
  AppPages._();
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.example,
      page: () {
        final projectId = GoArgs.args('projectId');
        final id = GoArgs.args('id');
        return FutureBuilder(
          future: () async {
            await Future.delayed(const Duration(milliseconds: 500));

            if (projectId == null || id == null) {
              throw ErrorCode.notFound ;
            }

            try {
              return {'id': id, 'projectId': projectId.toString()};
            } catch (e) {
              throw 'Error al consultar la base de datos: $e';
            }
          }(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }

            if (snapshot.hasError) {
              return ErrorScreen(message: snapshot.error.toString());
            }

            final result = snapshot.data as Map<String, dynamic>;
            // Pasas los datos a tu widget Example
            return Example(id: id, projectId: result['projectId']);
          },
        );
      },
      transition: Transition.fadeIn,
    ),
  ];
}

class Example extends StatefulWidget {
  final int id;
  final String? projectId;
  const Example({super.key, required this.id, this.projectId});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final GlobalKey<FormsExampleState> formsKey = GlobalKey<FormsExampleState>();
  final GlobalKey<ProfileExampleState> profileKey =
      GlobalKey<ProfileExampleState>();
  final GlobalKey<AlertsExampleState> alertsKey =
      GlobalKey<AlertsExampleState>();
  final GlobalKey<TabsUIState> _tabsKey = GlobalKey<TabsUIState>();
  late List<TabItem> _tabs;

  String title = 'Example UI';

  int selectedTab = 1;

  void onTabTapped(String tabLabel) {
    setState(() {
      title = tabLabel;
    });
  }

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
          keytab: _tabsKey,
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
          keytab: _tabsKey,
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
          keytab: _tabsKey,
          tabId: 'alerts',
          data: const {'name': 'Alertas'},
        ),
        badge: 1,
      ),
    ];

    onTabTapped(_tabs[selectedTab].label);
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
              title: Text('$title (ID: ${widget.id}, P: ${widget.projectId})'),

              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Go.back(result: 'hola'),
              ),
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
                    _tabsKey.currentState?.setBadge('perfil', 5);
                  },
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () async {
                    final options = await formsKey.currentState?.getOptions();
                    final options2 = await profileKey.currentState
                        ?.getOptionssdf();
                    log('Options: $options');
                    log('Options2: $options2');
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ];
        },
        body: TabsUI(
          key: _tabsKey,
          initialIndex: selectedTab,
          position: PositionTab.top,
          alignment: AlignmentTab.start,
          onTap: (tab) async {
            log('Tab: ${tab.id}');
            onTabTapped(tab.label);
          },
          tabs: _tabs,
        ),
      ),
    );
  }
}
