import 'package:flutter/material.dart';

class TabItem {
  final String id;
  final String label;
  final IconData icon;
  final Widget child; // contenido del tab
  final bool showTab; // mostrar en la lista de tabs
  final bool showIconFocus;
  final int? badge; // numero de notificaciones
  const TabItem({
    required this.id,
    required this.label,
    required this.icon,
    this.showTab = true,
    this.showIconFocus = true,
    this.badge,
    required this.child,
  });
}

enum PositionTab { top, bottom }

enum AlignmentTab { start, end, center }

class TabsUI extends StatefulWidget {
  final List<TabItem> tabs;
  final PositionTab position;
  final AlignmentTab alignment;
  final Color? activeColor;
  final Color? inactiveColor;
  final List<String> hiddenTabs;
  final Function(TabItem)? onTap;

  const TabsUI({
    super.key,
    required this.tabs,
    this.position = PositionTab.top,
    this.alignment = AlignmentTab.center,
    this.activeColor,
    this.inactiveColor,
    this.hiddenTabs = const [],
    this.onTap,
  });

  @override
  State<TabsUI> createState() => TabsUIState();
}

class TabsUIState extends State<TabsUI> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late List<TabItem> _visibleTabs;
  late List<GlobalKey> _tabKeys;

  // Mapa para gestionar badges de forma dinámica
  final Map<String, int?> _badges = {};

  @override
  void initState() {
    super.initState();
    _updateVisibleTabs();
    _pageController = PageController(initialPage: _currentIndex);

    // Inicializar badges desde los TabItems
    for (var tab in widget.tabs) {
      _badges[tab.id] = tab.badge;
    }
  }

  @override
  void didUpdateWidget(TabsUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateVisibleTabs();

    // Sincronizar badges si cambian los tabs desde el padre
    for (var tab in widget.tabs) {
      if (!_badges.containsKey(tab.id) ||
          tab.badge !=
              oldWidget.tabs
                  .firstWhere((t) => t.id == tab.id, orElse: () => tab)
                  .badge) {
        _badges[tab.id] = tab.badge;
      }
    }
  }

  void setBadge(String tabId, int? count) {
    if (mounted) {
      setState(() {
        _badges[tabId] = count;
      });
    }
  }

  void _updateVisibleTabs() {
    _visibleTabs = widget.tabs.where((tab) {
      return tab.showTab && !widget.hiddenTabs.contains(tab.id);
    }).toList();
    _tabKeys = List.generate(_visibleTabs.length, (index) => GlobalKey());
    if (_currentIndex >= _visibleTabs.length && _visibleTabs.isNotEmpty) {
      _currentIndex = _visibleTabs.length - 1;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToTab(int index) {
    if (index < 0 || index >= _tabKeys.length) return;
    final context = _tabKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if ((_pageController.page!.round() - index).abs() > 1) {
      _pageController.jumpToPage(index);
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }

    _scrollToTab(index);
    widget.onTap?.call(_visibleTabs[index]);
  }

  Widget _buildTabBar(BoxConstraints constraints) {
    if (_visibleTabs.isEmpty) return const SizedBox.shrink();

    MainAxisAlignment mainAxisAlignment;
    switch (widget.alignment) {
      case AlignmentTab.start:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case AlignmentTab.center:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case AlignmentTab.end:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: widget.position == PositionTab.top
            ? Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              )
            : Border(
                top: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: List.generate(_visibleTabs.length, (index) {
              final tab = _visibleTabs[index];
              final isSelected = _currentIndex == index;
              final theme = Theme.of(context);
              final currentBadge = _badges[tab.id];

              return Padding(
                key: _tabKeys[index],
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Badge(
                  label: currentBadge != null
                      ? Text(currentBadge.toString())
                      : null,
                  isLabelVisible: currentBadge != null,
                  backgroundColor: theme.colorScheme.error,
                  textColor: theme.colorScheme.onPrimary,
                  alignment: const Alignment(0.9, -0.9),
                  child: InkWell(
                    onTap: () => _onTabTapped(index),
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (widget.activeColor ?? theme.colorScheme.primary)
                            : (widget.inactiveColor ??
                                  theme.colorScheme.surface.withValues(
                                    alpha: 0,
                                  )),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!tab.showIconFocus || isSelected) ...[
                            Icon(
                              tab.icon,
                              size: 17.5,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleTabs.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabBar = _buildTabBar(constraints);
        final content = Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _scrollToTab(index);
            },
            physics: const BouncingScrollPhysics(),
            children: _visibleTabs
                .map((tab) => _KeepAliveWrapper(child: tab.child))
                .toList(),
          ),
        );

        return Column(
          children: [
            if (widget.position == PositionTab.top) ...[
              tabBar,
              content,
            ] else ...[
              content,
              tabBar,
            ],
          ],
        );
      },
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
