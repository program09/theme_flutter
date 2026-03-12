import 'package:flutter/material.dart';

// Type input general
class Type {
  static const TextInputType text = TextInputType.text;
  static const TextInputType number = TextInputType.number;
  static const TextInputType email = TextInputType.emailAddress;
  static const TextInputType password = TextInputType.visiblePassword;
  static const TextInputType phone = TextInputType.phone;
  static const TextInputType multiline = TextInputType.multiline;
  static const TextInputType datetime = TextInputType.datetime;
  static const TextInputType url = TextInputType.url;
  static TextInputType numberWithOptions({
    bool signed = false,
    bool decimal = false,
  }) => TextInputType.numberWithOptions(signed: signed, decimal: decimal);
}

// Option select value label
class Option {
  final String value;
  final String label;

  const Option({required this.value, required this.label});

  @override
  String toString() {
    return "Option(value: $value, label: $label)";
  }
}

// start. InputUI

class InputUI extends StatefulWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final bool disabled;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSubmitted;
  final bool autovalidate;
  final FocusNode? focusNode;
  const InputUI({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.disabled = false,
    this.type = TextInputType.text,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.onSubmitted,
    this.autovalidate = false,
    this.focusNode,
  });

  @override
  State<InputUI> createState() => _InputUIState();
}

class _InputUIState extends State<InputUI> {
  bool isPasswordVisible = false;

  Widget? icon() {
    return widget.type == Type.password
        ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          )
        : widget.suffixIcon != null
        ? Icon(widget.suffixIcon)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      autovalidateMode: widget.autovalidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      controller: widget.controller,
      enabled: !widget.disabled,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelText: widget.label,
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
        hintText: widget.type == Type.password ? '••••••••' : widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: icon(),
      ),
      keyboardType: widget.type,
      obscureText: widget.type == Type.password && !isPasswordVisible,
      maxLines: widget.type == Type.multiline ? 3 : 1,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}

// end. InputUI

// start: InputUIAutocomplete

class InputAutocompleteUI extends StatefulWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final bool disabled;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final List<Option>? options;
  final AutocompleteOptionsBuilder<Option>? optionsBuilder;
  final void Function(Option)? onSelected;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSubmitted;
  final bool autovalidate;

  const InputAutocompleteUI({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.disabled = false,
    this.type = TextInputType.text,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.options,
    this.optionsBuilder,
    this.onSelected,
    this.onChanged,
    this.validator,
    this.onSubmitted,
    this.autovalidate = false,
  });

  @override
  State<InputAutocompleteUI> createState() => _InputAutocompleteUIState();
}

class _InputAutocompleteUIState extends State<InputAutocompleteUI> {
  bool isPasswordVisible = false;

  Widget? icon() {
    return widget.type == Type.password
        ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          )
        : widget.suffixIcon != null
        ? Icon(widget.suffixIcon)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<Option>(
          displayStringForOption: (Option option) => option.label,
          optionsBuilder:
              widget.optionsBuilder ??
              (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Option>.empty();
                }

                final options = (widget.options ?? []).where((Option option) {
                  return option.label.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });

                if (options.length == 1 &&
                    options.first.label == textEditingValue.text) {
                  return const Iterable<Option>.empty();
                }

                return options;
              },
          onSelected: (Option option) {
            widget.controller.text = option.label;
            FocusScope.of(context).unfocus();
            if (widget.onSelected != null) {
              widget.onSelected!(option);
            }
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                // Sincronizar controladores si es necesario
                if (widget.controller.text != textEditingController.text &&
                    widget.controller.text.isNotEmpty) {
                  textEditingController.text = widget.controller.text;
                }

                return InputUI(
                  label: widget.label,
                  hintText: widget.hintText,
                  controller: textEditingController,
                  type: widget.type,
                  errorText: widget.errorText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  onChanged: (value) {
                    widget.controller.text = value!;
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
                  validator: widget.validator,
                  focusNode: focusNode,
                  onSubmitted: (value) {
                    onFieldSubmitted();
                    if (widget.onSubmitted != null) {
                      widget.onSubmitted!(value);
                    }
                  },
                  autovalidate: widget.autovalidate,
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 8.0,
                shadowColor: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor,
                child: Container(
                  width: constraints.maxWidth,
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Option option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              option.label,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// end: InputAutocompleteUI

// start: SelectUI

class SelectUI extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final List<Option>? options;
  final String? value;
  final ValueChanged<Option?>? onChanged;
  final String? Function(Option?)? validator;
  final bool disabled;
  final IconData? prefixIcon;

  const SelectUI({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.options,
    this.value,
    this.onChanged,
    this.validator,
    this.disabled = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = options == null || options!.isEmpty;
    final String effectiveHint = isEmpty
        ? 'No hay opciones disponibles'
        : (hintText ?? 'Seleccionar una opcion');

    Option? getOption() {
      if (value == null || options == null) return null;
      try {
        return options!.firstWhere(
          (option) => option.value.toString() == value.toString(),
        );
      } catch (_) {
        return null;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<Option>(
          initialSelection: getOption(),
          width: constraints.maxWidth,
          menuHeight: 250,
          menuStyle: MenuStyle(
            elevation: const WidgetStatePropertyAll(8.0),
            shadowColor: WidgetStatePropertyAll(
              Colors.black.withValues(alpha: 0.4),
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          label: Text(label),
          hintText: effectiveHint,
          errorText: errorText,
          enabled: !(disabled || isEmpty),
          leadingIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          dropdownMenuEntries: options!
              .map(
                (option) => DropdownMenuEntry<Option>(
                  value: option,
                  label: option.label,
                ),
              )
              .toList(),
          onSelected: (Option? value) {
            onChanged?.call(value);
          },
        );
      },
    );
  }
}

// end: SelectUI

// start: SwitchUI

Widget switchUI({required bool value, required Function onChecked}) {
  return Switch(value: value, onChanged: (value) => onChecked(value));
}

// end: SwitchUI

// start: TabsUI

enum PositionTab { top, bottom }

enum AlignmentTab { start, end, center }

class TabItem {
  final String id;
  final String label;
  final IconData icon;
  final Widget child; // contenido del tab
  final bool showTab; // mostrar en la lista de tabs
  final bool showIconFocus;
  final int? badge; // numero de notificaciones
  final bool? loading;
  const TabItem({
    required this.id,
    required this.label,
    required this.icon,
    this.showTab = true,
    this.showIconFocus = true,
    this.badge,
    this.loading = false,
    required this.child,
  });
}

class TabsUI extends StatefulWidget {
  final List<TabItem> tabs;
  final PositionTab position;
  final AlignmentTab alignment;
  final Color? activeColor;
  final Color? inactiveColor;
  final List<String> hiddenTabs;
  final Function(TabItem)? onTap;
  final int initialIndex;

  const TabsUI({
    super.key,
    required this.tabs,
    this.position = PositionTab.top,
    this.alignment = AlignmentTab.center,
    this.activeColor,
    this.inactiveColor,
    this.hiddenTabs = const [],
    this.initialIndex = 0,
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

    _currentIndex = widget.initialIndex;
    if (_currentIndex >= _visibleTabs.length) {
      _currentIndex = 0;
    }

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
                          if (tab.loading == true) ...[
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ] else if (!tab.showIconFocus || isSelected) ...[
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

// end: TabsUI
