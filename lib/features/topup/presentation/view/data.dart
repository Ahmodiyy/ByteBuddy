import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/common.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Data extends ConsumerStatefulWidget {
  const Data({super.key});

  @override
  ConsumerState createState() => _DataState();
}

class _DataState extends ConsumerState<Data> {
  final TextEditingController iconController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  IconLabel? selectedIcon;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.appbar(context, "Data"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  DropdownMenu<IconLabel>(
                    controller: iconController,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    leadingIcon: const Icon(Icons.search),
                    label: const Text('Icon'),
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    onSelected: (IconLabel? icon) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    dropdownMenuEntries:
                        IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
                      (IconLabel icon) {
                        return DropdownMenuEntry<IconLabel>(
                          value: icon,
                          label: icon.label,
                          leadingIcon: Icon(icon.icon),
                        );
                      },
                    ).toList(),
                  ),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: StyleConstant.input.copyWith(
                      hintText: 'Phone number',
                    ),
                    validator: (value) {
                      return value?.length == 11 ? null : "input valid number";
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItemWidget extends StatelessWidget {
  const GridItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the corner radius as needed
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            mainAxisExtent: 65),

        itemCount: 4, // Total number of items (rows * columns)
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: SizedBox(
              height: 50.0,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(""),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'svgs[index].text',
                        style: context.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// DropdownMenuEntry labels and values for the first dropdown menu.
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

// DropdownMenuEntry labels and values for the second dropdown menu.
enum IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud(
    'Cloud',
    Icons.cloud_outlined,
  ),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  ColorLabel? selectedColor;
  IconLabel? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownMenu<ColorLabel>(
                      initialSelection: ColorLabel.green,
                      controller: colorController,
                      // requestFocusOnTap is enabled/disabled by platforms when it is null.
                      // On mobile platforms, this is false by default. Setting this to true will
                      // trigger focus request on the text field and virtual keyboard will appear
                      // afterward. On desktop platforms however, this defaults to true.
                      requestFocusOnTap: true,
                      label: const Text('Color'),
                      onSelected: (ColorLabel? color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      dropdownMenuEntries: ColorLabel.values
                          .map<DropdownMenuEntry<ColorLabel>>(
                              (ColorLabel color) {
                        return DropdownMenuEntry<ColorLabel>(
                          value: color,
                          label: color.label,
                          enabled: color.label != 'Grey',
                          style: MenuItemButton.styleFrom(
                            foregroundColor: color.color,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 24),
                    DropdownMenu<IconLabel>(
                      controller: iconController,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('Icon'),
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      onSelected: (IconLabel? icon) {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      dropdownMenuEntries:
                          IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
                        (IconLabel icon) {
                          return DropdownMenuEntry<IconLabel>(
                            value: icon,
                            label: icon.label,
                            leadingIcon: Icon(icon.icon),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
              if (selectedColor != null && selectedIcon != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'You selected a ${selectedColor?.label} ${selectedIcon?.label}'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        selectedIcon?.icon,
                        color: selectedColor?.color,
                      ),
                    )
                  ],
                )
              else
                const Text('Please select a color and an icon.')
            ],
          ),
        ),
      ),
    );
  }
}
