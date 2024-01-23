import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/common.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class Data extends ConsumerStatefulWidget {
  const Data({super.key});

  @override
  ConsumerState createState() => _DataState();
}

class _DataState extends ConsumerState<Data> {
  final TextEditingController iconController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  List<Map<String, String>> dropdownItems = [
    {'value': 'mtn', 'image': ImageConstant.mtn},
    {'value': 'airtel', 'image': ImageConstant.airtel},
    {'value': 'glo', 'image': ImageConstant.glo},
    {'value': '9mobile', 'image': ImageConstant.nineMobile},
    // Add more images as needed
  ];

  String? selectedValue = 'mtn';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.appbar(context, "Data"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Pallete.whiteColor,
                child: Row(
                  children: [
                    DropdownButton(
                      value: selectedValue,
                      elevation: 0,
                      underline: Container(),
                      itemHeight: 50,
                      items: dropdownItems.map((item) {
                        return DropdownMenuItem(
                          value: item['value'],
                          child: Row(
                            children: [
                              ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Image.asset(
                                    item['image']!,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                    Gap(10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: numberController,
                          keyboardType: TextInputType.number,
                          decoration: StyleConstant.input.copyWith(
                            hintText: 'Phone number',
                            fillColor: Pallete.whiteColor,
                          ),
                          validator: (value) {
                            return value?.length == 11
                                ? null
                                : "input valid number";
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: GridDataWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class GridDataWidget extends StatelessWidget {
  const GridDataWidget({super.key});

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
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
              color: Pallete.scaffoldColor,
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
