import 'package:flutter/material.dart';
import 'package:ui/widgets/forms/input.dart';
import 'package:ui/widgets/forms/input_autocomplete.dart';
import 'package:ui/widgets/forms/options.dart';
import 'package:ui/widgets/forms/select.dart';
import 'package:ui/widgets/forms/switch.dart';
import 'package:ui/widgets/layouts/tabs.dart';

class FormsExample extends StatefulWidget {
  final Map<String, dynamic>? data;
  final GlobalKey<TabsUIState> keytab;
  final String tabId;
  const FormsExample({
    super.key,
    this.data,
    required this.keytab,
    required this.tabId,
  });

  @override
  FormsExampleState createState() => FormsExampleState();
}

class FormsExampleState extends State<FormsExample> {
  bool _value = false;

  void save() {
    print('Guardando Tab de Forms...');
  }

  Future<List<Option>> getOptions() async {
    return [
      Option(value: '1', label: 'Option 1 Forms'),
      Option(value: '2', label: 'Option 2 Forms'),
      Option(value: '3', label: 'Option 3 Forms'),
      Option(value: '4', label: 'Option 4 Forms'),
      Option(value: '5', label: 'Option 5 Forms'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    switchUI(
                      value: _value,
                      onChecked: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    SelectUI(
                      label: 'Opciones as',
                      value: '55',
                      options: const [
                        Option(value: '1', label: 'Option 1'),
                        Option(value: '2', label: 'Option 2'),
                        Option(value: '3', label: 'Option 3'),
                        Option(value: '4', label: 'Option 4'),
                        Option(value: '5', label: 'Option 5'),
                        Option(value: '6', label: 'Option 6'),
                        Option(value: '7', label: 'Option 7'),
                        Option(value: '8', label: 'Option 8'),
                        Option(value: '9', label: 'Option 9'),
                        Option(value: '10', label: 'Option 10'),
                      ],
                      onChanged: (Option? value) {},
                    ),
                    const SizedBox(height: 20),
                    SelectUI(
                      label: 'Error Select',
                      errorText: 'Error',
                      options: const [
                        Option(value: '1', label: 'Option 1'),
                        Option(value: '2', label: 'Option 2'),
                        Option(value: '3', label: 'Option 3'),
                      ],
                      onChanged: (value) {
                        widget.keytab.currentState?.setBadge(widget.tabId, 4);
                      },
                    ),
                    const SizedBox(height: 20),
                    SelectUI(
                      label: 'Empty Select',
                      options: const [],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    InputAutocompleteUI(
                      label: 'Autocomplete',
                      hintText: 'Search...',
                      controller: TextEditingController(),
                      options: const [
                        Option(value: '1', label: 'Option 1'),
                        Option(value: '2', label: 'Option 2'),
                        Option(value: '3', label: 'Option 3'),
                        Option(value: '4', label: 'Option 4'),
                        Option(value: '5', label: 'Option 5'),
                        Option(value: '6', label: 'Option 6'),
                        Option(value: '7', label: 'Option 7'),
                        Option(value: '8', label: 'Option 8'),
                        Option(value: '9', label: 'Option 9'),
                        Option(value: '10', label: 'Option 10'),
                      ],
                      prefixIcon: Icons.search,
                      onSelected: (value) {
                        print('Selected: $value');
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Text',
                      hintText: 'Hint',
                      disabled: true,
                      controller: TextEditingController(),
                      type: Type.text,
                      errorText: 'Error',
                      prefixIcon: Icons.person,
                      suffixIcon: Icons.person,
                      onChanged: (value) {},
                      validator: (value) {
                        return value;
                      },
                      onSubmitted: (value) {},
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Email',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.email,
                      errorText: 'Error init',
                      onChanged: (value) {},
                      autovalidate: true,
                      onSubmitted: (value) {},
                      validator: (value) {
                        if (value!.length > 3) return 'ggggg';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Password',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.password,
                      errorText: null,
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Phone',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.phone,
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Number',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.number,
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Multiline',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.multiline,
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Datetime',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.datetime,
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Url',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.url,
                    ),
                    const SizedBox(height: 20),
                    InputUI(
                      label: 'Number with options',
                      hintText: 'Hint',
                      controller: TextEditingController(),
                      type: Type.numberWithOptions(decimal: true, signed: true),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
